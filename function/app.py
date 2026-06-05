# https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-python-get-started?utm_source=chatgpt.com&tabs=env-virtual

import json
import os
import sys
import uuid

from azure.core.exceptions import AzureError
from azure.cosmos import CosmosClient, PartitionKey