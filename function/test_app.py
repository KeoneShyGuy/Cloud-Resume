import json
import os
from azure.cosmos import CosmosClient

with open("local.settings.json") as f:
    settings = json.load(f)

values = settings["Values"]

uri = values.get("ACCOUNT_URI")
key = values.get("ACCOUNT_KEY")
dbID = "testing-db"

print(f"URI exists: {uri is not None}")
print(f"KEY exists: {key is not None}")

client = CosmosClient(uri, credential=key)
print("Client found")

try:
    database = client.create_database(dbID)
    print(f"Database created: {database.id}")

except CosmosResourceExistsError:
    print("Database already exists.")

