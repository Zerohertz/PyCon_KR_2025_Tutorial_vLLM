#!/bin/bash

curl http://localhost:8000/v1/models | jq

# {
#   "object": "list",
#   "data": [
#     {
#       "id": "Qwen/Qwen3-0.6B",
#       "object": "model",
#       "created": 1754911042,
#       "owned_by": "vllm",
#       "root": "Qwen/Qwen3-0.6B",
#       "parent": null,
#       "max_model_len": 8192,
#       "permission": [
#         {
#           "id": "modelperm-46d848c0ebbb4d5ba5581510b4e92652",
#           "object": "model_permission",
#           "created": 1754911042,
#           "allow_create_engine": false,
#           "allow_sampling": true,
#           "allow_logprobs": true,
#           "allow_search_indices": false,
#           "allow_view": true,
#           "allow_fine_tuning": false,
#           "organization": "*",
#           "group": null,
#           "is_blocking": false
#         }
#       ]
#     }
#   ]
# }
