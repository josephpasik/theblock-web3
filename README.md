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

### _Accounts_

* Tune in [MetaMask](https://metamask.io/) to Localhost 8545.
* Balances of accounts are viewable in
[Ganache](https://www.trufflesuite.com/ganache).

![Ganache Balances Prior to Transactions](Resources/Images/us_deploy_lease_ganache_0.png)

_Five accounts with the following wallet addresses engage in transactions on BrokerlessMarket (first five in Ganache):_
```
Us: 
0x0616d31438078849D3bf66591855B3D3239a9E5c

Landlord: 
0x5DBaBe19DD1fedba1B20047059DCd755D8221BF7

Tenant: 
0x3e9D41Ec700b98C773f2599052a3590931bEa98c

Previous: 
0x8EaaBB9Fc753df2C50F0b01E99b4e0F1f2d970A6

Bank: 
0xBb2e65E2d7664E51A1547767d502169591642491
```

---
### _Demo Transactions_

### _**Initiate Lease Contract**_

In Remix, open
[Brokerless Contract](Code/Brokerless.sol)

* As **Us** in MetaMask: 
  * Scroll and choose **Lease** under CONTRACT
  * Complile Lease Contract
  * Select _**Injected Web3**_ as ENVIRONMENT and deploy Lease Contract

    <details><summary>
    Lease Contract Deployment
    </summary>

    ![us_deploy_lease_0](Resources/Images/us_deploy_lease_0.png)

    </details>

  * After clicking the **Deploy** button, confirm on MetaMask for New Contract initiation
    * (Optional) Copy the address of the deployed Lease Contract by clicking on the page button to the right onto a .txt file: 0x0717c8C6c171E16dFE06d4df366d6fff017be521

    <details><summary>
    Notification of New Contract on MetaMask 
    </summary>

    ![us_deploy_lease_1](Resources/Images/us_deploy_lease_1.png)

    </details>

    <details><summary>
    Confirmation of Deployment on MetaMask 
    </summary>

    ![us_deploy_lease_2](Resources/Images/us_deploy_lease_2.png)

    </details>

  * Check our balance on Ganache

    <details><summary>
    Ganache Balance for Us dropped 0.02 ETH from 134.40 ETH to 134.38 ETH following Deployment of Lease Contract
    </summary>

    ![Ganache Balances following Lease Contract Deployment](Resources/Images/us_deploy_lease_ganache_1.png)

    </details>
---
### _**Initiate Omnibus Contract**_

* As **Us** in MetaMask:

  * Scroll down under CONTRACT and choose **Omnibus**
  * Compile the Omnibus Contract
  * Deploy Omnibus Contract under the same _**Injected Web3**_ ENVIRONMENT
    * (Optional) Copy the address of the deployed Omnibus Contract by clicking on the page button to the right onto a .txt file: 0x721080d169713ec439db4CaE8ED2daCEF4745B5d

    <details><summary>
    Omnibus Contract Deployment
    </summary>

    ![us_deploy_omnibus_0](Resources/Images/us_deploy_omnibus_0.png)

    </details>

  * Check our new balance on Ganache

    <details><summary>
    Ganache Balance for Us dropped 0.01 ETH from 134.38 ETH to 134.37 ETH following Deployment of Omnibus Contract
    </summary>

    ![Ganache Balances following Omnibus Contract Deployment](Resources/Images/us_deploy_omnibus_ganache_0.png)

    </details>

---
### _**Initiate Auction Contract**_

* As **Us** in MetaMask:

  * Scroll down under CONTRACT and choose **Auction**
  * Compile and Deploy Auction Contract, leaving _**Injected Web3**_ ENVIRONMENT unchanged
    * (Optional) Copy the address of the deployed Auction Contract by clicking on the page button to the right onto a .txt file: 0xf3B554248FDFFc24CE7Aa14689Ed561e0350B801

    <details><summary>
    Auction Contract Deployment
    </summary>

    ![us_deploy_auction_0](Resources/Images/us_deploy_auction_0.png)

    </details>

    <details><summary>
    MetaMask Notification on Auction Contract Deployment
    </summary>

    ![us_deploy_auction_1](Resources/Images/us_deploy_auction_1.png)

    </details>

  * Check our new balance on Ganache

    <details><summary>
    Ganache Balance for Us dropped 0.03 ETH from 134.37 ETH to 134.34 ETH following Deployment of Auction Contract
    </summary>

    ![Ganache Balances following Auction Contract Deployment](Resources/Images/us_deploy_auction_ganache_1.png)

    </details>

---
### _**Bid as Tenant**_

* As **Tenant** in MetaMask, i.e. the third address from the top in Ganache:

* To initiate a bid, enter 10 ether as VALUE under CONTRACT Auction
    * Enter wallet addresses of landord, previous tenant with lease and omnibus contract addresses under DEPLOY section (may be left unchanged from Auction deployment)

  * Scroll down to unfold AUCTION under Deployed Contracts, enter 50 for _rentPercent and _depositPercent respectively for bid
  
    Tenant Bid 10 ETH with 50-50 Split on Rent and Deposit

    ![tenant_bid_auction_10eth](Resources/Images/tenant_bid_auction_10eth.png)


  * Compare balances on Ganache Pre and Post Tenant Bid

    <details><summary>
    Ganache Balance prior to Tenant's bid of 10 ether
    </summary>

    ![Ganache Balances prior to Bid](Resources/Images/tenant_bid_auction_10eth_ganache_pre.png)

    </details>

      Balances on Ganache following Tenant's bid of 10 ether: a drop from 67.13 ETH to 57.13 ETH posted on the third wallet, i.e. the candidate tenant's account

    ![Ganache Balances post Tenant Bid](Resources/Images/tenant_bid_auction_10eth_ganache_post.png)


  * The auction would only proceed should there be a higher bid than 10 ether from this point

    <details><summary>
    A bid of 14 ether that is greater than the previous bid of 10 ether
    </summary>

    ![tenant_bid_auction_14eth](Resources/Images/tenant_bid_auction_14eth.png)

    </details>

    <details><summary>
    Balances on Ganache following Tenant's bid of 14 ether: a drop from 57.13 ETH to 43.12 ETH posted on the third wallet, i.e. the candidate tenant's account. An extra 0.01 ETH gas fee incurred for the bidding.
    </summary>

    ![Ganache Balances post 14 ETH Tenant Bid](Resources/Images/tenant_bid_auction_14eth_ganache_post.png)

    <details><summary>
    Get Balance by pressing **getbalance** button under the Deployed Omnibus Contract: current balance is 50% of 14 ETH, i.e. 7 ETH = 7 * (10^18) Wei
    </summary>

    ![Ganache Balances post 14 ETH Tenant Bid](Resources/Images/tenant_bid_auction_14eth_ganache_omnibus.png)

    </details>

    <details><summary>
    Should there be another bid in the valud of 14 ETH. An error message would pop up as follows:
    </summary>

    ![tenant_bid_auction_14eth_2](Resources/Images/tenant_bid_auction_14eth_2.png)

    </details>

---
### _**Depost to Generate Interest on Omnibus Bank Account**_

* As **Us** in MetaMask, i.e. the second address from the top in Ganache:

  * Open [BankInterestGenerator in Solidity](Code/BankInterestGenerator.sol)
    * Expand view on Deployed Auction Contract at the bottom left-hand-side 

  * Complile and **Deploy BankInterest** contract
    * at the previously deployed address of the Omnibus Contract under [Brokerless Solidity](Code/Brokerless.sol)**_OMNIBUSADDRESS**: 0x721080d169713ec439db4CaE8ED2daCEF4745B5d

    ![us_deploy_BankInterest_0](Resources/Images/us_deploy_BankInterest_0.png)

  * Confirm **CONTRACT DEPLOYMENT** on the MetaMask pop up notification window by clicking on **Confirm** button

    <details><summary>
    Confirm Deployment of BankInterest Contract
    </summary>

    ![us_deploy_BankInterest_1](Resources/Images/us_deploy_BankInterest_1.png)

    </details>

---
### _**Get Funds from Omnibus Bank Account**_

* As **Bank** in MetaMask, i.e. the fifth address from the top in Ganache:

  * Enter _**50 ether**_ as **VALUE** on the **Remix Deployment** page
    * Keep _BankInterest_ under CONTRACT selection
    * Keep __OMNIBUSADDRESS_ the same as the address of the previously deployed Omnibus Contract from [Brokerless Solidity](Code/Brokerless.sol): 0x721080d169713ec439db4CaE8ED2daCEF4745B5d

  * Expaned view of the deployed BankInterest Contract and click on **generateFunds** button

    ![bank_transfer_50eth](Resources/Images/bank_transfer_50eth.png)

  * Confirm **CONTRACT INTERACTION** on the MetaMask notification by clicking on **Confirm** button

    <details><summary>
    Omnibus Bank Account balance dropped from 100 ETH to 49.9994 ETH. The difference is resulted from gas fee.
    </summary>

    ![bank_transfer_50eth_1](Resources/Images/bank_transfer_50eth_1.png)

    </details>

      Balances on Ganache before and after the balance transfer of 50 ether are show below:

    ![Ganache Balances Prior to 50 ETH Transfer](Resources/Images/bank_transfer_50eth_ganache_pre.png)

    ![Ganache Balances After 50 ETH Transfer](Resources/Images/bank_transfer_50eth_ganache_post.png)

---
### _**Return Deposit**_

* As **Landlord** in MetaMask, i.e. the second address from the top in Ganache:

  * Expand view of the deployed **Lease Contract**

  * Click on **returnDeposit** button

  * Confirm on the MetaMask via **Confirm** button

    ![landlord_returndeposit_0](Resources/Images/landlord_returndeposit_0.png)

    <details><summary>
    The balance of Tenant's account went up 7 ETH from 43 ETH to 50 ETH approximately.
    </summary>

    ![landlord_returndeposit_ganache_post](Resources/Images/landlord_returndeposit_ganache_post.png)

    </details>

---
### _**Conclude Auction**_

* As **Landlord** in MetaMask, i.e. the second address from the top in Ganache:

* To conclude an auction, under Auction Contract on Deployment page
    * Expand view on Deployed Auction Contract at the bottom left-hand-side 

  * Press **auctionEnd** button

  * Confirm **AUCTION END** on the MetaMask pop up notification window by clicking on **Confirm** button

    <details><summary>
    Terminate Auction by Landlord
    </summary>

    ![landlord_auctionend_0](Resources/Images/landlord_auctionend_0.png)

    ![landlord_auctionend_1](Resources/Images/landlord_auctionend_1.png)

    </details>

      Balances on Ganache following Tenant's bid of 10 ether: a drop from 67.13 ETH to 57.13 ETH posted on the third wallet, i.e. the candidate tenant's account

    ![Ganache Balances post Tenant Bid](Resources/Images/tenant_bid_auction_10eth_ganache_post.png)






<details><summary>
Archived Process for Previous Versions
</summary>

```
--------------------------------------
********CONTRACT DEPLOYMENT***********
--------------------------------------
* As Landlord deploys Auction contract 
* As Us deploy Lease contract
* As Us deploy the Omnibus contract
--------------------------------------
** Insert bank interest 5%
--------------------------------------


--------------------------------------
*********LEASE CONTRACT**************
--------------------------------------
* Set leaseAddress contract
* Set omnibusAddress contract
* As potentialTenant 1 enter bid Value and split Value between 
  rent percent and deposit percent
* As potentialTenant 2 enter higher bid Value and split Value
  between rent percent and deposit percent
* As potentialTenant 1 withdraw bid to get back money
* As Landlord end auction and accept highest bid. Resulting in the rent being transferred
  to lease contract and deposit gets transferred to the Omnibus contract
--------------------------------------
** Navigate to the Lease contract. As Landlord confirm lease contract
** As Tenant confirm lease contract
--------------------------------------


--------------------------------------
**********OMNIBUS CONTRACT***********
--------------------------------------

* Set Omnibus contract
* Set Previous contract
* Click initialPayout
* Rent payment is transferred to Landlord and Previous Tenant for showing
 the house and Us for offering the platform
--------------------------------------
** In the Previous Tenant Agreement set 
** Click PayRent 
** After duration press requestDeposit
--------------------------------------

```

</details>



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

![webpage_raw](Resources/Images/webpage_raw.png)

</details>

Step 5: Register an apartment by entering Apartment name, Pinata API and Secret API Key

![webpage](Resources/Images/webpage.png)


---
# Next Steps

_**We would like to elaborate on the following aspects on our project:**_

* Duration of contract
* Auction contract should create brokerless contract. 
  * Or contract factory for may empty lease contracts to exist in waiting. 
* Vetting with machine learning
  * Invest deposit with machine learning
* Add damage report 
  * for landlord, require picture submission, allow withdrawal of deposit funds
  * for bidders, from perspectives of a landlord
* Rather than auction process:
  * bidders should offer rent and deposit fee
  * Landlord should be able to choose which to accept
  * Landlord to set minimum
* Add “paper” contract as URI
  * json
  * pdf
  * png

* Allow tenants to offer a higher security deposit that the landlord is allowed to invest (전세) -> more security for the landlord (better tenants)
* Link with property listing platform
* Late fee (require payRent function even month)
* Events in place for javascript Dapps to listen to
  * For user friendly UI

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



