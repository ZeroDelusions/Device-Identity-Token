// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import {TablelandDeployments} from "@tableland/evm/contracts/utils/TablelandDeployments.sol";
import {SQLHelpers} from "@tableland/evm/contracts/utils/SQLHelpers.sol";


/**
 * @title DITDatabase
 * @dev This contract manages the DIT database.
 */
contract DITDatabase is Ownable, ERC721Holder {

    // Signature mapping stored in database contract, not in dit, to avoid desync when reminting contracts 
    mapping(bytes => bool) public signaturesUsed; 
    mapping(address => bool) public allowlist;
    
    uint256 private _ditTableId; // Unique table ID
    string private constant _DIT_TABLE_PREFIX = "dit_data"; // Custom table prefix

    modifier onlyAllowed() {
        require(allowlist[msg.sender], "DITDatabase: caller is not allowed.");
        _;
    }

    function addToAllowlist(address _address) public onlyOwner {
        allowlist[_address] = true;
    }

    function removeFromAllowlist(address _address) public onlyOwner {
        allowlist[_address] = false;
    }

    function addUsedSignature(bytes memory signature) external onlyAllowed {
        signaturesUsed[signature] = true;
    }

    constructor() Ownable(msg.sender) {
        _ditTableId = _initializeDITTable();
    }

    function _initializeDITTable() private returns (uint256) {
        uint256 id = TablelandDeployments.get().create(
            address(this),
            SQLHelpers.toCreateFromSchema(
                "id int,"
                "name text,"
                "description text,"
                "image text,"

                "state text," // owned, listed, rented, escrowed
                "wallet_address text," 
                "device_id text," 
                "model_name text," 
                "screen_size text," 
                "os_version text,"
                "last_update text,"
                "dit_hash text", 
                _DIT_TABLE_PREFIX
            )
        );
        return id;
    }

    function getTableId() external view returns (uint256) {
        return _ditTableId;
    }

    function getTableName() external view returns (string memory) {
        return SQLHelpers.toNameFromId(_DIT_TABLE_PREFIX, _ditTableId);
    }

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
    ) external onlyAllowed {
        // Prepare the values string
        string memory values = string.concat(
            Strings.toString(id), ",",
            SQLHelpers.quote(name), ",",
            SQLHelpers.quote(description), ",",
            SQLHelpers.quote(image), ",",

            SQLHelpers.quote(state), ",",
            SQLHelpers.quote(wallet_address), ",",
            SQLHelpers.quote(device_id), ",",
            SQLHelpers.quote(model_name), ",",
            SQLHelpers.quote(screen_size), ",",
            SQLHelpers.quote(os_version), ",",
            SQLHelpers.quote(last_update), ",",
            SQLHelpers.quote(dit_hash)
        );

        TablelandDeployments.get().mutate(
            address(this), // Table owner, i.e., this contract
            _ditTableId,
            SQLHelpers.toInsert(
                _DIT_TABLE_PREFIX,
                _ditTableId,
                "id,"
                "name,"
                "description,"
                "image,"
                "state,"
                "wallet_address,"
                "device_id,"
                "model_name,"
                "screen_size,"
                "os_version,"
                "last_update,"
                "dit_hash",
                values
            )
        );
    }

    function updateDIT(
        uint256 tokenId,
        string memory description,
        string memory os_version,
        string memory last_update,
        string memory dit_hash
    ) external onlyAllowed {
        string memory setters = string.concat(
            "description=", SQLHelpers.quote(description), ",",
            "os_version=", SQLHelpers.quote(os_version), ",",
            "last_update=", SQLHelpers.quote(last_update), ",",
            "dit_hash=", SQLHelpers.quote(dit_hash)
        );
        string memory filters = string.concat(
            "id=", Strings.toString(tokenId)
        );
        TablelandDeployments.get().mutate(
            address(this),
            _ditTableId,
            SQLHelpers.toUpdate(_DIT_TABLE_PREFIX, _ditTableId, setters, filters)
        );
    }

    function updateState(uint256 id, uint8 state) external onlyAllowed {
        string memory setters = string.concat("state=", Strings.toString(state));
        string memory filters = string.concat(
            "id=",
            Strings.toString(id)
        );
        TablelandDeployments.get().mutate(
            address(this),
            _ditTableId,
            SQLHelpers.toUpdate(_DIT_TABLE_PREFIX, _ditTableId, setters, filters)
        );
    }

    // function deleteFromTable(string memory device_id) external onlyOwner {
    //     string memory filters = string.concat(
    //         "device_id=",
    //         SQLHelpers.quote(device_id)
    //     );
    //     TablelandDeployments.get().mutate(
    //         address(this),
    //         _ditTableId,
    //         SQLHelpers.toDelete(_DIT_TABLE_PREFIX, _ditTableId, filters)
    //     );
    // }

    function deleteFromTable(uint256 tokenId) external onlyAllowed {
        string memory filters = string.concat(
            "id=",
            Strings.toString(tokenId)
        );
        TablelandDeployments.get().mutate(
            address(this),
            _ditTableId,
            SQLHelpers.toDelete(_DIT_TABLE_PREFIX, _ditTableId, filters)
        );
    }

}


    // Set the ACL controller to enable row-level writes with dynamic policies
    // function setAccessControl(address controller) external {
    //     TablelandDeployments.get().setController(
    //         address(this), // Table owner, i.e., this contract
    //         _ditTableId,
    //         controller // Set the controller address—a separate controller contract
    //     );
    // }

    