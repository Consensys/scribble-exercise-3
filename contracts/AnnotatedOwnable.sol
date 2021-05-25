// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../utils/Context.sol";

///#define senderIsOwner() bool = _owner == msg.sender;
 contract Ownable is Context {
    /// #if_updated {:msg "Only the owner can update this variable"} old(_owner == msg.sender) || _owner ==  0x0;
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    /// #if_succeeds {:msg "After construction the owner is not 0"} _owner != 0;
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    /// #if_succeeds {:msg "returns owner" } $result == _owner;
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    /// #if_succeeds {:msg "Set's the owner to 0"} _owner == adress(0);
    /// #if_succeeds {:msg "can only be called by the owner"} old(_owner) == msg.sender;
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    /// #if_succeeds {:msg "You can never set the owner to 0"} _owner != address(0);
    /// #if_succeeds {:msg "can only be called by the owner"} old(_owner) == msg.sender;
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
