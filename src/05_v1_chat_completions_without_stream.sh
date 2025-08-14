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
    ]
}' | jq

# {
#   "id": "chatcmpl-8b080fc675b84f0b980a45ca28b480d4",
#   "object": "chat.completion",
#   "created": 1754911351,
#   "model": "Qwen/Qwen3-0.6B",
#   "choices": [
#     {
#       "index": 0,
#       "message": {
#         "role": "assistant",
#         "reasoning_content": null,
#         "content": "<think>\nOkay, the user is asking for a welcome message for PyCon Korea 2025. First, I need to make sure I understand the context. PyCon is a major tech conference, so the message should be professional but also enthusiastic.\n\nI should start with a friendly greeting. Maybe \"Hello, PyCon Korea 2025!\" to acknowledge the event. Then, mention the key points: the event's significance, the audience, and the organizers. Highlighting the importance of the conference to the tech community is important. Including the date and location would be good too, as they are details that need to be included.\n\nI should also add a call to action, inviting participants to join. Maybe mention the event's goals and the impact it has on the tech industry. It's important to keep the tone positive and encouraging. Let me check if there are any specific details the user might want to include, like the date or the theme, but since the user hasn't provided those, I'll keep it general. Finally, end with a thank you and a sign-off.\n</think>\n\nHello, PyCon Korea 2025! 🌍✨  \n\nWelcome to a premier event for the global tech community — where innovation, collaboration, and discovery come together. This year, we’re celebrating the spirit of creativity and the power of technology to shape the future.  \n\nWhether you’re a passionate developer, a curious idea, or a community leader, PyCon Korea 2025 is the perfect platform to connect, share insights, and inspire growth.  \n\nJoin us as we embrace the challenges and opportunities ahead and make a lasting impact on the tech world.  \n\nThank you for being part of this extraordinary journey! 🚀  \n\nBest regards,  \n[Your Name]  \n[Your Position]  \n[Company/Team Name]  \n\n---  \nLet me know if you'd like to adjust the tone or add specific details!",
#         "tool_calls": []
#       },
#       "logprobs": null,
#       "finish_reason": "stop",
#       "stop_reason": null
#     }
#   ],
#   "usage": {
#     "prompt_tokens": 19,
#     "total_tokens": 415,
#     "completion_tokens": 396,
#     "prompt_tokens_details": null
#   },
#   "prompt_logprobs": null,
#   "kv_transfer_params": null
# }
