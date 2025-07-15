import asyncio

from loguru import logger
from openai import AsyncOpenAI

"""
$ vllm serve Qwen/Qwen3-0.6B --max-model-len 8192
$ uv run src/03_online_inference.py
2025-07-15 21:41:34.171 | INFO     | __main__:main:16 - MODEL_NAME='Qwen/Qwen3-0.6B'
2025-07-15 21:41:34.284 | INFO     | __main__:main:36 - output_text:
<think>
Okay, the user is asking, "Hello, PyCon Korea 2025!" I need to respond appropriately. First, I should acknowledge their greeting. Since PyCon is a major event, I should mention the date and location to show I'm part of the event. But wait, the user might not know the details. I should ask if they want to
 know more about the event or if they need help with anything else. Let me check if there's any specific information needed. They might be planning to attend or have questions about the conference. So, my response should be friendly, confirm the date and location, and invite them to ask more questions. I
 should keep it concise but informative.
</think>

Hello! PyCon Korea 2025 is an exciting event for professionals and innovators in the technology and innovation community! The conference will take place in **Korea**, and the exact date is not yet known. If you'd like to know more details, feel free to ask! 🌟                                             
"""

BASE_URL = "http://localhost:8000/v1"
MODEL_NAME = "Qwen/Qwen3-0.6B"
STREAM = True


async def main():
    logger.info(f"{MODEL_NAME=}")

    client = AsyncOpenAI(api_key=None, base_url=BASE_URL)

    # NOTE: serve_model_name을 모를 때 아래 API를 사용 가능
    # GET /v1/models
    # models = await client.models.list()
    # logger.info(models.data[0].id)

    messages = [
        {"role": "user", "content": "Hello, PyCon Korea 2025!"},
    ]
    response = await client.chat.completions.create(
        model=MODEL_NAME,
        messages=messages,
        max_tokens=2048,
        top_p=0.95,
        temperature=0.8,
        stream=STREAM,
    )
    logger.info("output_text:")
    if STREAM:
        async for chunk in response:
            content = getattr(chunk.choices[0].delta, "content", None)
            if content:
                print(content, end="", flush=True)
    else:
        print(response.choices[0].message.content)


if __name__ == "__main__":
    asyncio.run(main())
