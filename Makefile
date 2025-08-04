.PHONY: init format check

init:
	uv venv
	. .venv/bin/activate
	uv sync
	huggingface-cli download Qwen/Qwen3-0.6B

format:
	uvx ruff format .

check:
	uvx ruff check . --fix; \
	uvx ty check .;
