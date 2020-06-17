pragma solidity ^0.5.0;

contract Auction {
    
    address payable public us;
    address payable public landlord;
    address payable public leaseAddress;
    address payable public omnibusAddress;
    address payable public previous;
    
    /* Combination of zip code, building number, and apt number*/
    string public apt;

    // Current state of the auction.
    address payable public tenant;
    uint public highestBid;
    uint public rentPercent;
    uint public depositPercent;
    uint public rent;
    uint public deposit;
    uint public servicefeepercent;
    uint public showingfeepercent;
    
//    uint public showingFeePercent
//    string public apt;

    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns;

    // Events that will be emitted on changes.
    event rentIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // The following is a so-called natspec comment,
    // recognizable by the three slashes.
    // It will be shown when the user is asked to
    // confirm a transaction.

    enum State {Started, Terminated}
    State public state;

    /*constructor*/
/*
    constructor(string memory _apt, uint _showingFeePercent) public {
        landlord = msg.sender;
        state = State.Started;
        apt = _apt;
        showingFeePercent = _showingFeePercent;
    }
*/
    /* test constructor*/
    constructor(address payable _landlord, string memory _apt, address payable _previous, address payable _leaseAddress, address payable _omnibusAddress) public {
        omnibusAddress = _omnibusAddress;
        leaseAddress = _leaseAddress;
        landlord = _landlord;
        apt = _apt;
        previous = _previous;
        us = msg.sender;
        servicefeepercent = 5;
        showingfeepercent = 25;
    }
    
    /* modifiers */
    modifier inState(State _state) {
        require(state == _state, "The auction is not active.");
        _;
    }    
    modifier onlyLandlord() {
        require(landlord == msg.sender, "You must be the landlord to perform this function.");
        _;
    }
    
    /// identifies the BrokerlessContract address (instead can we have this corntact CREATE the BrokerlessContract?)
/*
    function writeContract(address payable _leaseAddress, address payable _omnibusAddress) public payable {
        omnibusAddress = _omnibusAddress;
        leaseAddress = _leaseAddress;
        Lease lease = Lease(leaseAddress);
        lease.construct(landlord, tenant, rent, deposit, apt);
    }
*/
    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won.
    
    function bid(uint _rentPercent, uint _depositPercent) public payable
    inState(State.Started)
    {
        // If the bid is not higher, send the money back.
        require(landlord != msg.sender);
        require(msg.value > highestBid, "There already is a higher bid.");
        require(_depositPercent <= _rentPercent);

        if (highestBid != 0) {
            // Sending back the money by simply using
            // tenant.send(rent) is a security risk
            // because it could execute an untrusted contract.
            // It is always safer to let the recipients
            // withdraw their money themselves.
            pendingReturns[tenant] += highestBid;
        }
        //tenant = msg.sender;
        tenant = msg.sender;
        highestBid = msg.value;
        rentPercent = _rentPercent;
        depositPercent = _depositPercent;
        emit rentIncreased(msg.sender, msg.value);
    }

    /// Withdraw a bid that was overbid.
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            pendingReturns[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                // No need to call throw here, just reset the amount owing
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function pendingReturn() public view returns (uint) {
        return pendingReturns[msg.sender];
    }
    
    function getbalance() public view returns (uint) {
        return address(this).balance;
    }

    /// End the auction and send the highest bid to the BrokerlessContract.
    
    function auctionEnd() public
    inState(State.Started)
    onlyLandlord
    {
        // It is a good guideline to structure functions that interact
        // with other contracts (i.e. they call functions or send Ether)
        // into three phases:
        // 1. checking conditions
        // 2. performing actions (potentially changing conditions)
        // 3. interacting with other contracts
        // If these phases are mixed up, the other contract could call
        // back into the current contract and modify the state or cause
        // effects (ether payout) to be performed multiple times.
        // If functions called internally include interaction with external
        // contracts, they also have to be considered interaction with
        // external contracts.

        // 1. Conditions as modifiers

        // 2. Effects
        state = State.Terminated;
        emit AuctionEnded(tenant, highestBid);

        // 3. Interaction
        rent = highestBid * rentPercent/100;
        deposit = highestBid * depositPercent/100;
//        leaseAddress.transfer(rent);
        omnibusAddress.transfer(deposit);
        previous.transfer(rent * showingfeepercent/100); // to previous contract to pay showingfee
        landlord.transfer(rent - (rent * showingfeepercent/100) - (rent * servicefeepercent/100));
        us.transfer(rent * servicefeepercent/100);
        
        Lease lease = Lease(leaseAddress);
        lease.construct(landlord, tenant, omnibusAddress, rent, deposit, apt);
    }
}



contract Lease {

    address payable public landlord;
    address payable public tenant;
    address payable public us;
    address payable public consolidatedDeposits;
    address payable public previous; // the CONTRACT address of the previous tenant's contract
    address payable public omnibusAddress;
    
    uint public rent;
    uint public deposit;
    uint public showingfeepercent;
    uint servicefeepercent;
//    uint public interestRatebps;
//    uint public enhancedRatebps;
//    uint public tenantInterestPayment;
//    uint public landlordInterestPayment;
//    uint public usInterestPayment;
    
    /* Combination of zip code, building number, and apt number*/
    string public apt;


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
        us = msg.sender;
//        servicefeepercent = 5;
//        showingfeepercent = 25;
        
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
/*
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
/*   
    /* Confirm the lease agreement as tenant*/
/*
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
*/    
    function construct(address payable _landlord, address payable _tenant, address payable _omnibusAddress, uint _rent, uint _deposit, string calldata _apt) external {
        omnibusAddress = _omnibusAddress;
        landlord = _landlord;
        tenant = _tenant;
        rent = _rent;
        deposit = _deposit;
        apt = _apt;
    }
    
/*
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
*/    
    function payRent() public payable
    onlyTenant
    inState(State.Started)
    {
        require(msg.value == rent, "Please pay the proper rent.");
        emit paidRent();
        landlord.transfer(msg.value);
    }
/*    
    function setOmnibusContract(address payable _omnibus) public payable
//    onlyUs
    {
        omnibusAddress = _omnibus;
    }
*/
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
        omnibus.releaseDeposit(tenant, landlord, deposit);
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
    uint public deposit;
    uint public interestRate;
    uint public enhancedSpread;
    uint public tenantInterestSplit;
    uint public landlordInterestSplit;
    uint public usInterestSplit;
    uint public tenantInterestPayment;
    uint public landlordInterestPayment;
    uint public usInterestPayment;

    /*Constructor*/
/*
    constructor(uint _interestRatebps,uint _enhancedRatebps, uint _tenantInterestSplit, 
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
    /*Test Constructor*/    
    constructor() 
    public {
        interestRate = 1;
        enhancedSpread = 3;
        tenantInterestSplit = 60;
        landlordInterestSplit = 20;
        usInterestSplit = 20;
        us = msg.sender;
    }
    
    function releaseDeposit(address payable _tenant, address payable _landlord, uint _deposit) external
    {
        tenant = _tenant;
        landlord = _landlord;
        deposit = _deposit;
        
        tenantInterestPayment =  (deposit * interestRate/100) + (deposit * enhancedSpread/100 * tenantInterestSplit/100);
        landlordInterestPayment = (deposit * enhancedSpread/100 * landlordInterestSplit/100);
        usInterestPayment = (deposit * enhancedSpread/100 * usInterestSplit/100);
        tenant.transfer(deposit);
        tenant.transfer(tenantInterestPayment);
        landlord.transfer(landlordInterestPayment);
        us.transfer(usInterestPayment);
    }
    
    function getbalance() public view returns (uint) {
        return address(this).balance;
    }
    
    function () payable external {}
}