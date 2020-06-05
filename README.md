# **GO BROKERLESS!**
# _Free of Concern_
## _"Libre de preocupación"_ 

---
# Overview
In this project, we are helping you break free from broker hassles. Our distributed ledger is built upon ethereum programming in Solidity. Let's walk through this exciting process together!

## Engaging Parties

|       Party        |    Address     |               Interpretation                 |
|--------------------|----------------|----------------------------------------------|
|          Landlord  |   `landlord`   |   crypto wallet of the landloard             |
|          Tenant    |   `tenant`     |  wallet address of the candidate tenant      |
|  Previous Tenant   |   `previous`   | wallet address of the previous tenant leaving|
|            Us      |      `us`      | our crypto wallet address                    |

## Escrow Accounts
|          Party        |       Address                |                           Interpretation                            |
|-----------------------|------------------------------|---------------------------------------------------------------------|
|     Omnibus Tokens    |   `omnibusAddress`           |  wallet address of new crowdfunding tokens  (NFT)                   |
|      Deposit Pool     |   `consolidatedDeposits`     |  escrow address of deposit from all parties for higher returns      |

## Variables

|       Variable          |        Code         |                           Explanation                               |
|-------------------------|---------------------|---------------------------------------------------------------------|
|          Rent           |        `rent`       |  monthly rent for bidding                                           |
|      Deposit            |       `deposit`     |  deposit from the higher bidder, equivalent to one-month rent       |
|      showingfeepercent  | `showingfeepercent` |  percent of rent for showing the property to candidate tenants      |
|      servicefeepercent  | `servicefeepercent` |  as a percent of monthly rent                                       |



## Entity Relationship Diagram
![erd](Resources/Images/erd.png)

---
# Libraries in Solidity
## [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts)


---
# Workflow
## _Theory standing on shoulders of giants_
![leasehold_token](Resources/Images/leasehold_token.png)
_Source: [Leasehold Token - The Decentralized Money Making Through Sort Term Rental Tokenization](https://steemit.com/blockchain/@kurniawan05/leasehold-token-the-decentralized-money-making-through-sort-term-rental-tokenization)_

## Step-by-step Guide

```
Step 1:
* As Landlord deploys Auction contract 
* As Us deploy Lease contract
* As Us deploy the Omnibus contract

** Insert bank interest 5%

* Set leaseAddress contract
* Set omnibusAddress contract
* As potentialTenant 1 enter bid Value and split Value between 
  rent percent and deposit percent
* As potentialTenant 2 enter higher bid Value and split Value
  between rent percent and deposit percent
* As potentialTenant 1 withdraw bid to get back money
* As Landlord end auction and accept highest bid. Resulting in the rent being transferred
  to lease contract and deposit gets transferred to the Omnibus contract

** Navigate to the Lease contract. As Landlord confirm lease contract
** As Tenant confirm lease contract

* Set Omnibus contract
* Set Previous contract
* Click initialPayout
* Rent payment is transferred to Landlord and Previous Tenant for showing
 the house and Us for offering the platform
** In the Previous Tenant Agreement set 
* Click PayRent 
* After duration press requestDeposit

```

## Contracts

## Events

## State (snapshots in process)

## Modifiers



---
# Results



---
# Next Steps


---
# Files




---
# References

* https://medium.com/@naqvi.jafar91/converting-a-property-rental-paper-contract-into-a-smart-contract-daa054fdf8a7
* https://github.com/anudishjain/CharterContracts/blob/master/Smart%20Contracts/MainContract.sol @author-Anudish Jain
* https://steemit.com/blockchain/@kurniawan05/leasehold-token-the-decentralized-money-making-through-sort-term-rental-tokenization



