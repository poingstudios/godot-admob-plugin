import requests
import json
import os

def get_asset_id():
    return "2063"

login_response = requests.post("https://godotengine.org/asset-library/api/login", data={"username": os.environ["USERNAME"], "password": os.environ["PASSWORD"]})
login_response.raise_for_status()

response = json.loads(login_response.text)

asset_data = {
    "token": response["token"],
    "version_string": os.environ["VERSION"],
    "download_commit": os.environ["COMMIT_HASH"]
}
upload_response = requests.post("https://godotengine.org/asset-library/api/asset/" + get_asset_id(), data=asset_data)
upload_response.raise_for_status()

if upload_response.status_code == 200:
    print("Asset updated with success!")
else:
    print("Error while updating the asset: ", upload_response.json())