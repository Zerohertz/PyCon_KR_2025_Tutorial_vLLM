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
    "stream": true
}'

# data: {"id":"chatcmpl-3a69ae0975b84bf6940a7349172d8935","object":"chat.completion.chunk","created":1754911477,"model":"Qwen/Qwen3-0.6B","choices":[{"index":0,"delta":{"role":"assistant","content":""},"logprobs":null,"finish_reason":null}]}
#
# data: {"id":"chatcmpl-3a69ae0975b84bf6940a7349172d8935","object":"chat.completion.chunk","created":1754911477,"model":"Qwen/Qwen3-0.6B","choices":[{"index":0,"delta":{"content":"<think>"},"logprobs":null,"finish_reason":null}]}
#
# data: {"id":"chatcmpl-3a69ae0975b84bf6940a7349172d8935","object":"chat.completion.chunk","created":1754911477,"model":"Qwen/Qwen3-0.6B","choices":[{"index":0,"delta":{"content":"\n"},"logprobs":null,"finish_reason":null}]}
#
# ...
#
# data: {"id":"chatcmpl-3a69ae0975b84bf6940a7349172d8935","object":"chat.completion.chunk","created":1754911477,"model":"Qwen/Qwen3-0.6B","choices":[{"index":0,"delta":{"content":"!"},"logprobs":null,"finish_reason":null}]}
#
# data: {"id":"chatcmpl-3a69ae0975b84bf6940a7349172d8935","object":"chat.completion.chunk","created":1754911477,"model":"Qwen/Qwen3-0.6B","choices":[{"index":0,"delta":{"content":""},"logprobs":null,"finish_reason":"stop","stop_reason":null}]}
#
# data: [DONE]
