import torch
from loguru import logger
from transformers import AutoModelForCausalLM, AutoProcessor

"""
$ uv run src/01_offline_inference_with_transformers.py
2025-07-14 23:21:39.663 | INFO     | __main__:main:9 - MODEL_NAME='Qwen/Qwen3-0.6B'
2025-07-14 23:21:45.507 | INFO     | __main__:main:13 - Model & processor Loaded!
2025-07-14 23:21:45.541 | INFO     | __main__:main:19 - prompt:
<|im_start|>user
Hello, PyCon Korea 2025!<|im_end|>
<|im_start|>assistant

2025-07-14 23:21:54.810 | INFO     | __main__:main:34 - output_text:
user
Hello, PyCon Korea 2025!
assistant
<think>
Okay, the user just said "Hello, PyCon Korea 2025!" so I need to respond. Let me start by acknowledging their message. I should mention PyCon 2025 in the response. Maybe add something about the event's purpose and how it's important. Keep it friendly and encouragi
ng. Let me check if there's any specific information I should include, like dates or themes. Since the user didn't specify, I'll keep it general but highlight the event's significance. Make sure the tone matches a welcoming and informative message. Alright, that s
hould cover it.
</think>

Hello, PyCon Korea 2025! 🎓 What's on your mind? I'm excited to see what comes next. Let me know if you'd like to know more about the event or join us! Stay ahead, and I'll be here to help!
"""

MODEL_NAME = "Qwen/Qwen3-0.6B"


def main():
    logger.info(f"{MODEL_NAME=}")

    processor = AutoProcessor.from_pretrained(MODEL_NAME)
    model = AutoModelForCausalLM.from_pretrained(MODEL_NAME)
    logger.info("Model & processor Loaded!")

    messages = [{"role": "user", "content": "Hello, PyCon Korea 2025!"}]
    prompt = processor.apply_chat_template(
        messages, tokenize=False, add_generation_prompt=True
    )
    logger.info("prompt:")
    print(prompt)
    inputs = processor(prompt, return_tensors="pt")

    with torch.no_grad():
        generated_ids = model.generate(
            **inputs,
            max_new_tokens=1024,
            do_sample=True,
            top_p=0.95,
            temperature=0.8,
            pad_token_id=processor.eos_token_id,
        )

    output_text = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]
    logger.info("output_text:")
    print(output_text)


if __name__ == "__main__":
    main()
