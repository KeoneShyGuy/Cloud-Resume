param dnszones_keoneshyguy_com_name string = 'keoneshyguy.com'
param staticSites_KeoneCloudResume_name string = 'KeoneCloudResume'
param profiles_kshy_cloud_resume_front_door_name string = 'kshy-cloud-resume-front-door'
param storageAccounts_storagefromgithub_name string = 'storagefromgithub'
param databaseAccounts_kshyguy_cloud_resume_db_name string = 'kshyguy-cloud-resume-db'

resource profiles_kshy_cloud_resume_front_door_name_resource 'Microsoft.Cdn/profiles@2025-12-01' = {
  name: profiles_kshy_cloud_resume_front_door_name
  location: 'Global'
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  kind: 'frontdoor'
  properties: {
    originResponseTimeoutSeconds: 60
  }
}

resource databaseAccounts_kshyguy_cloud_resume_db_name_resource 'Microsoft.DocumentDB/databaseAccounts@2025-11-01-preview' = {
  name: databaseAccounts_kshyguy_cloud_resume_db_name
  location: 'East US'
  tags: {
    defaultExperience: 'Core (SQL)'
    'hidden-workload-type': 'Learning'
    'hidden-cosmos-mmspecial': ''
  }
  kind: 'GlobalDocumentDB'
  identity: {
    type: 'None'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    enableAutomaticFailover: true
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: false
    virtualNetworkRules: []
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: false
    enableAnalyticalStorage: false
    analyticalStorageConfiguration: {
      schemaType: 'WellDefined'
    }
    databaseAccountOfferType: 'Standard'
    enableMaterializedViews: false
    capacityMode: 'Serverless'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: false
    enablePartitionMerge: false
    enablePerRegionPerPartitionAutoscale: false
    enableBurstCapacity: false
    enablePriorityBasedExecution: false
    defaultPriorityLevel: 'High'
    minimalTlsVersion: 'Tls12'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    locations: [
      {
        locationName: 'East US'
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    cors: []
    capabilities: []
    ipRules: []
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 1440
        backupRetentionIntervalInHours: 48
        backupStorageRedundancy: 'Geo'
      }
    }
    networkAclBypassResourceIds: []
    diagnosticLogSettings: {
      enableFullTextQuery: 'None'
    }
    capacity: {
      totalThroughputLimit: 4000
    }
  }
}

resource dnszones_keoneshyguy_com_name_resource 'Microsoft.Network/dnszones@2023-07-01-preview' = {
  name: dnszones_keoneshyguy_com_name
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}

