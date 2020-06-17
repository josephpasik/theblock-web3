import sys
from dotenv import load_dotenv
from record import convertDataToJSON, pinJSONtoIPFS, initContract, w3
from pprint import pprint

cryptorecord = initContract()


def createAptReport():
    landlord = input("Landlord: ")
    # apt is treated as token_id here and "token_id" in CryptoRecord.sol
    token_id = str(input("Apartment ID: "))
    previous = input("Previous Tenant: ")
    lease = int(input("Lease #: "))
    omnibus = int(input("Omnibus #: "))
    time = input("Date of the incident: ")
    description = input("Description of the incident: ")

    json_data = convertDataToJSON(landlord, token_id, previous, lease, omnibus, time, description)
    report_uri = pinJSONtoIPFS(json_data)

    return token_id, report_uri

def reportIncident(token_id, report_uri):
    tx_hash = cryptorecord.functions.reportIncident(token_id, report_uri).transact(
        {"from": w3.eth.accounts[0]}
    )
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    return receipt


def getAptReports(token_id):
    incident_filter = cryptorecord.events.Incident.createFilter(
        fromBlock="0x0", argument_filters={"Apartment": token_id}
    )
    return incident_filter.get_all_entries()


# sys.argv is the list of arguments passed from the command line
# sys.argv[0] is always the name of the script
# sys.argv[1] is the first argument, and so on
# For example:
#        sys.argv[0]        sys.argv[1]    sys.argv[2]
# python accident.py        report
# python accident.py        get            1

def main():
    if sys.argv[1] == "report":
        token_id, landlord, report_uri = createAptReport()

        receipt = reportIncident(token_id, report_uri)

        pprint(receipt)
        print("Report IPFS Hash:", report_uri)

    if sys.argv[1] == "get":
        token_id = int(sys.argv[2])

        incident = cryptorecord.functions.apts(token_id).call()
        reports = getAptReports(token_id)

    pprint(reports)
    print("APT", incident[0], "has been in", incident[1], "reports.")
    

main()
