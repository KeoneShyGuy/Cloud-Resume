# https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-python-get-started?tabs=env-virtual
# cosmosCounter.py

import json
import os
import datetime
import uuid
from zoneinfo import ZoneInfo
from azure.cosmos import CosmosClient, PartitionKey
from azure.cosmos.exceptions import CosmosHttpResponseError, CosmosResourceExistsError, CosmosResourceNotFoundError

# Local development can read settings from local.settings.json.
# In Azure, these same names should come from the Function app's configuration settings.
settings = {"Values": {}}
if os.path.exists("local.settings.json"):
    with open("local.settings.json") as f:
        settings = json.load(f)

values = settings["Values"]

uri = os.getenv("ACCOUNT_URI") or values.get("ACCOUNT_URI")
key = os.getenv("ACCOUNT_KEY") or values.get("ACCOUNT_KEY")

# CosmosClient is the SDK object that talks to Cosmos DB.
# Tip: never hard-code the key in code that goes to GitHub.
client = CosmosClient(uri, credential=key)

EST = ZoneInfo("America/New_York")
now = datetime.datetime.now(EST)

def createDatabase(dbID: str):
    # Create the database if it does not exist yet.
    # If it already exists, return the existing database client so the app can keep going.
    try:
        database = client.create_database(dbID)
        print(f"Database created: {database.id}")
        return database
    
    except CosmosResourceExistsError:
        print("Database already exists.")
        return client.get_database_client(dbID)

def createContainer(containerID: str, dbID: str, partitionKey: str):
    try:
        database = client.get_database_client(dbID)

        # Cosmos expects partition key paths to start with "/".
        # Example: partitionKey="type" becomes "/type".
        partition_key_path = PartitionKey(path=str("/" + partitionKey))
        container = database.create_container_if_not_exists(
            id=containerID,
            partition_key=partition_key_path
        )
        print(f"Container created or returned: {container.id}")
        return container
    except CosmosResourceNotFoundError:
        database = createDatabase(dbID=dbID)
        partition_key_path = PartitionKey(path=str("/" + partitionKey))
        container = database.create_container_if_not_exists(
            id=containerID,
            partition_key=partition_key_path
        )
        print(f"Container created or returned: {container.id}")
        return container
    except Exception as e: print(e)


def updateCount(itemID: str, containerID: str, dbID: str, partitionKey: str):
    # The counter is stored as one document.
    # Each page load reads that document, increments the number, and upserts it.
    createDatabase(dbID)
    container = createContainer(containerID, dbID, partitionKey)

    try:
        # For point reads, Cosmos needs both the document id and the partition key value.
        currentItem = container.read_item(item=itemID, partition_key=partitionKey)
        newCount = currentItem["counter"] + 1

    except CosmosResourceNotFoundError:
        # First visitor path: if the counter document is missing, start at 1.
        print("Counter item doesn't exist. Creating it.")
        newCount = 1

    # The partition key property name is dynamic here.
    # If partitionKey is "counter", this writes: "counter": "counter".
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

def addNameSubmission(name: str, containerID: str, dbID: str, partitionKey: str):
    # Name submissions are event records, so each submit creates a brand-new document.
    createDatabase(dbID)
    container = createContainer(containerID, dbID, partitionKey)

    # Store a server-side timestamp so every record uses the same clock.
    timestamp = datetime.datetime.now(EST).isoformat()
    submission = {
        # A UUID keeps each submission unique, even if two visitors enter the same name.
        "id": str(uuid.uuid4()),
        # This value matches the "/type" partition key used by the name-submissions container.
        "type": "nameSubmission",
        "name": name,
        "timestamp": timestamp
    }

    # create_item inserts a new document. It will fail if another document has the same id
    # in the same partition, which is why the UUID matters.
    created_submission = container.create_item(submission)
    print(f"Name submission created: {created_submission['id']}")
    return created_submission
    
print(f"URI exists: {uri is not None}")
print(f"KEY exists: {key is not None}")
print("Client found")
