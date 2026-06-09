# https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-python-get-started?tabs=env-virtual
# cosmosCounter.py

import json
import os
import datetime
from zoneinfo import ZoneInfo
from azure.cosmos import CosmosClient, PartitionKey
from azure.cosmos.exceptions import CosmosHttpResponseError, CosmosResourceExistsError, CosmosResourceNotFoundError

#    with open("local.settings.json") as f:
#        settings = json.load(f)

values = settings["Values"]
uri = os.getenv("ACCOUNT_URI")
key = os.getenv("ACCOUNT_KEY")
client = CosmosClient(uri, credential=key)

# dbID = "testing-db"
# containerID = "testing-container"

EST = ZoneInfo("America/New_York")
now = datetime.datetime.now(EST)

def createDatabase(dbID: str):
    # dbID = "testing-db"
    # containerID = "testing-container"
    try:
        database = client.create_database(dbID)
        print(f"Database created: {database.id}")
        return database
    
    except CosmosResourceExistsError:
        print("Database already exists.")
        return client.get_database_client(dbID)
# Create a database
#    try:
#        database = client.create_database(dbID)
#        print(f"Database created: {database.id}")
#
#    except CosmosResourceExistsError:
#        print("Database already exists.")

def createContainer(containerID: str, dbID: str, partitionKey: str):
    try:
        database = client.get_database_client(dbID)
        # print(f"Database found: {database.id}")
        partition_key_path = PartitionKey(path=str("/" + partitionKey))
        # print(f"Partition key path: {partition_key_path.path}")
        container = database.create_container_if_not_exists(
            id=containerID,
            partition_key=partition_key_path,
            # offer_throughput=400,  // causes serverless to fail
        )
        print(f"Container created or returned: {container.id}")
        return container

    except CosmosHttpResponseError:
        print("Request to the Azure Cosmos database service failed.")

# print(str(now))

def updateCount(itemID: str, containerID: str, dbID: str, partitionKey: str):
    createDatabase(dbID)
    container = createContainer(containerID, dbID, partitionKey)

    try:
        currentItem = container.read_item(item=itemID, partition_key=partitionKey)
        newCount = currentItem["counter"] + 1

    except CosmosResourceNotFoundError:
        print("Counter item doesn't exist. Creating it.")
        newCount = 0

    tempCounter = {
        "id": itemID,
        "timestamp": str(datetime.datetime.now(EST)),
        partitionKey: partitionKey,
        "counter": newCount
    }

    print(f"Counter item: {tempCounter}")
    test_counter = container.upsert_item(tempCounter)
    print(f"Count: {test_counter['counter']}")
    return test_counter
    
print(f"URI exists: {uri is not None}")
print(f"KEY exists: {key is not None}")
print("Client found")

testItem = "aCount"
testContainer = "aContainer"
testDB = "aDatabase"
testPartition = "visitCounters"

#   updateCount("aCount", "aContainer", "aDatabase", "visitCounters") // no good
#   runs fine
#   createDatabase(testDB)
#   runs fine
createContainer(testContainer, "cDatabase", testPartition)

#   updateCount(testItem, testContainer, testDB, testPartition)

# container.read_item("test-counter-id", partition_key="testCounter")
# print(f"Count: {test_counter['counter']}")