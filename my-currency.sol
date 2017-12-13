pragma solidity ^0.4.18;

// token should follow ERC-20 Token Standard to be recognized as currency
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
contract MyToken {
  // public variables of the token
  string public name;
  string public symbol;
  uint8 public decimals = 2;
  //uint256 public totalSupply;

  // create a public associative array with all balances
  mapping (address => uint256) public balanceOf;

  // events
  event Transfer(address indexed from, address indexed to, uint256 value);

  //constructor
  function MyToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
    balanceOf[msg.sender] = initialSupply;
    name = tokenName;
    symbol = tokenSymbol;
  }

  /* send coins */
  function transfer(address to, uint256 value) public {
    /* check if sender has balance and for overflows */
    require(balanceOf[msg.sender] >= value);
    require(balanceOf[to] + value >= balanceOf[to]);

    /* add and subtract new balances */
    balanceOf[msg.sender] -= value;
    balanceOf[to] += value;

    // notify anyone listenting that transfer took place
    Transfer(msg.sender, to, value);
  }
}
