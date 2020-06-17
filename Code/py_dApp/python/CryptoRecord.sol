pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

/**

    ERC721 Record URI JSON Schema

    {
        "title": "Apartment Metadata",
        "type": "object",
        "properties": {
            "Build": {
                "type": "string",
                "description": "2BR"
            },
            "layout": {
                "type": "string",
                "description": "Condo"
            },
            "year": {
                "type": "uint",
                "description": "1970"
            }
        }
    }

**/
// token_id represent "Apartment ID" as an assigned integer.

contract CryptoRecord is ERC721Full {

    constructor() ERC721Full("CryptoRecord", "APARTMENTS") public { }

    using Counters for Counters.Counter;
    Counters.Counter token_ids;

    struct Apt {
        string apt;
        uint incidents;
    }

    // Stores token_id => Car
    // Only permanent data that you would need to use within the smart contract later should be stored on-chain
    mapping(uint => Apt) public apts;

    event Incident(uint token_id, string report_uri);

    function registerApartment(address landlord, string memory apt, string memory token_uri) public returns(uint) {
        token_ids.increment();
        uint token_id = token_ids.current();

        _mint(landlord, token_id);
        _setTokenURI(token_id, token_uri);

        apts[token_id] = Apt(apt, 0);

        return token_id;
    }

    function reportIncident(uint token_id, string memory report_uri) public returns(uint) {
        apts[token_id].incidents += 1;

        // Permanently associates the report_uri with the token_id on-chain via Events for a lower gas-cost than storing directly in the contract's storage.
        emit Incident(token_id, report_uri);

        return apts[token_id].incidents;
    }
}
