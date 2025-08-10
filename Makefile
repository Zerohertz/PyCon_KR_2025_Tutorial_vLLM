.PHONY: init format check serve models load_lora unload_lora

init:
	uv venv
	. .venv/bin/activate
	uv sync
	uv run huggingface-cli download Qwen/Qwen3-0.6B

format:
	uvx ruff format .

check:
	uvx ruff check . --fix;

serve:
	VLLM_ALLOW_RUNTIME_LORA_UPDATING=True \
		uv run vllm serve Qwen/Qwen3-0.6B \
		--max-model-len 8192 \
		--reasoning-parser qwen3 \
		--enable-auto-tool-choice \
		--tool-call-parser hermes \
		--enable-lora

models:
	curl http://localhost:8000/v1/models | jq

load_lora:
	curl -X POST http://localhost:8000/v1/load_lora_adapter \
		-H "Content-Type: application/json" \
		-d '{"lora_name": "phh/Qwen3-0.6B-TLDR-Lora", "lora_path": "phh/Qwen3-0.6B-TLDR-Lora"}'

unload_lora:
	curl -X POST http://localhost:8000/v1/unload_lora_adapter \
		-H "Content-Type: application/json" \
		-d '{"lora_name": "phh/Qwen3-0.6B-TLDR-Lora"}'
