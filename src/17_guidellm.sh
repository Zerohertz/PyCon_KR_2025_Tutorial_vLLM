#!/bin/bash

uv run guidellm benchmark \
	--target http://localhost:8000 \
	--backend-type openai_http \
	--model Qwen/Qwen3-0.6B \
	--data '{"prompt_tokens": 128, "output_tokens": 128, "count": 50}' \
	--rate-type concurrent \
	--rate 5 \
	--max-seconds 60 \
	--output-path ./bmt/guidellm_limited_concurrent_benchmark_$(date +%Y%m%d_%H%M%S).json

# ╭─ Benchmarks ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
# │ [22:44:29] ⠹ 100% concurrent@5 (complete)   Req:    0.3 req/s,   19.40s Lat,     5.0 Conc,      10 Comp,        5 Inc,        0 Err                                                                                                                                                                           │
# │                                             Tok:   33.0 gen/s,   98.7 tot/s, 1752.6ms TTFT,  138.9ms ITL,   128 Prompt,      128 Gen                                                                                                                                                                          │
# ╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
# Generating... ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ (1/1) [ 0:01:01 < 0:00:00 ]
#
#
# Benchmarks Metadata:
#     Run id:8886bdc0-f6e5-4ff0-b952-dfe17eef9f99
#     Duration:62.9 seconds
#     Profile:type=concurrent, strategies=['concurrent'], streams=[5]
#     Args:max_number=None, max_duration=60.0, warmup_number=None, warmup_duration=None, cooldown_number=None, cooldown_duration=None
#     Worker:type_='generative_requests_worker' backend_type='openai_http' backend_target='http://localhost:8000' backend_model='Qwen/Qwen3-0.6B' backend_info={'max_output_tokens': 16384, 'timeout': 300, 'http2': True, 'authorization': False, 'organization': None, 'project': None, 'text_completions_path':
#     '/v1/completions', 'chat_completions_path': '/v1/chat/completions'}
#     Request Loader:type_='generative_request_loader' data='{"prompt_tokens": 128, "output_tokens": 128, "count": 50}' data_args=None processor='Qwen/Qwen3-0.6B' processor_args=None
#     Extras:None
#
#
# Benchmarks Info:
# =====================================================================================================================================================
# Metadata                                     |||| Requests Made  ||| Prompt Tok/Req ||| Output Tok/Req ||| Prompt Tok Total  ||| Output Tok Total  ||
#    Benchmark| Start Time| End Time| Duration (s)|  Comp|  Inc|  Err|  Comp|   Inc| Err|  Comp|   Inc| Err|   Comp|   Inc|   Err|   Comp|   Inc|   Err
# ------------|-----------|---------|-------------|------|-----|-----|------|------|----|------|------|----|-------|------|------|-------|------|------
# concurrent@5|   22:44:33| 22:45:31|         57.9|    10|    5|    0| 128.0| 128.0| 0.0| 128.0| 117.0| 0.0|   1280|   640|     0|   1280|   585|     0
# =====================================================================================================================================================
#
#
# Benchmarks Stats:
# =========================================================================================================================================================
# Metadata    | Request Stats         || Out Tok/sec| Tot Tok/sec| Req Latency (ms)  ||| TTFT (ms)           ||| ITL (ms)          ||| TPOT (ms)         ||
#    Benchmark| Per Second| Concurrency|        mean|        mean|  mean| median|   p99|   mean| median|    p99|  mean| median|   p99|  mean| median|   p99
# ------------|-----------|------------|------------|------------|------|-------|------|-------|-------|-------|------|-------|------|------|-------|------
# concurrent@5|       0.26|        5.00|        33.0|        98.7| 19.40|  19.14| 19.65| 1752.6| 2023.0| 2143.0| 138.9|  137.9| 151.4| 137.8|  136.8| 150.2
# =========================================================================================================================================================
#
# Saving benchmarks report...
# Benchmarks report saved to bmt/guidellm_limited_concurrent_benchmark_20250814_224424.json
#
# Benchmarking complete.

# 포아송 분포 벤치마크 (Poisson Distribution)
uv run guidellm benchmark \
	--target http://localhost:8000 \
	--backend-type openai_http \
	--model Qwen/Qwen3-0.6B \
	--data '{"prompt_tokens": 512, "output_tokens": 256, "count": 200}' \
	--rate-type poisson \
	--rate 3 \
	--max-requests 150 \
	--random-seed 42 \
	--output-path ./bmt/guidellm_poisson_benchmark_$(date +%Y%m%d_%H%M%S).json

# 동시성 벤치마크 (Concurrent Requests)
uv run guidellm benchmark \
	--target http://localhost:8000 \
	--backend-type openai_http \
	--model Qwen/Qwen3-0.6B \
	--data '{"prompt_tokens": 128, "output_tokens": 64, "count": 80}' \
	--rate-type concurrent \
	--rate 10 \
	--max-seconds 90 \
	--output-path ./bmt/guidellm_concurrent_benchmark_$(date +%Y%m%d_%H%M%S).json

# 비동기 벤치마크 (Async Benchmark)
uv run guidellm benchmark \
	--target http://localhost:8000 \
	--backend-type openai_http \
	--model Qwen/Qwen3-0.6B \
	--data '{"prompt_tokens": 1024, "output_tokens": 512, "count": 30}' \
	--rate-type async \
	--rate 2 \
	--max-requests 25 \
	--display-scheduler-stats \
	--output-path ./bmt/guidellm_async_benchmark_$(date +%Y%m%d_%H%M%S).json

