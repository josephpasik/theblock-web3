import requests
import json
import os

from dotenv import load_dotenv
from pathlib import Path

from web3.auto import w3

load_dotenv()

headers = {
    "Content-Type": "application/json",
    "pinata_api_key": os.getenv("PINATA_API_KEY"),
    "pinata_secret_api_key": os.getenv("PINATA_SECRET_API_KEY"),
}


def initContract():
    with open(Path("CryptoRecord.json")) as json_file:
        abi = json.load(json_file)

    return w3.eth.contract(address=os.getenv("CRYPTORECORD_ADDRESS"), abi=abi)


def convertDataToJSON(landlord, token_id, previous, lease, omnibus, time, description):
    data = {
        "pinataOptions": {"cidVersion": 1},
        "pinataContent": {
            "name": "Space Report",
            # Apartment as "token_id"
            "apartment": token_id,
            "landlord": landlord,
            "previous": previous,
            "lease": lease,
            "omnibus": omnibus,
            "description": description,
            # This is the uploaded v1 URI for apartment on IPFS all in lower case
            "image": f"ipfs://improvemyfavoriteapartmentxoxo_{token_id}",
            "time": time
        },
        "pinataMetadata": {
            "name": description,
            "keyvalues": {
                "customKey": description,
                "customKey2": "baes"
            }
        }
    }
    return json.dumps(data)


def pinJSONtoIPFS(json):
    r = requests.post(
        "https://api.pinata.cloud/pinning/pinJSONToIPFS", data=json, headers=headers
    )
    ipfs_hash = r.json()["IpfsHash"]
    return f"ipfs://{ipfs_hash}"
