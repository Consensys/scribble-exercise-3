# Scribble Exercise 3

In this exercise we're going to have a look at a vulnerable ownable smart
contract. We'll use Scribble to annotate it with properties, and use the MythX service (and more specifically the fuzzing engine behind it) to automatically check the properties (and find the bug 🐛).

### Handy Links
Scribble Repository -> https://github.com/ConsenSys/Scribble

Mythril Repository -> https://github.com/ConsenSys/Mythril

Scribble Docs 📚 -> https://docs.scribble.codes/

MythX Dashboard -> https://dashboard.mythx.io

### Installation
```
# We'll need the mythx-cli client:
pip3 install mythx-cli

# Make sure to use node 12-14
npm install eth-scribble --global
```

Also you will need a **developer MythX account** and the associated API key.

### Setting up the target

```
git clone git@github.com:ConsenSys/scribble-exercise-3.git
cd scribble-exercise-3
```


### Finding the vulnerability
The vulnerability can be triggered from the `transferOwnership()` function. This function changes the current owner to the argument `newOwner`. Normally, it's desirable that not just anyone can perform this action. Otherwise anyone could make themselves the owner of the contract. Unfortunately that check is missing!

```solidity
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public   {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
```
### Adding annotations

There is an if_succeeds property which would perfectly in this scenario:

```
/// #if_succeeds old(_owner) == msg.sender;
function transferOwnership(address newOwner) public {
    ...
}
```

Nice! Or not?

This annotation covers only this particular function. What if there is another function where we forgot to add the proper access control. Then we'd still have a vulnerability on our hands.

This is where `if_updated` annotations are perfect. Instead of annotating a function or contract with the desired properties, we annotate a variable. This property is then checked atall locations thatthe variable is changed. That way we get to cover all updates, even the ones we might have forgotten!

<details>
<summary> Property: If the owner is updated then it must have been done by the previous owner (unless the owner variable is currently beeing initialized). </summary>
<br>
<pre>
    /// #if_updated {:msg "Only the owner can update this variable"} old(_owner == msg.sender) || old(_owner ==  address(0x0));
    address private _owner;
</pre>

</details>
