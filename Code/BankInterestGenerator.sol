
pragma solidity ^0.5.0;

contract BankInterest{
    
    address payable Omnibus;
    
    constructor(address payable _omnibusAddress) public{
   
    Omnibus = _omnibusAddress;
    }
    
    function generateFunds() public payable {
        
        Omnibus.transfer(msg.value);
    }
      
}
