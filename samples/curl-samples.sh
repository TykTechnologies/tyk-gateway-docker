#!/usr/bin/env bash
#test the REST
curl http://localhost:8080/hello -i

# HOT Reload CRITICAL
curl -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" -s http://localhost:8080/tyk/reload/group | python -mjson.tool

# Make an api via curl...
curl -v -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "name": "Dave Test API",
    "slug": "dave-test-api",
    "api_id": "100",
    "org_id": "default",
    "auth": {
      "auth_header_name": "Authorization"
    },
    "definition": {
      "location": "header",
      "key": "x-api-version"
    },
    "version_data": {
      "not_versioned": true,
      "versions": {
        "Default": {
          "name": "Default",
          "use_extended_paths": true
        }
      }
    },
    "proxy": {
      "listen_path": "/dave-test-api/",
      "target_url": "http://httpbin.org/",
      "strip_listen_path": true
    },
    "active": true
}' http://localhost:8080/tyk/apis/ | python -mjson.tool

## --------  API key
curl -X POST -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "allowance": 1000,
    "rate": 1000,
    "per": 1,
    "expires": -1,
    "quota_max": -1,
    "org_id": "1",
    "quota_renews": 1449051461,
    "quota_remaining": -1,
    "quota_renewal_rate": 60,
    "access_rights": {
      "100": {
        "api_id": "100",
        "api_name": "Dave Test API",
        "versions": ["Default"]
      }
    },
    "meta_data": {}
  }' http://localhost:8080/tyk/keys/create | python -mjson.tool
#-response
{
  "action": "added",
  "key": "1bc0690cc2dad4a7c914aba6c539839b8",
  "key_hash": "d3f0c98a",
  "status": "ok"
}
# Dave Test API
{
  "action": "added",
  "key": "166671e73dc5649e29782e6e7cbb7c3e9",
  "key_hash": "78f6c993",
  "status": "ok"
}
##---------------------
# AWS
{
  "action": "added",
  "key": "192581688594c453f95ce3fe574f5cfeb",
  "key_hash": "a5ec7819",
  "status": "ok"
}

# HOT Reload CRITICAL
curl -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" -s http://localhost:8080/tyk/reload/group | python -mjson.tool

#curl -H "Authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" -s http://localhost:8080/dave-test-api/ | python -mjson.tool
curl -H "Authorization: 166671e73dc5649e29782e6e7cbb7c3e9" -s http://localhost:8080/dave-test-api/
curl -H "Authorization: 192581688594c453f95ce3fe574f5cfeb" -s http://localhost:8080/dave-test-api/ #aws

##---------------------
##---------------------
## Echo West using UUID
curl -v -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "name": "Echo West",
    "slug": "echo-west",
    "api_id": "0E61DF2C-44DC-4BA7-9CA5-31D897AA4C1D",
    "org_id": "default",
    "auth": {
      "auth_header_name": "Authorization"
    },
    "definition": {
      "location": "header",
      "key": "x-api-version"
    },
    "version_data": {
      "not_versioned": true,
      "versions": {
        "Default": {
          "name": "Default",
          "use_extended_paths": true
        }
      }
    },
    "proxy": {
      "listen_path": "/echo-west/",
      "target_url": "https://echo-west.byu-oit-apimanager-dev.amazon.byu.edu/v1/echo/asdf",
      "strip_listen_path": true
    },
    "active": true
}' http://localhost:8080/tyk/apis/ | python -mjson.tool
# Response Docker
#
#{
#    "action": "added",
#    "key": "0E61DF2C-44DC-4BA7-9CA5-31D897AA4C1D",
#    "status": "ok"
#}
# Response AWS
# {
#    "action": "added",
#    "key": "0E61DF2C-44DC-4BA7-9CA5-31D897AA4C1D",
#    "status": "ok"
#}

curl -X POST -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "allowance": 1000,
    "rate": 1000,
    "per": 1,
    "expires": -1,
    "quota_max": -1,
    "org_id": "1",
    "quota_renews": 1449051461,
    "quota_remaining": -1,
    "quota_renewal_rate": 60,
    "access_rights": {
      "0E61DF2C-44DC-4BA7-9CA5-31D897AA4C1D": {
        "api_id": "0E61DF2C-44DC-4BA7-9CA5-31D897AA4C1D",
        "api_name": "Echo West",
        "versions": [
          "Default"
          ]
      }
    },
    "meta_data": {}
  }' http://localhost:8080/tyk/keys/create | python -mjson.tool
#response
#{
#    "action": "added",
#    "key": "116965e53314744368e3608a569256174",
#    "key_hash": "f9872867",
#    "status": "ok"
#}
# AWS
# {
#    "action": "added",
#    "key": "1c1c76c6a3fb147959cdfad8a5e031010",
#    "key_hash": "88e901bd",
#    "status": "ok"
#}

# HOT Reload CRITICAL
curl -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" -s http://localhost:8080/tyk/reload/group | python -mjson.tool
curl -H "Authorization: 1c1c76c6a3fb147959cdfad8a5e031010" -s http://localhost:8080/echo-west/ | python -mjson.tool

