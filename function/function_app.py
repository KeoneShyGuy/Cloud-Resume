import json
import os
import sys
import uuid
import azure.functions as func
import logging

from azure.core.exceptions import AzureError
from azure.cosmos import CosmosClient, PartitionKey
from azure.identity import DefaultAzureCredential
from cosmosCounter import updateCount

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

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

@app.route(route="visitCounter")
def visitCounter(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    # This is a simple visit counter function that increments a counter 
    # stored in Azure Table Storage each time the function is called.
    return func.HttpResponse("You can count on the counter 👌🏿")

@app.route(route="test")
def test(req: func.HttpRequest) -> func.HttpResponse:

    uri = os.getenv("ACCOUNT_URI")
    key = os.getenv("ACCOUNT_KEY")
    client = CosmosClient(uri, key)

    return func.HttpResponse(
        f"URI exists: {uri is not None}, KEY exists: {key is not None}, CLIENT exists: {client is not None}",
        status_code=200
    )

@app.route(route="count")
def count(req: func.HttpRequest) -> func.HttpResponse:

    testItem = "bCount"
    testContainer = "bContainer"
    testDB = "bDatabase"
    testPartition = "visitCounters"
    tempCounter = updateCount(testItem, testContainer, testDB, testPartition)
    
    return func.HttpResponse(f"Count updated at {tempCounter['timestamp']}! Counter item: {tempCounter['counter']}")