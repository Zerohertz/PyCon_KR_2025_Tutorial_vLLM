#!/bin/bash

curl -X POST http://localhost:8000/v1/chat/completions \
	-H "Content-Type: application/json" \
	-d '{
    "model": "Qwen/Qwen3-0.6B",
    "messages": [
        {
            "role": "user",
            "content": "Hello, PyCon Korea 2025!"
        }
    ],
    "chat_template_kwargs": {"enable_thinking": true}
}' | jq

# {
#   "id": "chatcmpl-8eb6c33541a84eb4b96562ef7c858290",
#   "object": "chat.completion",
#   "created": 1754912052,
#   "model": "Qwen/Qwen3-0.6B",
#   "choices": [
#     {
#       "index": 0,
#       "message": {
#         "role": "assistant",
#         "reasoning_content": null,
#         "content": "Hello, PyCon Korea 2025! 🎉 What's the best way to celebrate this event? Let me know!",
#         "tool_calls": []
#       },
#       "logprobs": null,
#       "finish_reason": "stop",
#       "stop_reason": null
#     }
#   ],
#   "usage": {
#     "prompt_tokens": 23,
#     "total_tokens": 52,
#     "completion_tokens": 29,
#     "prompt_tokens_details": null
#   },
#   "prompt_logprobs": null,
#   "kv_transfer_params": null
# }
