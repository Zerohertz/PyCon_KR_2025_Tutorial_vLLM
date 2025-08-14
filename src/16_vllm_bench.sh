#!/bin/bash

uv run vllm bench serve \
	--model Qwen/Qwen3-0.6B \
	--served-model-name Qwen/Qwen3-0.6B \
	--num-prompts 30 \
	--request-rate 5 \
	--max-concurrency 5 \
	--dataset-name random \
	--random-prefix-len 64 \
	--random-input-len 128 \
	--random-output-len 128 \
	--ignore-eos \
	--seed 42 \
	--percentile-metrics "ttft,tpot,itl,e2el" \
	--save-detailed \
	--save-result \
	--result-dir ./bmt \
	--result-filename vllm_benchmark_$(date +%Y%m%d_%H%M%S).json

# ============ Serving Benchmark Result ============
# Successful requests:                     30
# Benchmark duration (s):                  117.85
# Total input tokens:                      5760
# Total generated tokens:                  3840
# Request throughput (req/s):              0.25
# Output token throughput (tok/s):         32.58
# Total Token throughput (tok/s):          81.46
# ---------------Time to First Token----------------
# Mean TTFT (ms):                          3297.21
# Median TTFT (ms):                        3525.01
# P99 TTFT (ms):                           4507.37
# -----Time per Output Token (excl. 1st token)------
# Mean TPOT (ms):                          128.39
# Median TPOT (ms):                        128.05
# P99 TPOT (ms):                           153.55
# ---------------Inter-token Latency----------------
# Mean ITL (ms):                           128.39
# Median ITL (ms):                         117.44
# P99 ITL (ms):                            181.72
# ----------------End-to-end Latency----------------
# Mean E2EL (ms):                          19602.75
# Median E2EL (ms):                        19743.86
# P99 E2EL (ms):                           20598.58
# ==================================================

# vLLM Benchmark 스크립트 상세 설명
#
# 기본 설정:
# --model: 벤치마크할 모델 경로 (HuggingFace 모델명 또는 로컬 경로)
# --served-model-name: API에서 사용할 모델 이름 (기본값: --model과 동일)
# --tokenizer: 토크나이저 경로 (기본값: 모델과 동일)
# --tokenizer-mode: 토크나이저 모드 [auto, slow, mistral, custom] (기본값: auto)
#
# 요청 설정:
# --num-prompts: 총 요청 수 (기본값: 1000)
# --request-rate: 초당 요청 수 (QPS), inf로 설정 시 모든 요청을 한번에 전송 (기본값: inf)
# --max-concurrency: 최대 동시 요청 수, 서버 부하 제한용 (기본값: None)
# --burstiness: 요청 생성의 버스트성 (1.0: 포아송 프로세스, <1: 더 버스트, >1: 더 균등) (기본값: 1.0)
#
# 데이터셋 옵션:
# --dataset-name: 사용할 데이터셋 [sharegpt, burstgpt, sonnet, random, hf, custom] (기본값: random)
# --dataset-path: ShareGPT/Sonnet 데이터셋 경로 또는 HuggingFace 데이터셋 ID
#
# Random 데이터셋 옵션:
# --random-prefix-len: 고정 프리픽스 토큰 수 (기본값: 0)
# --random-input-len: 입력 토큰 수 (기본값: 1024)
# --random-output-len: 출력 토큰 수 (기본값: 128)
# --random-range-ratio: 입출력 길이 샘플링 범위 비율 [0, 1) (기본값: 0.0)
#
# ShareGPT 데이터셋 옵션:
# --sharegpt-output-len: 각 요청의 출력 길이 오버라이드
#
# Sonnet 데이터셋 옵션:
# --sonnet-input-len: 입력 토큰 수 (기본값: 550)
# --sonnet-output-len: 출력 토큰 수 (기본값: 150)
# --sonnet-prefix-len: 프리픽스 토큰 수 (기본값: 200)
#
# HuggingFace 데이터셋 옵션:
# --hf-output-len: 출력 길이 오버라이드
# --hf-split: HF 데이터셋 분할 (train/test/validation 등)
# --hf-subset: HF 데이터셋 하위집합
#
# Custom 데이터셋 옵션:
# --custom-output-len: 출력 토큰 수 (기본값: 256)
# --custom-skip-chat-template: 채팅 템플릿 적용 건너뛰기
#
# 성능 측정 옵션:
# --percentile-metrics: 측정할 지표 [ttft, tpot, itl, e2el] (기본값: ttft,tpot,itl)
#   - ttft: Time To First Token (첫 토큰까지의 시간)
#   - tpot: Time Per Output Token (출력 토큰당 시간)
#   - itl: Inter-Token Latency (토큰 간 지연시간)
#   - e2el: End-to-End Latency (전체 응답 시간)
# --metric-percentiles: 백분위수 설정 (예: "25,50,75,95,99") (기본값: 99)
# --goodput: 서비스 수준 목표 설정 (예: "ttft:100 tpot:50")
#
# 서버 연결 설정:
# --host: 서버 호스트 (기본값: localhost)
# --port: 서버 포트 (기본값: 8000)
# --base-url: 커스텀 베이스 URL
# --endpoint: API 엔드포인트 (기본값: /v1/completions)
# --backend: 백엔드 타입 [vllm, openai, openai-chat, openai-audio]
#
# 샘플링 파라미터:
# --temperature: 온도 파라미터 (기본값: None, 즉 greedy decoding)
# --top-p: Top-p 샘플링 파라미터
# --top-k: Top-k 샘플링 파라미터
# --min-p: Min-p 샘플링 파라미터
# --use-beam-search: 빔 서치 사용
# --logprobs: 토큰당 로그 확률 수
#
# 기타 옵션:
# --ignore-eos: EOS 토큰 무시하고 지정된 길이까지 생성 (주의: deepspeed_mii, tgi에서 미지원)
# --seed: 재현 가능한 결과를 위한 랜덤 시드
# --trust-remote-code: HuggingFace에서 원격 코드 신뢰
# --lora-modules: LoRA 모듈 이름들 (각 요청마다 랜덤 선택)
#
# 결과 저장 옵션:
# --save-result: 벤치마크 결과를 JSON 파일로 저장
# --save-detailed: 상세 결과 저장 (요청별 응답, 오류, 지연시간 등)
# --result-dir: 결과 파일 저장 디렉토리 (기본값: 현재 디렉토리)
# --result-filename: 결과 파일명 커스터마이징
# --append-result: 기존 JSON 파일에 결과 추가
# --label: 벤치마크 결과 레이블 (기본값: 엔드포인트 타입)
# --metadata: 메타데이터 key=value 쌍 (예: --metadata version=0.3.3 tp=1)
#
# 고급 설정:
# --ramp-up-strategy: 램프업 전략 [linear, exponential]
# --ramp-up-start-rps: 램프업 시작 RPS
# --ramp-up-end-rps: 램프업 종료 RPS
# --disable-tqdm: tqdm 프로그레스 바 비활성화
# --profile: Torch Profiler 사용 (VLLM_TORCH_PROFILER_DIR 환경변수 필요)
