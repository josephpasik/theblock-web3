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

## Standing on shoulders of giants
<details><summary>
LEASEHOLD: token distribution of smart contracts on rental lease
</summary>

![leasehold_token](Resources/Images/leasehold_token.png)
_Source: [Leasehold Token - The Decentralized Money Making Through Sort Term Rental Tokenization](https://steemit.com/blockchain/@kurniawan05/leasehold-token-the-decentralized-money-making-through-sort-term-rental-tokenization)_

</details>

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

## Frontend

### Set up a Webpage on Github

<details><summary>
Step 1: Click on `Settings` on the Github repository
</summary>

![webpage_settings](Resources/Images/webpage_settings.png)

</details>

<details><summary>
Step 2: On Github Pages, select `master branch ` as `Source` and select a theme under `Theme Chooser`
</summary>

![webpage_githubpages](Resources/Images/webpage_githubpages.png)

</details>

<details><summary>
Step 3: Open the link to the webpage published highlighted in green to view this page
</summary>

![webpage_link](Resources/Images/webpage_link.png)

</details>

<details><summary>
Step 4: Click on the link `here` under Demo App from the previous step to bid on BrokerlessMarket 
</summary>

![webpage](Resources/Images/webpage.png)

</details>



---
# Next Steps

Duration of contract
Auction contract should create brokerless contract. Or contract factory for may empty lease contracts to exist in waiting. 
Vetting with machine learning
Invest deposit with machine learning
Add damage report for landlord, require picture submission, allow withdrawal of deposit funds
Rather than auction process, bidders should offer rent and deposit fee. Landlord should be able to choose which to accept. Landlord to set minimum.
Add “paper” contract as URI
Allow tenants to offer a higher security deposit that the landlord is allowed to invest (전세) -> more security for the landlord (better tenants)
Link with property listing platform
Late fee (require payRent function even month)
Events in place for javascript Dapps to listen to. For user friendly UI

---
# Files

### _**[Presentation](https://docs.google.com/presentation/d/1XqKJcWhoMMr_Lb58diU3U4TdTR0wG6HT/edit#slide=id.p6)**_

---

## **Solidity**

### **[Brokerless Contract](Code/Brokerless.sol)**
### **[Bank Contract](Code/BankInterestGenerator.sol)**

---
## Frontend dApps
**[BrokerlessMarket Frontend Webpage](Code/frontend_test)**

**[dApps for Property Records](Code/py_dApp)**

---
## _Supplementary_

_[Google Drive and Slack Resources](Resources/GoogleSlack)_

_[Images](Resources/Images)_






---
# References

* https://medium.com/@naqvi.jafar91/converting-a-property-rental-paper-contract-into-a-smart-contract-daa054fdf8a7
* https://github.com/anudishjain/CharterContracts/blob/master/Smart%20Contracts/MainContract.sol @author-Anudish Jain
* https://steemit.com/blockchain/@kurniawan05/leasehold-token-the-decentralized-money-making-through-sort-term-rental-tokenization



