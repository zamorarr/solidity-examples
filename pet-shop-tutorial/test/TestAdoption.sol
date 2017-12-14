pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Adoption.sol";

contract TestAdoption {
  Adoption adoption = Adoption(DeployedAddresses.Adoption());

  // Testing the adopt() function
  function testUserCanAdoptPet() public {
    uint returnedId = adoption.adopt(8);
    uint expected = 8;
    Assert.equal(returnedId, expected, "Adoption of pet ID 8 should be recorded");
  }

  // Testing the adopters
  function testGetAdopterAddressByPetId() public {
    // actual owner
    address adopter = adoption.adopters(8);

    // expected owner is this contract
    address expected = this;

    Assert.equal(adopter, expected, "Owner of pet ID 8 should be recorded.");
  }

  // Testing retrieval of all pet owners
  function testGetAdopterAddressByPetIdInArray() public {
    // actual owners. store in memory rather than contract storage
    address[16] memory adopters = adoption.getAdopters();

    // expected owner is this contract
    address expected = this;

    Assert.equal(adopters[8], expected, "Owner of pet ID 8 should be recorded");
  }
}
