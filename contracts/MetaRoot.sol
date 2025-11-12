// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MetaRoot {
    // State variables
    address public owner;
    string public contractName;
    uint256 public creationTime;

    // Mapping for storing meta data against a key
    mapping(string => string) private metaData;

    // Events
    event MetaDataSet(string indexed key, string value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ContractRenamed(string oldName, string newName);

    // Modifier to restrict to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    // Constructor
    constructor() {
        owner = msg.sender;
        contractName = "MetaRoot";
        creationTime = block.timestamp;
    }

    // Ownership functions
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // Rename contract function
    function renameContract(string calldata newName) external onlyOwner {
        require(bytes(newName).length > 0, "Name cannot be empty");
        string memory oldName = contractName;
        contractName = newName;
        emit ContractRenamed(oldName, newName);
    }

    // Set metadata function
    function setMetaData(string calldata key, string calldata value) external onlyOwner {
        require(bytes(key).length > 0, "Key cannot be empty");
        metaData[key] = value;
        emit MetaDataSet(key, value);
    }

    // Get metadata function
    function getMetaData(string calldata key) external view returns (string memory) {
        return metaData[key];
    }

    // Remove metadata function
    function removeMetaData(string calldata key) external onlyOwner {
        require(bytes(metaData[key]).length != 0, "Key does not exist");
        delete metaData[key];
        emit MetaDataSet(key, "");
    }

    // Utility function to get current block timestamp
    function getCurrentTime() external view returns (uint256) {
        return block.timestamp;
    }

    // Utility function to get contract age in seconds
    function getContractAge() external view returns (uint256) {
        return block.timestamp - creationTime;
    }

    // Fallback and receive functions to accept ETH (if needed)
    receive() external payable {}

    fallback() external payable {}

    // Withdraw ETH from contract by owner
    function withdraw(uint256 amount) external onlyOwner {
        payable(owner).transfer(amount);
    }
}
