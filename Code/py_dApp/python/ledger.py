import sys
from dotenv import load_dotenv
from record import convertDataToJSON, pinJSONtoIPFS, initContract, w3
from pprint import pprint

registerApt = initContract()

def createAptReport():
    landlord = int(input("Landlord: "))
    apt = int(input("Apt #: "))
    previous = int(input("Previous Tenant: "))
    lease = int(input("Lease: "))
    omnibus = int(input("Omnibus: "))

    json_data = convertDataToJSON(landlord, apt, previous, lease, omnibus)
    report_uri = pinJSONtoIPFS(json_data)

    return landlord, report_uri


def reportApt(landlord, report_uri):
    tx_hash = registerApt.functions.reportApt(landlord, report_uri).transact(
        {"from": w3.eth.accounts[0]}
    )
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    return receipt


def getAptReports(landlord):
    apt_filter = registerApt.events.Apt.createFilter(
        fromBlock="0x0", argument_filters={"landlord": landlord}
    )
    return apt_filter.get_all_entries()


# sys.argv is the list of arguments passed from the command line
# sys.argv[0] is always the name of the script
# sys.argv[1] is the first argument, and so on
# For example:
#        sys.argv[0]        sys.argv[1]    sys.argv[2]
# python accident.py        report
# python accident.py        get            1

option = input("Would you like to get or report an apartment listing?")

def main():
    if sys.argv[1] == "report":
        landlord, report_uri = createAptReport()

        receipt = reportApt(landlord, report_uri)

        pprint(receipt)
        print("Report IPFS Hash:", report_uri)

    if sys.argv[1] == "get":
        token_id = int(sys.argv[2])

    apt = registerApt.functions.apts(landlord).call()
    reports = getAptReports(landlord)

    pprint(reports)
    print("APT", apt[0], "has been in", apt[1], "apartments.")
    

main()
