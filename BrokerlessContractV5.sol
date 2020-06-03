pragma solidity ^0.5.0;
// pragma experimental ABIEncoderV2; enable experimental features (required for returning structs)

//import "./Deposit.sol";
//import "./BrokerlessAuction.sol";

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

    /* contructor */
/*
    constructor(uint _rent, uint _deposit, string memory _apt, uint _servicefeepercent, uint _showingfeepercent ) public {
        rent = _rent;
        deposit = _deposit;
        apt = _apt;
        us = msg.sender;
        servicefeepercent = _servicefeepercent;
        showingfeepercent = _showingfeepercent;
    }
*/
  
    /* test constructor */
     constructor() public {
        rent = 1 ether;
        deposit = 1 ether;
        apt = "foo";
        us = msg.sender;
        servicefeepercent = 5;
        showingfeepercent = 25;
    }
    
    /* modifiers */
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

    /* getters */
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
    
    /* Confirm the lease agreement as landlord*/
    function landlordConfirm() public
    inState(State.Created) // landlord and tenant can not be changed when both are confirmed
    {
        require(msg.sender != tenant && msg.sender != us, "You are not the landlord.");
        emit landlordConfirmed();
        landlord = msg.sender;
        // sets state to started when BOTH landlord and tenant confirm (only if the other is not an empty address)
        if (tenant != 0x0000000000000000000000000000000000000000) {
            state = State.Started;
        }
    }
   
    /* Confirm the lease agreement as tenant*/
    function tenantConfirm() public
    inState(State.Created)
    {
        require(msg.sender != landlord && msg.sender != us, "You are not the tenant.");
        emit tenantConfirmed();
        tenant = msg.sender;
        if (landlord != 0x0000000000000000000000000000000000000000) {
            state = State.Started;
        }
    }

    function setPrevious(address payable _previous) public payable
//    onlyUs
    inState(State.Started)
    {
        previous = _previous;
    }
    
    function initialPayout() public payable // can functions be made automatically called when a state is activated?
//    onlyUs
    inState(State.Started)
    {
        require(previous != 0x0000000000000000000000000000000000000000, "Please set previous contract address.");
        firstpayment = address(this).balance;
        previous.transfer(firstpayment * showingfeepercent/100); // to previous contract to pay showingfee
        landlord.transfer(firstpayment - (firstpayment * showingfeepercent/100) - (firstpayment * servicefeepercent/100));
        us.transfer(firstpayment * servicefeepercent/100);
    }
    
    function payRent() public payable
    onlyTenant
    inState(State.Started)
    {
        require(msg.value == rent);
        emit paidRent();
        landlord.transfer(msg.value);
    }
    
    function setDepositContract(address payable _depositcontract) public payable
//    onlyUs
    {
        depositcontract = _depositcontract;
    }

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
    
    function requestShowingFee() public
    onlyTenant
    inState(State.Started) // how can we make it so that this refers to the next tenant's contract?
    {
        emit paidShowingFee();
//        tenant.transfer(); // transfer showing fee from next contract
    }

    function terminateContract() public
    onlyLandlord
    {
        // require event: paidDeposit to be true and paidrents to = rent *12
        emit contractTerminated();
        state = State.Terminated;
    }
    
    function getbalance() public view returns (uint) {
        return address(this).balance;
    }
    function () payable external {} // required so that this contract can be payable
}