resource storageAccounts_storagefromgithub_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_storagefromgithub_name
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    defaultToOAuthAuthentication: true
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    networkAcls: {
      ipv6Rules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource staticSites_KeoneCloudResume_name_resource 'Microsoft.Web/staticSites@2024-11-01' = {
  name: staticSites_KeoneCloudResume_name
  location: 'East US 2'
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    repositoryUrl: 'https://github.com/KeoneShyGuy/Cloud-Resume'
    branch: 'main'
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'GitHub'
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

resource profiles_kshy_cloud_resume_front_door_name_cloud_resume 'Microsoft.Cdn/profiles/afdendpoints@2025-12-01' = {
  parent: profiles_kshy_cloud_resume_front_door_name_resource
  name: 'cloud-resume'
  location: 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource profiles_kshy_cloud_resume_front_door_name_default_origin_group 'Microsoft.Cdn/profiles/origingroups@2025-12-01' = {
  parent: profiles_kshy_cloud_resume_front_door_name_resource
  name: 'default-origin-group'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 100
    }
    sessionAffinityState: 'Disabled'
  }
}

resource profiles_kshy_cloud_resume_front_door_name_0_939780ba_6644_4b52_be80_99804fe003ae_keoneshyguy_com 'Microsoft.Cdn/profiles/secrets@2025-12-01' = {
  parent: profiles_kshy_cloud_resume_front_door_name_resource
  name: '0--939780ba-6644-4b52-be80-99804fe003ae-keoneshyguy-com'
  properties: {
    parameters: {
      type: 'AzureFirstPartyManagedCertificate'
    }
  }
}

resource profiles_kshy_cloud_resume_front_door_name_0_f048e924_1062_4b3c_882d_e26a5b612343_www_keoneshyguy_com 'Microsoft.Cdn/profiles/secrets@2025-12-01' = {
  parent: profiles_kshy_cloud_resume_front_door_name_resource
  name: '0--f048e924-1062-4b3c-882d-e26a5b612343-www-keoneshyguy-com'
  properties: {
    parameters: {
      type: 'AzureFirstPartyManagedCertificate'
    }
  }
}

resource databaseAccounts_kshyguy_cloud_resume_db_name_00000000_0000_0000_0000_000000000003 'Microsoft.DocumentDB/databaseAccounts/gremlinRoleDefinitions@2025-11-01-preview' = {
  parent: databaseAccounts_kshyguy_cloud_resume_db_name_resource
  name: '00000000-0000-0000-0000-000000000003'
  properties: {
    roleName: 'Cosmos DB Gremlin Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_kshyguy_cloud_resume_db_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/read'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/containers/entities/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_kshyguy_cloud_resume_db_name_00000000_0000_0000_0000_000000000004 'Microsoft.DocumentDB/databaseAccounts/gremlinRoleDefinitions@2025-11-01-preview' = {
  parent: databaseAccounts_kshyguy_cloud_resume_db_name_resource
  name: '00000000-0000-0000-0000-000000000004'
  properties: {
    roleName: 'Cosmos DB Gremlin Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_kshyguy_cloud_resume_db_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/read'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/write'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/*'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/write'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/delete'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/containers/entities/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource Microsoft_DocumentDB_databaseAccounts_mongoMIRoleDefinitions_databaseAccounts_kshyguy_cloud_resume_db_name_00000000_0000_0000_0000_000000000003 'Microsoft.DocumentDB/databaseAccounts/mongoMIRoleDefinitions@2025-11-01-preview' = {
  parent: databaseAccounts_kshyguy_cloud_resume_db_name_resource
  name: '00000000-0000-0000-0000-000000000003'
  properties: {
    roleName: 'Cosmos DB Mongo Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_kshyguy_cloud_resume_db_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/read'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/containers/entities/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource Microsoft_DocumentDB_databaseAccounts_mongoMIRoleDefinitions_databaseAccounts_kshyguy_cloud_resume_db_name_00000000_0000_0000_0000_000000000004 'Microsoft.DocumentDB/databaseAccounts/mongoMIRoleDefinitions@2025-11-01-preview' = {
  parent: databaseAccounts_kshyguy_cloud_resume_db_name_resource
  name: '00000000-0000-0000-0000-000000000004'
  properties: {
    roleName: 'Cosmos DB Mongo Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_kshyguy_cloud_resume_db_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/read'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/write'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/*'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/write'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/delete'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/containers/entities/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_kshyguy_cloud_resume_db_name_counter_database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2025-11-01-preview' = {
  parent: databaseAccounts_kshyguy_cloud_resume_db_name_resource
  name: 'counter-database'
  properties: {
    resource: {
      id: 'counter-database'
    }
  }
}

resource databaseAccounts_kshyguy_cloud_resume_db_name_00000000_0000_0000_0000_000000000001 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2025-11-01-preview' = {
  parent: databaseAccounts_kshyguy_cloud_resume_db_name_resource
  name: '00000000-0000-0000-0000-000000000001'
  properties: {
    roleName: 'Cosmos DB Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_kshyguy_cloud_resume_db_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_kshyguy_cloud_resume_db_name_00000000_0000_0000_0000_000000000002 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2025-11-01-preview' = {
  parent: databaseAccounts_kshyguy_cloud_resume_db_name_resource
  name: '00000000-0000-0000-0000-000000000002'
  properties: {
    roleName: 'Cosmos DB Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_kshyguy_cloud_resume_db_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource Microsoft_DocumentDB_databaseAccounts_tableRoleDefinitions_databaseAccounts_kshyguy_cloud_resume_db_name_00000000_0000_0000_0000_000000000001 'Microsoft.DocumentDB/databaseAccounts/tableRoleDefinitions@2025-11-01-preview' = {
  parent: databaseAccounts_kshyguy_cloud_resume_db_name_resource
  name: '00000000-0000-0000-0000-000000000001'
  properties: {
    roleName: 'Cosmos DB Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_kshyguy_cloud_resume_db_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/entities/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource Microsoft_DocumentDB_databaseAccounts_tableRoleDefinitions_databaseAccounts_kshyguy_cloud_resume_db_name_00000000_0000_0000_0000_000000000002 'Microsoft.DocumentDB/databaseAccounts/tableRoleDefinitions@2025-11-01-preview' = {
  parent: databaseAccounts_kshyguy_cloud_resume_db_name_resource
  name: '00000000-0000-0000-0000-000000000002'
  properties: {
    roleName: 'Cosmos DB Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_kshyguy_cloud_resume_db_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/tables/*'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/entities/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource dnszones_keoneshyguy_com_name_www 'Microsoft.Network/dnszones/CNAME@2023-07-01-preview' = {
  parent: dnszones_keoneshyguy_com_name_resource
  name: 'www'
  properties: {
    TTL: 600
    CNAMERecord: {
      cname: 'delightful-mud-00812ec0f.7.azurestaticapps.net'
    }
    targetResource: {}
    trafficManagementProfile: {}
  }
}

resource Microsoft_Network_dnszones_NS_dnszones_keoneshyguy_com_name 'Microsoft.Network/dnszones/NS@2023-07-01-preview' = {
  parent: dnszones_keoneshyguy_com_name_resource
  name: '@'
  properties: {
    TTL: 172800
    NSRecords: [
      {
        nsdname: 'ns1-05.azure-dns.com.'
      }
      {
        nsdname: 'ns2-05.azure-dns.net.'
      }
      {
        nsdname: 'ns3-05.azure-dns.org.'
      }
      {
        nsdname: 'ns4-05.azure-dns.info.'
      }
    ]
    targetResource: {}
    trafficManagementProfile: {}
  }
}

resource Microsoft_Network_dnszones_SOA_dnszones_keoneshyguy_com_name 'Microsoft.Network/dnszones/SOA@2023-07-01-preview' = {
  parent: dnszones_keoneshyguy_com_name_resource
  name: '@'
  properties: {
    TTL: 3600
    SOARecord: {
      email: 'azuredns-hostmaster.microsoft.com'
      expireTime: 2419200
      host: 'ns1-05.azure-dns.com.'
      minimumTTL: 300
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
    targetResource: {}
    trafficManagementProfile: {}
  }
}

resource Microsoft_Network_dnszones_TXT_dnszones_keoneshyguy_com_name 'Microsoft.Network/dnszones/TXT@2023-07-01-preview' = {
  parent: dnszones_keoneshyguy_com_name_resource
  name: '@'
  properties: {
    TTL: 600
    TXTRecords: [
      {
        value: [
          '_8z9ok0oywysrg5phjtshtqhmfrxbh4t'
        ]
      }
      {
        value: [
          '_mw9ufssyjeu101zbzjznoe6q9ujdi9y'
        ]
      }
      {
        value: [
          'keoneshyguy.com'
        ]
      }
    ]
    targetResource: {}
    trafficManagementProfile: {}
  }
}

resource storageAccounts_storagefromgithub_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_storagefromgithub_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    staticWebsite: {
      enabled: false
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_storagefromgithub_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_storagefromgithub_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_storagefromgithub_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: storageAccounts_storagefromgithub_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_storagefromgithub_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: storageAccounts_storagefromgithub_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource staticSites_KeoneCloudResume_name_default 'Microsoft.Web/staticSites/basicAuth@2024-11-01' = {
  parent: staticSites_KeoneCloudResume_name_resource
  name: 'default'
  location: 'East US 2'
  properties: {
    applicableEnvironmentsMode: 'SpecifiedEnvironments'
  }
}

resource staticSites_KeoneCloudResume_name_keoneshyguy_com 'Microsoft.Web/staticSites/customDomains@2024-11-01' = {
  parent: staticSites_KeoneCloudResume_name_resource
  name: 'keoneshyguy.com'
  location: 'East US 2'
  properties: {}
}

resource staticSites_KeoneCloudResume_name_www_keoneshyguy_com 'Microsoft.Web/staticSites/customDomains@2024-11-01' = {
  parent: staticSites_KeoneCloudResume_name_resource
  name: 'www.keoneshyguy.com'
  location: 'East US 2'
  properties: {}
}

resource profiles_kshy_cloud_resume_front_door_name_default_origin_group_default_origin 'Microsoft.Cdn/profiles/origingroups/origins@2025-12-01' = {
  parent: profiles_kshy_cloud_resume_front_door_name_default_origin_group
  name: 'default-origin'
  properties: {
    hostName: 'delightful-mud-00812ec0f.7.azurestaticapps.net'
    httpPort: 80
    httpsPort: 443
    originHostHeader: 'delightful-mud-00812ec0f.7.azurestaticapps.net'
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: true
  }
  dependsOn: [
    profiles_kshy_cloud_resume_front_door_name_resource
  ]
}

resource databaseAccounts_kshyguy_cloud_resume_db_name_counter_database_name_submissions 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2025-11-01-preview' = {
  parent: databaseAccounts_kshyguy_cloud_resume_db_name_counter_database
  name: 'name-submissions'
  properties: {
    resource: {
      id: 'name-submissions'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/type'
        ]
        kind: 'Hash'
        version: 2
      }
      conflictResolutionPolicy: {
        mode: 'LastWriterWins'
        conflictResolutionPath: '/_ts'
      }
    }
  }
  dependsOn: [
    databaseAccounts_kshyguy_cloud_resume_db_name_resource
  ]
}

resource databaseAccounts_kshyguy_cloud_resume_db_name_counter_database_visit_container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2025-11-01-preview' = {
  parent: databaseAccounts_kshyguy_cloud_resume_db_name_counter_database
  name: 'visit-container'
  properties: {
    resource: {
      id: 'visit-container'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/counter'
        ]
        kind: 'Hash'
        version: 2
      }
      conflictResolutionPolicy: {
        mode: 'LastWriterWins'
        conflictResolutionPath: '/_ts'
      }
    }
  }
  dependsOn: [
    databaseAccounts_kshyguy_cloud_resume_db_name_resource
  ]
}

resource Microsoft_Network_dnszones_A_dnszones_keoneshyguy_com_name 'Microsoft.Network/dnszones/A@2023-07-01-preview' = {
  parent: dnszones_keoneshyguy_com_name_resource
  name: '@'
  properties: {
    TTL: 600
    targetResource: {
      id: staticSites_KeoneCloudResume_name_resource.id
    }
    trafficManagementProfile: {}
  }
}

resource storageAccounts_storagefromgithub_name_default_azure_webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  parent: storageAccounts_storagefromgithub_name_default
  name: 'azure-webjobs-hosts'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_storagefromgithub_name_resource
  ]
}

resource profiles_kshy_cloud_resume_front_door_name_keoneshyguy_com_bd25 'Microsoft.Cdn/profiles/customdomains@2025-12-01' = {
  parent: profiles_kshy_cloud_resume_front_door_name_resource
  name: 'keoneshyguy-com-bd25'
  properties: {
    hostName: 'keoneshyguy.com'
    tlsSettings: {
      certificateType: 'AzureFirstPartyManagedCertificate'
      minimumTlsVersion: 'TLS12'
      cipherSuiteSetType: 'TLS12_2023'
      secret: {
        id: profiles_kshy_cloud_resume_front_door_name_0_939780ba_6644_4b52_be80_99804fe003ae_keoneshyguy_com.id
      }
    }
    preValidatedCustomDomainResourceId: {
      id: staticSites_KeoneCloudResume_name_resource.id
    }
  }
}

resource profiles_kshy_cloud_resume_front_door_name_www_keoneshyguy_com_d6c9 'Microsoft.Cdn/profiles/customdomains@2025-12-01' = {
  parent: profiles_kshy_cloud_resume_front_door_name_resource
  name: 'www-keoneshyguy-com-d6c9'
  properties: {
    hostName: 'www.keoneshyguy.com'
    tlsSettings: {
      certificateType: 'AzureFirstPartyManagedCertificate'
      minimumTlsVersion: 'TLS12'
      cipherSuiteSetType: 'TLS12_2023'
      secret: {
        id: profiles_kshy_cloud_resume_front_door_name_0_f048e924_1062_4b3c_882d_e26a5b612343_www_keoneshyguy_com.id
      }
    }
    preValidatedCustomDomainResourceId: {
      id: staticSites_KeoneCloudResume_name_resource.id
    }
  }
}

resource profiles_kshy_cloud_resume_front_door_name_cloud_resume_default_route 'Microsoft.Cdn/profiles/afdendpoints/routes@2025-12-01' = {
  parent: profiles_kshy_cloud_resume_front_door_name_cloud_resume
  name: 'default-route'
  properties: {
    customDomains: [
      {
        id: profiles_kshy_cloud_resume_front_door_name_keoneshyguy_com_bd25.id
      }
      {
        id: profiles_kshy_cloud_resume_front_door_name_www_keoneshyguy_com_d6c9.id
      }
    ]
    originGroup: {
      id: profiles_kshy_cloud_resume_front_door_name_default_origin_group.id
    }
    ruleSets: []
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'MatchRequest'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }
  dependsOn: [
    profiles_kshy_cloud_resume_front_door_name_resource
  ]
}
