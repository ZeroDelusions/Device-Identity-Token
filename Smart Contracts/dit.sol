// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";



// import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {TablelandDeployments} from "@tableland/evm/contracts/utils/TablelandDeployments.sol";
import {SQLHelpers} from "@tableland/evm/contracts/utils/SQLHelpers.sol";

interface IDITDatabase {
    function signaturesUsed(bytes memory) external view returns (bool);
    function addUsedSignature(bytes memory) external;
    function getTableName() external view returns (string memory);
    function insertIntoTable(
        uint256 id, 
        string memory name,
        string memory description,
        string memory image,

        string memory state,
        string memory wallet_address,
        string memory device_id,
        string memory model_name,
        string memory screen_size,
        string memory os_version,
        string memory last_update,
        string memory dit_hash
    ) external;

    function updateDIT(
        uint256 tokenId,
        string memory description,
        string memory os_version,
        string memory last_update,
        string memory dit_hash
    ) external;

    function updateState(uint256 id, uint8 state) external;
    function deleteFromTable(uint256 tokenId) external;
}

contract DITController is Ownable, ERC721 /* ERC721URIStorage ,*/ {

    using ECDSA for bytes32;

    address private _appPublicKey;
    IDITDatabase private _DITDatabase;
    
    // The Tableland gateway URL 
    string private _baseURIString = "https://testnets.tableland.network/api/v1/query?extract=true&unwrap=true&statement="; 

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    /** ---------------------------------------------------------------------
    *
    *  Ensure the recovered signer matches the claimed app public key:
    *  While being not the most elegant and efficient solution, 
    *  it's only one possible to recover SwiftUI app generated signature.
    *  web3swift alternative for 'bytes32' is 'BigUInt', that doesn't get accepted by solidity
    *  There is no alternative for 'bytes'     
    *  converting hex string directly to bytes will create 132 byte long string, being incorrect
    *  So passing message hash and signature as strings and manually converting chars by pairs is the way.
    *
    */

    event DITMinted(string device_id);
    event DITStateChanged(address owner);

    modifier onlyApp(string calldata message, string calldata signature) {
        bytes32 _messageHash = bytes32(hexToBytes(message));
        bytes memory _signature = hexToBytes(signature);

        address recoveredAddress = ECDSA.recover(_messageHash, _signature);
        require(recoveredAddress == _appPublicKey, "Transaction must be signed by the authorized app.");

        _DITDatabase.addUsedSignature(_signature);
        _;
    }

    modifier uniqueSignature(string memory signature) {
        bytes memory _signature = hexToBytes(signature);
        require(!_DITDatabase.signaturesUsed(_signature), "Signature already used.");
        _;
    }

    function hexCharsToBytes(uint8 c) public pure returns (uint8) {
        if (bytes1(c) >= bytes1('0') && bytes1(c) <= bytes1('9')) {
            return c - uint8(bytes1('0'));
        }
        if (bytes1(c) >= bytes1('a') && bytes1(c) <= bytes1('f')) {
            return 10 + c - uint8(bytes1('a'));
        }
        if (bytes1(c) >= bytes1('A') && bytes1(c) <= bytes1('F')) {
            return 10 + c - uint8(bytes1('A'));
        } 
        revert("fail");
    }

    // Convert an hexadecimal string to raw bytes
    function hexToBytes(string memory s) public pure returns (bytes memory) {
        bytes memory ss = bytes(s);
        require(ss.length%2 == 0); // length must be even
        bytes memory r = new bytes(ss.length/2);
        for (uint i=0; i<ss.length/2; ++i) {
            r[i] = bytes1(
                hexCharsToBytes(uint8(ss[2*i])) * 16 + 
                hexCharsToBytes(uint8(ss[2*i+1]))
            );
        }
        return r;
    }

    // ---------------------------------------------------------------------

    constructor(
        address DITDatabaseAddress
    ) ERC721("Device Identity Token", "DIT") Ownable(msg.sender) {
        _DITDatabase = IDITDatabase(DITDatabaseAddress);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
      return super.supportsInterface(interfaceId);
    }

    function totalSupply() public view returns(uint256) {
        return _tokenIdCounter.current();
    }

    function getDITDatabaseName() public view returns (string memory) {
        return _DITDatabase.getTableName();
    }

    function getDITDatabase() public view returns (IDITDatabase) {
        return _DITDatabase;
    }

    function setDITDatabase(address DITDatabaseAddress) public onlyOwner {
        _DITDatabase = IDITDatabase(DITDatabaseAddress);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseURIString;
    }

    function setBaseURI(string memory baseURIString) public onlyOwner {
        _baseURIString = baseURIString;
    }

    function getAppPublicKey() public view returns (address) {
        return _appPublicKey;
    }

    function setAppPublicKey(address appPublicKey) public onlyOwner {
        _appPublicKey = appPublicKey;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721) 
        returns (string memory)
    {
        require(
            ownerOf(tokenId) != address(0),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory baseURI = _baseURI();
        if (bytes(baseURI).length == 0) {
            return "";
        }

        string memory ditTable = _DITDatabase.getTableName();
        
        string memory query = string.concat(
            "select%20json_object%28%27id%27%2C",
            ditTable, "%2Eid%2C%27name%27%2C", 
            // ditTable, "%2Eid%7C%7C%27%20%27%7C%7C",
            ditTable, "%2Emodel_name%7C%7C%27%20%27%7C%7C",
            ditTable, "%2Eos_version%2C",
            "%27image%27%2C%27https%3A%2F%2Fgateway.pinata.cloud%2Fipfs%2FQmR11GfmA7typHXgmqgoLwz2qcSMLCu9Un4AacFZYLfn6s%27%2C",
            // "%27image%27%2C%27https%3A%2F%2Fgateway.pinata.cloud%2Fipfs%2F%27%7C%7C", ditTable, "%2Eimage%2C",
            "%27description%27%2C", ditTable, "%2Edescription%2C",
            "%27state%27%2C", ditTable, "%2Estate%2C",
            "%27wallet_address%27%2C", ditTable, "%2Ewallet_address%2C",
            "%27device_id%27%2C", ditTable, "%2Edevice_id%2C",
            "%27model_name%27%2C", ditTable, "%2Emodel_name%2C",
            "%27screen_size%27%2C", ditTable, "%2Escreen_size%2C",
            "%27os_version%27%2C", ditTable, "%2Eos_version%2C",
            "%27last_update%27%2C", ditTable, "%2Elast_update%2C",
            // "%27event_history%27%2Cjson%28", ditTable, "%2Eevent_history%29%2C",
            // "%27vrf%27%2C%20", ditTable, "%2Evrf%2C",
            "%27dit_hash%27%2C%20", ditTable, "%2Edit_hash%29",
            "%20from%20", ditTable, "%20where%20", ditTable, "%2Eid%20%3D%20"
        );
        return
        string(
            abi.encodePacked(
                baseURI, 
                query,
                Strings.toString(tokenId)
            )
        );
    }
 
    function mintDIT(
        address to,
        string memory name,
        string memory description,
        string memory image,

        string memory state,
        string memory wallet_address,
        string memory device_id,
        string memory model_name,
        string memory screen_size,
        string memory os_version,
        string memory last_update,
        string memory dit_hash,

        // Modifier data 
        string calldata message,
        string calldata signature
    ) external uniqueSignature(signature) onlyApp(message, signature) {
        uint256 tokenId = _tokenIdCounter.current();

        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        
        _DITDatabase.insertIntoTable(
            tokenId, 
            name,
            description,
            image,
            state,
            wallet_address,
            device_id,
            model_name,
            screen_size,
            os_version,
            last_update,
            dit_hash
        );

        emit DITMinted(device_id);
    }

    function updateDIT(
        uint256 tokenId,
        string memory description,
        string memory os_version,
        string memory last_update,
        string memory dit_hash,

        string calldata message,
        string calldata signature
    ) external uniqueSignature(signature) onlyApp(message, signature) {
        _DITDatabase.updateDIT(
            tokenId, 
            description, 
            os_version, 
            last_update, 
            dit_hash
        );
    }

    function burnDIT
    (
        uint256 tokenId,
        string calldata message,
        string calldata signature
    ) 
    external 
    uniqueSignature(signature) 
    onlyApp(message, signature) 
    {
        _burn(tokenId);
        _DITDatabase.deleteFromTable(tokenId);
        // tokensByOwners[msg.sender];
    }
    
}