pragma solidity ^0.4.18;

/* 
   Token should follow ERC-20 Token Standard to be recognized as currency
   https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
*/
contract MyToken {
  // public variables of the token
  string public name;
  string public symbol;
  uint8 public decimals = 18;
  uint256 public totalSupply;

  // create a public associative array with all balances
  mapping (address => uint256) public balanceOf;

  // create a public associative array of arrays that indicates
  // how much one address is allowed to send on behalf of another address
  mapping (address => mapping (address => uint256)) public allowance;

  // events
  event Transfer(address indexed from, address indexed to, uint256 value);

  /* Initialize token balance and allocate to contract sender.*/
  function MyToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
    balanceOf[msg.sender] = initialSupply;
    name = tokenName;
    symbol = tokenSymbol;
    totalSupply = initialSupply * 10 ** unit256(decimals);
  }

  /** 
  * Internal transfer. Can only be called by this contract.
  **/
 function _transfer(address from, address to, uint value) internal {
   // prevent transfer to 0x0 address. Use burn() instead.
   require(to != 0x0);
   
   // check if sender has balance and for overflows
   require(balanceOf[msg.sender] >= value);
   require(balanceOf[to] + value >= balanceOf[to]);

   // save balance before hand
   unit prevBalance = balanceOf[from] + balanceOf[to];
    
   // add and subtract new balances
   balanceOf[msg.sender] -= value;
   balanceOf[to] += value;
    
   // notify anyone listenting that transfer took place
   Transfer(msg.sender, to, value);

   // ensure conservation of balance
   assert(balanceOf[from] + balanceOf[to] == prevBalance);
 }

  /** 
   * Transfer value amount of tokens from the sender address to a 
   * specified address. Must fire the TRANSFER event.
   *
   * @param to address of the recipient
   * @param value amount to send 
  */
  function transfer(address to, uint256 value) public {
    _transfer(msg.sender, to, value);
  }

  /** 
   * Transfer value amount of tokens from a specified address to 
     another address. Must fire the TRANSFER event.
   *
   * @param from address of the sender
   * @param to address of the recipient
   * @param value the amount to send
  */
  function transferFrom(address from, address to, uint256 value) returns (bool success) public {
    // check allowance to ensure that sender is allowed to send value on behalf of from
    require(value <= allowance[from][msg.sender]);

    // update allowance
    allowance[from][msg.sender] -= value;

    // make the transfer
    _transfer(from, to, value);

    return true;
  }

}
