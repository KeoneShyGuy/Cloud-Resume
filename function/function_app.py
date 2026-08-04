import json
import os
import sys
import uuid
import azure.functions as func
import logging

from azure.core.exceptions import AzureError
from azure.cosmos import CosmosClient, PartitionKey
from azure.identity import DefaultAzureCredential
from cosmosCounter import addNameSubmission, updateCount

# This creates the Azure Functions app object.
# ANONYMOUS means the frontend can call these routes without passing a function key.
app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.route(route="http_trigger")
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get('name')

    if name:
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
             status_code=200
        )

@app.route(route="test")
def test(req: func.HttpRequest) -> func.HttpResponse:

    # Quick health check for local troubleshooting.
    # It verifies that the app can see the Cosmos DB settings without printing the secret values.
    uri = os.getenv("ACCOUNT_URI")
    key = os.getenv("ACCOUNT_KEY")
    client = CosmosClient(uri, key)

    return func.HttpResponse(
        f"URI exists: {uri is not None}, KEY exists: {key is not None}, CLIENT exists: {client is not None}",
        status_code=200
    )

@app.route(route="count", methods=["GET"])
def count(req: func.HttpRequest) -> func.HttpResponse:

    # These IDs tell the helper which Cosmos database/container/document to use.
    # The counter is one document that gets updated over and over.
    counter_item = "visit-counter"
    # Use a dedicated container whose partition key is /type. The original
    # visit-container used /counter, which collided with the numeric counter
    # field and caused every request to look in the wrong logical partition.
    # Cosmos DB cannot change an existing container's partition-key path, so a
    # new container name is required for the corrected schema.
    counter_container = "visit-counter-v2"
    database = "counter-database"
    counter_partition = "type"

    # updateCount reads the current number, adds 1, then writes it back to Cosmos DB.
    tempCounter = updateCount(counter_item, counter_container, database, counter_partition)
    
    # The React app expects JSON, so return only the values it needs.
    return func.HttpResponse(
        json.dumps({
            "counter": tempCounter["counter"],
            "timestamp": tempCounter["timestamp"]
        }),
        mimetype="application/json",
        status_code=200
    )

@app.route(route="nameSubmission", methods=["POST"])
def nameSubmission(req: func.HttpRequest) -> func.HttpResponse:
    # The React form sends JSON like: { "name": "Keone" }.
    try:
        req_body = req.get_json()
    except ValueError:
        return func.HttpResponse(
            json.dumps({"error": "Request body must be valid JSON."}),
            mimetype="application/json",
            status_code=400
        )

    # Always validate user input on the backend, even if the frontend also checks it.
    name = str(req_body.get("name", "")).strip()
    if not name:
        return func.HttpResponse(
            json.dumps({"error": "Name is required."}),
            mimetype="application/json",
            status_code=400
        )

    # Name submissions are separate documents, so they live in their own container.
    # That keeps append-only records separate from the single counter document.
    name_submission_container = "name-submissions"
    database = "counter-database"
    partition_key = "type"
    submission = addNameSubmission(name, name_submission_container, database, partition_key)

    # 201 means "created". The response is useful for testing in browser DevTools or curl.
    return func.HttpResponse(
        json.dumps({
            "id": submission["id"],
            "name": submission["name"],
            "timestamp": submission["timestamp"]
        }),
        mimetype="application/json",
        status_code=201
    )