# ----------------
# ----------------
## Echo East using UUID
curl -v -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "name": "Echo East",
    "slug": "echo-east",
    "api_id": "5BE3ADFD-3E4D-4592-B8BC-527F3A338EB7",
    "org_id": "default",
    "auth": {
      "auth_header_name": "Authorization"
    },
    "definition": {
      "location": "header",
      "key": "x-api-version"
    },
    "version_data": {
      "not_versioned": true,
      "versions": {
        "Default": {
          "name": "Default",
          "use_extended_paths": true
        }
      }
    },
    "proxy": {
      "listen_path": "/echo-east/",
      "target_url": "https://echo-east.byu-oit-apimanager-dev.amazon.byu.edu/v1/echo/asdf",
      "strip_listen_path": true
    },
    "active": true
}' http://localhost:8080/tyk/apis/ | python -mjson.tool
# Response
#{
#    "action": "added",
#    "key": "5BE3ADFD-3E4D-4592-B8BC-527F3A338EB7",
#    "status": "ok"
#}
# AWS
# {
#    "action": "added",
#    "key": "5BE3ADFD-3E4D-4592-B8BC-527F3A338EB7",
#    "status": "ok"
#}

# get the Access Token
curl -X POST -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "allowance": 1000,
    "rate": 1000,
    "per": 1,
    "expires": -1,
    "quota_max": -1,
    "org_id": "1",
    "quota_renews": 1449051461,
    "quota_remaining": -1,
    "quota_renewal_rate": 60,
    "access_rights": {
      "5BE3ADFD-3E4D-4592-B8BC-527F3A338EB7": {
        "api_id": "5BE3ADFD-3E4D-4592-B8BC-527F3A338EB7",
        "api_name": "Echo East",
        "versions": ["Default"]
      }
    },
    "meta_data": {}
  }' http://localhost:8080/tyk/keys/create | python -mjson.tool
#response
#{
#    "action": "added",
#    "key": "1a612bbfba3734030a292a8a61479daa5",
#    "key_hash": "61f0ef3c",
#    "status": "ok"
#}
# AWS
# {
#    "action": "added",
#    "key": "1a755e446078f468985baa1c3af6cb219",
#    "key_hash": "07ada0cf",
#    "status": "ok"
#}

# HOT Reload CRITICAL
curl -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" -s http://localhost:8080/tyk/reload/group | python -mjson.tool
curl -H "Authorization: 1a755e446078f468985baa1c3af6cb219" -s http://localhost:8080/echo-east/ | python -mjson.tool

# ----------------
# ----------------
## Echo JoshLocal using UUID
curl -v -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "name": "Echo Josh",
    "slug": "echo-josh",
    "api_id": "2710CFB6-40AA-4E3A-AE11-9456BF3E0E1F",
    "org_id": "default",
    "auth": {
      "auth_header_name": "Authorization"
    },
    "definition": {
      "location": "header",
      "key": "x-api-version"
    },
    "version_data": {
      "not_versioned": true,
      "versions": {
        "Default": {
          "name": "Default",
          "use_extended_paths": true
        }
      }
    },
    "proxy": {
      "listen_path": "/echo-josh/",
      "target_url": "http://home.joshgubler.com/v1/echo/asdf",
      "strip_listen_path": true
    },
    "active": true
}' http://localhost:8080/tyk/apis/ | python -mjson.tool
# Response
#{
#    "action": "added",
#    "key": "2710CFB6-40AA-4E3A-AE11-9456BF3E0E1F",
#    "status": "ok"
#}
# AWS
# {
#    "action": "added",
#    "key": "2710CFB6-40AA-4E3A-AE11-9456BF3E0E1F",
#    "status": "ok"
#}

# get the Access Token
curl -X POST -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{
    "allowance": 1000,
    "rate": 1000,
    "per": 1,
    "expires": -1,
    "quota_max": -1,
    "org_id": "1",
    "quota_renews": 1449051461,
    "quota_remaining": -1,
    "quota_renewal_rate": 60,
    "access_rights": {
      "2710CFB6-40AA-4E3A-AE11-9456BF3E0E1F": {
        "api_id": "2710CFB6-40AA-4E3A-AE11-9456BF3E0E1F",
        "api_name": "Echo Josh",
        "versions": ["Default"]
      }
    },
    "meta_data": {}
  }' http://localhost:8080/tyk/keys/create | python -mjson.tool
#response
#{
#    "action": "added",
#    "key": "173ef5243658547d39d728ad5eeea46e3",
#    "key_hash": "bc65f1d8",
#    "status": "ok"
#}
# AWS
# {
#    "action": "added",
#    "key": "118f80271e85d4dd6921bed9f57b9094a",
#    "key_hash": "ea2567da",
#    "status": "ok"
#}

# HOT Reload CRITICAL
curl -H "x-tyk-authorization: Zls7rrBtx7hwDfk2G6rSJUskBZc31D8I" -s http://localhost:8080/tyk/reload/group | python -mjson.tool
curl -H "Authorization: 118f80271e85d4dd6921bed9f57b9094a" -s http://localhost:8080/echo-josh/ | python -mjson.tool