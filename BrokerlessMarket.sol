pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/ownership/Ownable.sol";
import './BrokerlessAuction.sol';

contract BrokerlessMarket is ERC721Full, Ownable {
    constructor() ERC721Full("BrokerlessMarket", "MARS") public {}

    // cast a payable address for the DoorKeeBrokerless Development Foundation to be the beneficiary in the auction
    // this contract is designed to have the owner of this contract (foundation) to pay for most of the function calls
    // (all but bid and withdraw)
    address payable foundationAddress = address(uint160(owner()));

    mapping(uint => BrokerlessAuction) public auctions;

    function registerLand(string memory tokenURI) public payable onlyOwner {
        uint _id = totalSupply();
        _mint(msg.sender, _id);
        _setTokenURI(_id, tokenURI);
        createAuction(_id);
    }

    function createAuction(uint tokenId) public onlyOwner {
       // initiate new auctions
        auctions[tokenId] = new BrokerlessAuction(foundationAddress);
        }

    function endAuction(uint tokenId) public onlyOwner {
        require(_exists(tokenId), "Land not registered!");
        BrokerlessAuction auction = getAuction(tokenId);
        // End auction and transfer land from the owner to verified highest bidder safely
        auction.auctionEnd();
        safeTransferFrom(owner(), auction.highestBidder(), tokenId);
    }

    function getAuction(uint tokenId) public view returns(BrokerlessAuction auction) {
        // Pull information from createAuction(uint tokenID)
        return auctions[tokenId];
     }

    function auctionEnded(uint tokenId) public view returns(bool) {
      // Require existing tokenID to prevent lossing ether 
        require(_exists(tokenId), "Unregistered yet. Please double check your token ID. Thanks!");    
        BrokerlessAuction auction = getAuction(tokenId);
        return auction.ended();
     }

    function highestBid(uint tokenId) public view returns(uint) {
       // Require existing tokenID to prevent lossing ether 
        require(_exists(tokenId), "Unregistered Please double check your token ID.");    
        BrokerlessAuction auction = getAuction(tokenId);
        return auction.highestBid();
    }

    function pendingReturn(uint tokenId, address sender) public view returns(uint) {
      // Require existing tokenID to prevent lossing ether 
        require(_exists(tokenId), "Unregistered. Please double check your token ID.");    
        BrokerlessAuction auction = getAuction(tokenId);
        return auction.pendingReturn(sender);
     }

    function bid(uint tokenId) public payable {
       // Require existing tokenID to prevent lossing ether 
        require(_exists(tokenId), "Unregistered. Please double check your token ID.");    
        BrokerlessAuction auction = getAuction(tokenId);
        auction.bid.value(msg.value)(msg.sender);
     }

}
