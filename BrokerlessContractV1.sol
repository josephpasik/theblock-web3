pragma solidity ^0.5.0;
// pragma experimental ABIEncoderV2; enable experimental features (required for returning structs)

contract Lease {

    uint public rent;
    uint public deposit;
    uint public showingFee;
    /* Combination of zip code, building number, and apt number*/
    string public apt;

    address payable public landlord;
    address payable public tenant;
//    address payable public next;
    address payable public previous; // the CONTRACT address of the previous contract
    
    
    enum State {Created, Started, Terminated}
    State public state;

    constructor(uint _rent, uint _deposit, string memory _apt) public { // made into constructor
        rent = _rent;
        deposit = _deposit;
        apt = _apt;
        landlord = msg.sender;
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
    event agreementConfirmed();

    event paidRent();
    
    event paidDeposit();
    
    event returnedDeposit();
    
    event paidShowingFee();

    event contractTerminated();

    /* Confirm the lease agreement as tenant*/
    function confirmAgreement() public
    inState(State.Created)
    {
        require(msg.sender != landlord); // moved into function
        emit agreementConfirmed(); // added emit
        tenant = msg.sender;
        state = State.Started;
    }

    function setPrevious(address payable _previous) public payable
    onlyLandlord
    inState(State.Started)
    {
        previous = _previous;
    }
    
    function payFirstRent() public payable
    onlyTenant
    inState(State.Started)
    {
        require(msg.value == rent); // moved into function
        emit paidRent(); // added emit
        previous.transfer(msg.value / 2); // to previous contract to pay showingfee
        landlord.transfer(msg.value / 2);
    }
    
    function payRent() public payable
    onlyTenant
    inState(State.Started)
    {
        require(msg.value == rent); // moved into function
        emit paidRent(); // added emit
        landlord.transfer(msg.value); // changed send to transfer
    }
    
    function payDeposit() public payable
    onlyTenant
    inState(State.Started)
    /// need to make it so that it can only be paid once
    {
        require(msg.value == deposit);
        emit paidDeposit();
    }
    
    function returnDeposit(uint amount) public
    onlyLandlord
    inState(State.Started)
    {
        require(amount == deposit, "Please return the full security deposit");
        emit returnedDeposit();
        tenant.transfer(amount);
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