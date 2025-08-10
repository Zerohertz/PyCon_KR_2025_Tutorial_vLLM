#!/usr/bin/env .venv/bin/python

from loguru import logger
from vllm import LLM, SamplingParams

"""
$ uv run src/02_offline_inference_with_vllm.py
INFO 07-15 21:27:05 [__init__.py:244] Automatically detected platform cpu.
2025-07-15 21:27:06.722 | INFO     | __main__:main:12 - MODEL_NAME='Qwen/Qwen3-0.6B'
INFO 07-15 21:27:10 [config.py:841] This model supports multiple tasks: {'reward', 'classify', 'embed', 'generate'}. Defaulting to 'generate'.
WARNING 07-15 21:27:10 [config.py:3320] Your device 'cpu' doesn't support torch.bfloat16. Falling back to torch.float16 for compatibility.
WARNING 07-15 21:27:10 [config.py:3371] Casting torch.bfloat16 to torch.float16.
INFO 07-15 21:27:10 [config.py:1472] Using max model len 2048
INFO 07-15 21:27:10 [arg_utils.py:1746] cpu is experimental on VLLM_USE_V1=1. Falling back to V0 Engine.
WARNING 07-15 21:27:10 [cpu.py:131] Environment variable VLLM_CPU_KVCACHE_SPACE (GiB) for CPU backend is not set, using 4 by default.
INFO 07-15 21:27:10 [llm_engine.py:230] Initializing a V0 LLM engine (v0.9.2) with config: model='Qwen/Qwen3-0.6B', speculative_config=None, tokenizer='Qwen/Qwen3-0.6B', skip_tokenizer_init=False, tokenizer_mode=auto, revision=None, override_neuron_config={}, tokenizer_revision=None, trust_remote_code=Fa
lse, dtype=torch.float16, max_seq_len=2048, download_dir=None, load_format=LoadFormat.AUTO, tensor_parallel_size=1, pipeline_parallel_size=1, disable_custom_all_reduce=True, quantization=None, enforce_eager=False, kv_cache_dtype=auto,  device_config=cpu, decoding_config=DecodingConfig(backend='auto', dis
able_fallback=False, disable_any_whitespace=False, disable_additional_properties=False, reasoning_backend=''), observability_config=ObservabilityConfig(show_hidden_metrics_for_version=None, otlp_traces_endpoint=None, collect_detailed_traces=None), seed=0, served_model_name=Qwen/Qwen3-0.6B, num_scheduler_
steps=1, multi_step_stream_outputs=True, enable_prefix_caching=None, chunked_prefill_enabled=False, use_async_output_proc=False, pooler_config=None, compilation_config={"level":0,"debug_dump_path":"","cache_dir":"","backend":"","custom_ops":[],"splitting_ops":[],"use_inductor":true,"compile_sizes":[],"in
ductor_compile_config":{"enable_auto_functionalized_v2":false},"inductor_passes":{},"use_cudagraph":true,"cudagraph_num_of_warmups":0,"cudagraph_capture_sizes":[],"cudagraph_copy_inputs":false,"full_cuda_graph":false,"max_capture_size":256,"local_cache_dir":null}, use_cached_outputs=False, 
WARNING 07-15 21:27:11 [cpu_worker.py:447] Auto thread-binding is not supported due to the lack of package numa and psutil,fallback to no thread-binding. To get better performance,please try to manually bind threads.
INFO 07-15 21:27:11 [cpu.py:69] Using Torch SDPA backend.
INFO 07-15 21:27:11 [importing.py:63] Triton not installed or not compatible; certain GPU-related functions will not be available.
INFO 07-15 21:27:11 [parallel_state.py:1076] rank 0 in world size 1 is assigned as DP rank 0, PP rank 0, TP rank 0, EP rank 0
INFO 07-15 21:27:11 [weight_utils.py:292] Using model weights format ['*.safetensors']
INFO 07-15 21:27:12 [weight_utils.py:345] No model.safetensors.index.json found in remote.
Loading safetensors checkpoint shards:   0% Completed | 0/1 [00:00<?, ?it/s]
Loading safetensors checkpoint shards: 100% Completed | 1/1 [00:00<00:00,  1.50it/s]
Loading safetensors checkpoint shards: 100% Completed | 1/1 [00:00<00:00,  1.50it/s]

INFO 07-15 21:27:12 [default_loader.py:272] Loading weights took 0.68 seconds
INFO 07-15 21:27:12 [executor_base.py:113] # cpu blocks: 2340, # CPU blocks: 0
INFO 07-15 21:27:12 [executor_base.py:118] Maximum concurrency for 2048 tokens per request: 18.28x
INFO 07-15 21:27:13 [llm_engine.py:428] init engine (profile, create kv cache, warmup model) took 0.49 seconds
INFO 07-15 21:27:15 [chat_utils.py:444] Detected the chat template content format to be 'string'. You can set `--chat-template-content-format` to override this.
Adding requests: 100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 1/1 [00:00<00:00, 5133.79it/s]
Processed prompts:   0%|                                                                                                                                                                                                               | 0/1 [00:00<?, ?it/s, est. speed input: 0.00 toks/s, output: 0.00 toks/s]
WARNING 07-15 21:27:15 [cpu.py:250] Pin memory is not supported on CPU.
Processed prompts: 100%|██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 1/1 [00:03<00:00,  3.94s/it, est. speed input: 4.82 toks/s, output: 41.63 toks/s]
2025-07-15 21:27:19.306 | INFO     | __main__:main:21 - output_text:
<think>
Okay, the user is asking me to respond to "Hello, PyCon Korea 2025!" as if they are a guest. I need to make sure I address them in a friendly and welcoming manner. Let me think... They might be joining the event, so a positive and enthusiastic reply would be appropriate. I should mention the event's purp
ose, the audience, and maybe invite them to participate. Also, I should keep the tone friendly and enthusiastic. Let me put that together in a natural way.
</think>

Hello, PyCon Korea 2025! It's great to meet you in person. Joining this event is fantastic—your presence will make it even more exciting! What can I do for you? Let's make it a memorable experience! 🌐✨
"""

MODEL_NAME = "Qwen/Qwen3-0.6B"


def main():
    logger.info(f"{MODEL_NAME=}")

    llm = LLM(model=MODEL_NAME, max_model_len=2048)
    messages = [
        {"role": "user", "content": "Hello, PyCon Korea 2025!"},
    ]
    sampling_params = SamplingParams(top_p=0.95, temperature=0.8, max_tokens=2048)
    outputs = llm.chat(messages, sampling_params=sampling_params)
    for output in outputs:
        logger.info("output_text:")
        print(output.outputs[0].text)


if __name__ == "__main__":
    main()
