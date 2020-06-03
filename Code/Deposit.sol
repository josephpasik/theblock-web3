
pragma solidity ^0.5.0;

//import "./BrokerlessContract.sol";


 //will take from the pool and allocate to a deposit that is consolidated and yields a higher retunr from banks
contract interestAdvantage {
    address payable landlord; //landlords collection account
    address payable tenant;
    address payable us; 
    
    uint baseInterest;
    uint enhancedSpread;
    uint tenantSplit; //share of spread going to tenant
    uint landlordSplit; //share of spread going to landlord
    uint usFee; //share of spread for our fees
    uint amount; //pooled security deposits
    
constructor (uint baseInterest, uint enhancedSpread, uint usFee, uint landlordSplit, uint tenantSplit) public {
    
    baseInterest = _baseInterest;
    enhancedSpread = _enhancedSpread;
    usFee = _usFee;
    landlordSplit = _landlordSplit;
    tenantSplit = _tenantSplit;
    
    
}

//modifier onlyUs() {
//        require(us == msg.sender, "You must be the service provider to perform this function.");
//        _;
//    }

//mapping(address=uint) tenantAccount;  //maps specific deposit to specific tenant 

function getBalnce() public view returns(uint) {
        
    } // gives the total deposit balance in the contract

function payParties() public {
     uint distributionPool = amount * (enhancedSpread - baseInterest); // Your code here!

        // @TODO: Transfer the amount to each employee
        tenant.transfer(amount * tenantSplit);
        landlord.transfer(amount * landlordSplit);
        us.transfer(amount * usFee);
}

function returnSecurity() public {
  //  require(onlyUs and onlyLandlord)
    uint tenantSecurity = amount * baseInterest;
    
    tenant.transfer(tenantSecurity);
}

 

}




/*This agreement governs the management of the security deposits made by the tenants for the rental of their property. The security
deposits will be pooled together to form a security deposit fund. Management of the fund will be outsourced to a professional manager
with no management fee but a success fee with a guarantee on the principal amount (FDIC insured). 

Tenant deposits security into contract
Parties to the agreemen: Us, Owner, Tenant and Advisor

Need to have:
1. Date for open and close of the contract that is tied to the brokerlesscontract
2. Security amount that is consolidated from other contracts that are created. Maybe a function that takes an input in the form
of the contract numbers and adds them together
3. Need a split for the benefit of the additional interest that is returned
4. Need a function to return the deposit or offer an opportunity to renew the agreement
5. Do we need a function that takes into consideration the base amount plus interest separately so we can distribut the earnings
between the Parties
6. Us and Owner should be capped at the amount of fees with upside going to Tenant mainly and some to the investment manager with
a higher cap then Us and Owner
7. Participants to select their investment strategy
8. How much will you allocate to the pool from the deposit
9. Contract with security deposit should have the option built in it to dedicate to investment (maybe owner will have a max 
investment amount)
*/