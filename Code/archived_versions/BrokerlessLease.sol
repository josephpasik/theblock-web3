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
    // uint public interet breakdown
    uint public interestRatebps;
    uint public enhancedRatebps;
    uint public tenantInterestPayment;
    uint public landlordInterestPayment;
    uint public usInterestPayment;
    
    /* Combination of zip code, building number, and apt number*/
    string public apt;

    

    address payable public landlord;
    address payable public tenant;
    address payable public us;
    address payable public consolidatedDeposits;
//    address payable public next;
    address payable public previous; // the CONTRACT address of the previous contract
    address payable public omnibusAddress;
    
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
        deposit = 1 ether; //should be taken from auction contract
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
        rent = address(this).balance; // should be getting rent from auction contract
        previous.transfer(rent * showingfeepercent/100); // to previous contract to pay showingfee
        landlord.transfer(rent - (rent * showingfeepercent/100) - (rent * servicefeepercent/100));
        us.transfer(rent * servicefeepercent/100);
    }
    
    function payRent() public payable
    onlyTenant
    inState(State.Started)
    {
        require(msg.value == rent, "Please pay the proper rent.");
        emit paidRent();
        landlord.transfer(msg.value);
    }
    
    function setOmnibusContract(address payable _omnibus) public payable
//    onlyUs
    {
        omnibusAddress = _omnibus;
    }

/*
    function payDeposit() public payable
    onlyTenant
//    inState(State.Started)
    /// need to make it so that it can only be paid once
    {
        require(msg.value == deposit);
        emit paidDeposit();
        omnibusAddress.transfer(msg.value);
    }
*/

    function returnDeposit() external 
    onlyLandlord
    {
        Omnibus omnibus = Omnibus(omnibusAddress);
        omnibus.releaseDeposit(tenant, deposit);
        omnibus.releaseInterestTenant(tenant);
        
    }

    function requestInterestLandlord() external 
    onlyLandlord
    {
        Omnibus omnibus = Omnibus(omnibusAddress);
        omnibus.releaseInterestLandlord(landlord);
    
    }

/*    
    function returnDeposit() public payable
    onlyUs
    inState(State.Started)
    {
        require(msg.value == deposit);
        emit returnedDeposit();
        tenant.transfer(msg.value);
    }
*/
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


contract Omnibus {
    
    address payable tenant;
    address payable landlord;
    address payable us;
    uint deposit;
    uint interestRatebps;
    uint enhancedSpreadbps;
    uint tenantInterestSplit;
    uint landlordInterestSplit;
    uint usInterestSplit;
    uint tenantInterestPayment;
    uint landlordInterestPayment;
    uint usInterestPayment;
// Test Constructor    
    constructor() 
    public {
        interestRatebps = 500;
        enhancedSpreadbps = 500;
        tenantInterestSplit = 60;
        landlordInterestSplit = 20;
        usInterestSplit = 20;
        us = msg.sender;
    }
// Constructor Original    
/*    constructor(uint _interestRatebps,uint _enhancedRatebps, uint _tenantInterestSplit, 
                uint _landlordInterestSplit, uint _usInterestSplit) 
    public {
        interestRatebps = _interestRatebps/1000;
        enhancedSpreadbps = _enhancedRatebps/1000;
        tenantInterestSplit = _tenantInterestSplit/100;
        landlordInterestSplit = _landlordInterestSplit/100;
        usInterestSplit = _usInterestSplit/100;
        us = msg.sender;
    }
 */   
 //   function interestCalculator(address payable _tenant, address payable _landlord, address payable _us) public {
   //     
//    }
    
    function releaseDeposit(address payable _tenant, uint _deposit) public
    {
        tenant = _tenant;
        deposit = _deposit;
        tenant.transfer(deposit);
    }
    
    function releaseInterestTenant(address payable _tenant) public
    {
        tenant = _tenant;
        
        tenantInterestPayment =  (interestRatebps/1000 * deposit) + (tenantInterestSplit/100 *(enhancedSpreadbps/1000 * deposit));
        usInterestPayment = (usInterestSplit/100 * (enhancedSpreadbps/1000 * deposit));
        tenant.transfer(tenantInterestPayment);
        us.transfer(usInterestPayment);
    }
    

    function releaseInterestLandlord(address payable _landlord) public
    {
        
        landlord = _landlord;
        
        landlordInterestPayment = (landlordInterestSplit/100 * (enhancedSpreadbps/1000 * deposit));
        landlord.transfer(landlordInterestPayment);
        }
    
    
    function getbalance() public view returns (uint) {
        return address(this).balance;
    }
    
    function () payable external {}
}