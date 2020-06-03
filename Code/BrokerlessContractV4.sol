pragma solidity ^0.5.0;
// pragma experimental ABIEncoderV2; enable experimental features (required for returning structs)

import "./Deposit.sol";
import "./BrokerlessAuctionV2.sol";

contract Lease {

    uint public rent;
    uint public deposit;
    // uint public showingfee;
    uint public showingfeepercent;
    uint servicefeepercent;
    
    uint public firstpayment;
    
    /* Combination of zip code, building number, and apt number*/
    string public apt;

    address payable public landlord;
    address payable public tenant;
    address payable public us;
    address payable public consolidatedDeposits;
//    address payable public next;
    address payable public previous; // the CONTRACT address of the previous contract
    address payable public depositcontract;
    
//    BrokerlessAuction auction;
    
    
    enum State {Created, Started, Terminated}
    State public state;

    constructor(uint _rent, uint _deposit, string memory _apt, uint _servicefeepercent, uint _showingfeepercent ) public { // made into constructor
        rent = _rent;
        deposit = _deposit;
        apt = _apt;
        us = msg.sender;
        servicefeepercent = _servicefeepercent;
        showingfeepercent = _showingfeepercent;
    }
//    modifier require(bool _condition) {
//        if (!_condition) throw;
//        _;
//    }
    modifier onlyLandlord() {
        require(landlord == msg.sender, "You must be the landlord to perform this function.");
        _;
    }
    modifier onlyTenant() {
        require(tenant == msg.sender, "You must be the tenant to perform this function.");
        _;
    }
    
    modifier onlyUs() {
        require(us == msg.sender, "You must be the service provider to perform this function.");
        _;
    }
    
    modifier inState(State _state) {
        require(state == _state, "This contract is not active.");
        _;
    }

    /* We also have some getters so that we can read the values
    from the blockchain at any time */
    // added public to each function
      
/*    
    function getPaidRents() public returns (PaidRent[] memory) { // had to turn on experimental features to return struct
        return paidrents;
    }

    function getApt() public view returns (string memory) {
        return apt;
    }

    function getLandlord() public view returns (address) {
        return landlord;
    }

    function getTenant() public view returns (address) {
        return tenant;
    }

    function getRent() public view returns (uint) {
        return rent;
    }

    function getContractCreated() public view returns (uint) {
        return createdTimestamp;
    }

    function getContractAddress() public view returns (address) {
        return address(this);
    }

    function getState() public returns (State) {
        return state;
    }
*/

    /* Events for DApps to listen to */
    event landlordConfirmed();
    
    event tenantConfirmed();

    event paidRent();
    
    event paidDeposit();
    
    event returnedDeposit();
    
    event paidShowingFee();

    event contractTerminated();
    
    /* Confirm the lease agreement as tenant*/
    function confirmAgreementlandlord() public
    inState(State.Created)
    {
        require(msg.sender != tenant || msg.sender != us); // moved into function
        emit landlordConfirmed(); // added emit
        landlord = msg.sender;
        // make sure not already set
        // if tenant is not null set to state started
        state = State.Started;
    }
   
   
    function confirmAgreementtenant() public
    inState(State.Created)
    {
        require(msg.sender != landlord || msg.sender != us); // moved into function
        emit tenantConfirmed(); // added emit
        tenant = msg.sender;
        state = State.Started;
    }

// State started should be when both parties agree to the confirm

    function setPrevious(address payable _previous) public payable
    onlyLandlord
    inState(State.Started)
    {
        previous = _previous;
    }
    
    function setDepositContract(address payable _depositcontract) public payable
    onlyUs
    {
        depositcontract = _depositcontract;
    }
    
    function payFirstRent() public payable
//    onlyUs
    inState(State.Started)
    {
        require(msg.value == rent); // moved into function
        emit paidRent(); // added emit
        firstpayment = address(this).balance;
        previous.transfer(firstpayment * showingfeepercent/100); // to previous contract to pay showingfee
        landlord.transfer(firstpayment - (firstpayment * showingfeepercent/100) - (firstpayment * servicefeepercent/100));
        us.transfer(firstpayment * servicefeepercent/100);
    }


    function returnDeposit(uint amount) public
    onlyLandlord
    inState(State.Started)
    {
        require(amount == deposit, "Please return the full security deposit");
        emit returnedDeposit();
        tenant.transfer(amount);
    }

    
    function payRent() public payable
    onlyTenant
    inState(State.Started)
    {
        require(msg.value == rent); // moved into function
        emit paidRent(); // added emit
        landlord.transfer(msg.value); // changed send to transfer
        //uint total;
    }
/*    
    function payDeposit() public payable
    onlyTenant
    inState(State.Started)
    /// need to make it so that it can only be paid once
    {
        require(msg.value == deposit);
        emit paidDeposit();
        consolidatedDeposits = 0xAd7ec4E051d8A2cCc99A463B7c88D9eb791682D2;
        consolidatedDeposits.transfer(msg.value);
    }
    
    function returnDeposit(uint amount) public
    onlyLandlord
    inState(State.Started)
    {
        require(amount == deposit, "Please return the full security deposit");
        emit returnedDeposit();
        tenant.transfer(amount);
    }
*/    
    function payDeposit() public payable
    onlyTenant
//    inState(State.Started)
    /// need to make it so that it can only be paid once
    {
        require(msg.value == deposit);
        emit paidDeposit();
        depositcontract.transfer(msg.value);
    }
    
    function requestDeposit() public payable
    onlyTenant
    inState(State.Started)
    {
        require(msg.value == deposit);
        emit returnedDeposit();
        tenant.transfer(msg.value);
    }
    
    function returnDeposit() public payable
    onlyUs
    inState(State.Started)
    {
        require(msg.value == deposit);
        emit returnedDeposit();
        tenant.transfer(msg.value);
    }
  
///        require(unlock_time < now, "Account is locked"); 
///
///        if (amount > address(this).balance / 3) {
///            unlock_time = now + 24 hours;
///        }
    
/*    
    function payShowingFee() public payable
    onlyLandlord
    inState(State.Started)
    {
        require(msg.value == showingFee);
        emit paidShowingFee();
        tenant.transfer(msg.value);
    }
*/    
    // OR
    
    function requestShowingFee() public
    onlyTenant
    inState(State.Started) //make so that this refers to the next tenant's contract
    {
        emit paidShowingFee();
        tenant.transfer(rent / 2);
    }
    
    /* Terminate the contract so the tenant can’t pay rent anymore,
    and the contract is terminated */
    function terminateContract() public
    onlyLandlord
    {
        // require event: paidDeposit to be true and paidrents to = rent *12
        emit contractTerminated();
        landlord.transfer(address(this).balance); //changed to address.this -- changed to transfer
        /* If there is any value on the
               contract send it to the landlord*/
        state = State.Terminated;
    }
    
    function getbalance() public view returns (uint) {
        return address(this).balance;
    }
    function () payable external {} // required so that the next contract can pay this contract
}