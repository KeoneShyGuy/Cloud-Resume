# https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-python-get-started?tabs=env-virtual
import json
import os
import datetime
from zoneinfo import ZoneInfo
from azure.cosmos import CosmosClient, PartitionKey
from azure.cosmos.exceptions import CosmosHttpResponseError, CosmosResourceExistsError

with open("local.settings.json") as f:
    settings = json.load(f)

values = settings["Values"]

uri = values.get("ACCOUNT_URI")
key = values.get("ACCOUNT_KEY")
client = CosmosClient(uri, credential=key)
dbID = "testing-db"
containerID = "testing-container"

EST = ZoneInfo("America/New_York")
now = datetime.datetime.now(EST)

print(f"URI exists: {uri is not None}")
print(f"KEY exists: {key is not None}")
print("Client found")

# Create a database
try:
    database = client.create_database(dbID)
    print(f"Database created: {database.id}")

except CosmosResourceExistsError:
    print("Database already exists.")

# create a container
try:
    database = client.get_database_client(dbID)
    # print(f"Database found: {database.id}")
    partition_key_path = PartitionKey(path="/testCounter")
    # print(f"Partition key path: {partition_key_path.path}")
    container = database.create_container_if_not_exists(
        id=containerID,
        partition_key=partition_key_path,
        # offer_throughput=400,  // causes serverless to fail with 400 error, so we will not set it and let it default to serverless
    )
    print(f"Container created or returned: {container.id}")

except CosmosHttpResponseError:
    print("Request to the Azure Cosmos database service failed.")

# print(str(now))

try:
    currentItem = container.read_item("test-counter-id", partition_key="testCounter")
    tempCounter = {
        "id": "test-counter-id",
        "timestamp": str(now),
        "testCounter": "testCounter",
        "counter": currentItem["counter"] + 1
    }   
    print(f"Counter item: {tempCounter}")
    test_counter = container.upsert_item(tempCounter)
    print(f"Count: {test_counter['counter']}")
except:
    tempCounter = {
        "id": "test-counter-id",
        "timestamp": str(now),
        "testCounter": "testCounter",
        "counter": 0
    }
    print(f"Counter item: {tempCounter}")
    test_counter = container.upsert_item(tempCounter)
    print(f"Count: {test_counter['counter']}")

# container.read_item("test-counter-id", partition_key="testCounter")
# print(f"Count: {test_counter['counter']}")