# 스위프 벤치마크 (Sweep Multiple Rates)
uv run guidellm benchmark \
	--target http://localhost:8000 \
	--backend-type openai_http \
	--model Qwen/Qwen3-0.6B \
	--data synthetic \
	--data '{"prompt_tokens": 256, "output_tokens": 128, "count": 300}' \
	--rate-type sweep \
	--rate 5 \
	--max-seconds 60 \
	--warmup-percent 15 \
	--cooldown-percent 10 \
	--random-seed 42 \
	--output-path ./bmt/guidellm_sweep_benchmark_$(date +%Y%m%d_%H%M%S).json

# 동기 벤치마크 (Synchronous - 순차 실행)
uv run guidellm benchmark \
	--target http://localhost:8000 \
	--backend-type openai_http \
	--model Qwen/Qwen3-0.6B \
	--data synthetic \
	--data '{"prompt_tokens": 128, "output_tokens": 64, "count": 20}' \
	--rate-type synchronous \
	--max-requests 20 \
	--output-path ./bmt/guidellm_synchronous_benchmark_$(date +%Y%m%d_%H%M%S).json

# HuggingFace 데이터셋 사용 벤치마크
uv run guidellm benchmark \
	--target http://localhost:8000 \
	--backend-type openai_http \
	--model Qwen/Qwen3-0.6B \
	--data openai/gsm8k \
	--data-args '{"split": "test"}' \
	--data-sampler random \
	--rate-type constant \
	--rate 3 \
	--max-requests 50 \
	--random-seed 42 \
	--output-path ./bmt/guidellm_hf_dataset_benchmark_$(date +%Y%m%d_%H%M%S).json

# 커스텀 프로세서와 백엔드 인자 사용
uv run guidellm benchmark \
	--target http://localhost:8000 \
	--backend-type openai_http \
	--backend-args '{"timeout": 30, "max_retries": 3}' \
	--model Qwen/Qwen3-0.6B \
	--processor Qwen/Qwen3-0.6B \
	--data synthetic \
	--data '{"prompt_tokens": 512, "output_tokens": 256, "count": 100}' \
	--rate-type constant \
	--rate 4 \
	--max-seconds 180 \
	--warmup-percent 20 \
	--output-sampling 500 \
	--output-extras '{"experiment": "custom_processor", "version": "1.0"}' \
	--random-seed 42 \
	--output-path ./bmt/guidellm_custom_benchmark_$(date +%Y%m%d_%H%M%S).json

# GuideLLM Benchmark 옵션 상세 설명
#
# 필수 옵션:
# --target: 벤치마크 대상 서버 URL (예: http://localhost:8000)
# --data: 데이터 소스 (synthetic, HF 데이터셋 ID, 파일 경로)
# --rate-type: 벤치마크 유형
#   - async: 비동기 요청 (지정된 QPS로)
#   - sweep: 여러 비율로 스위프 테스트
#   - constant: 고정 QPS
#   - poisson: 포아송 분포 간격
#   - synchronous: 순차 실행 (rate 불필요)
#   - throughput: 최대 처리량 측정 (rate 불필요)
#   - concurrent: 동시 요청 수 고정
#
# 백엔드 설정:
# --backend-type: 백엔드 유형 (현재 openai_http만 지원)
# --backend-args: 백엔드 추가 인자 (JSON 문자열)
# --model: 모델 ID (None이면 첫 번째 사용 가능 모델)
#
# 프로세서 설정:
# --processor: 토크나이저/프로세서 (통계와 합성 데이터 생성용)
# --processor-args: 프로세서 생성자 인자 (JSON 문자열)
#
# 데이터 설정:
# --data: 데이터 소스
#   - synthetic: 합성 데이터
#   - HuggingFace 데이터셋 ID (예: openai/gsm8k)
#   - 파일 경로 (csv, json, jsonl, txt)
# --data-args: 데이터 생성/로드 인자 (JSON 문자열)
#   - synthetic 예시: '{"prompt_tokens": 128, "output_tokens": 64, "count": 100}'
#   - HF 데이터셋 예시: '{"split": "test", "subset": "main"}'
# --data-sampler: 데이터 샘플러 (random: 랜덤 셔플)
#
# 비율 설정:
# --rate: 벤치마크 비율
#   - async,constant,poisson: 초당 요청 수 (QPS)
#   - concurrent: 동시 요청 수
#   - sweep: 스위프에서 실행할 벤치마크 수
#   - synchronous,throughput: 설정하지 않음
#
# 실행 제한:
# --max-seconds: 각 벤치마크 최대 실행 시간 (초)
# --max-requests: 각 벤치마크 최대 요청 수
# --warmup-percent: 워밍업 비율 (결과에 포함되지 않음)
# --cooldown-percent: 쿨다운 비율 (결과에 포함되지 않음)
#
# 출력 설정:
# --output-path: 결과 저장 경로
#   - 디렉토리면 benchmarks.json으로 저장
#   - 파일이면 확장자에 따라 json, yaml, csv 지원
# --output-extras: 추가 메타데이터 (JSON 문자열)
# --output-sampling: 출력 파일에 저장할 샘플 수 (None이면 전체)
#
# 기타 옵션:
# --random-seed: 재현성을 위한 랜덤 시드
# --disable-progress: 진행률 표시 비활성화
# --display-scheduler-stats: 스케줄러 통계 표시
# --disable-console-outputs: 콘솔 출력 비활성화
#
# 사용 예시별 설명:
# 1. throughput: 서버의 최대 처리량을 측정
# 2. constant: 안정적인 QPS로 성능 측정
# 3. poisson: 실제 트래픽과 유사한 패턴으로 테스트
# 4. concurrent: 동시 사용자 수에 따른 성능 측정
# 5. async: 비동기 환경에서의 성능 측정
# 6. sweep: 다양한 부하 수준에서 성능 곡선 생성
# 7. synchronous: 단순 순차 실행으로 기본 지연시간 측정
