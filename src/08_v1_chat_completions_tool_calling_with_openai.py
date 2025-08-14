#!/usr/bin/env .venv/bin/python

import asyncio
import json
import sys
from datetime import datetime
from typing import Any, Dict, List

from loguru import logger
from openai import AsyncOpenAI

read = sys.stdin.readline

BASE_URL = "http://localhost:8000/v1"
MODEL_NAME = "Qwen/Qwen3-0.6B"
STREAM = True  # 스트리밍 출력 사용


# Tool 정의 (OpenAI Function Calling 형식)
TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "get_weather",
            "description": "특정 도시의 현재 날씨 정보를 가져옵니다",
            "parameters": {
                "type": "object",
                "properties": {
                    "city": {
                        "type": "string",
                        "description": "날씨를 확인하고 싶은 도시 이름",
                    }
                },
                "required": ["city"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "calculate",
            "description": "수학 계산을 수행합니다",
            "parameters": {
                "type": "object",
                "properties": {
                    "expression": {
                        "type": "string",
                        "description": "계산할 수식 (예: 2+3, 10*5, 100/4)",
                    }
                },
                "required": ["expression"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "get_current_time",
            "description": "현재 날짜와 시간을 가져옵니다",
            "parameters": {"type": "object", "properties": {}, "required": []},
        },
    },
    {
        "type": "function",
        "function": {
            "name": "search_news",
            "description": "특정 주제의 최신 뉴스를 검색합니다",
            "parameters": {
                "type": "object",
                "properties": {
                    "topic": {
                        "type": "string",
                        "description": "검색하고 싶은 뉴스 주제 (예: AI, 파이썬, 기술, 경제)",
                    }
                },
                "required": ["topic"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "get_restaurant_recommendations",
            "description": "특정 지역의 맛집을 추천합니다",
            "parameters": {
                "type": "object",
                "properties": {
                    "location": {
                        "type": "string",
                        "description": "맛집을 찾고 싶은 지역 (예: 서울, 부산, 제주)",
                    },
                    "cuisine_type": {
                        "type": "string",
                        "description": "음식 종류 (예: 한식, 중식, 일식, 해산물)",
                        "default": "한식",
                    },
                },
                "required": ["location"],
            },
        },
    },
]


# Tool 함수들 정의
def get_weather(city: str) -> str:
    """특정 도시의 날씨 정보를 가져옵니다."""
    weather_data = {
        "서울": "맑음, 22°C, 습도 45%",
        "부산": "흐림, 25°C, 습도 60%",
        "대구": "비, 18°C, 습도 85%",
        "인천": "맑음, 20°C, 습도 50%",
        "광주": "흐림, 23°C, 습도 55%",
        "대전": "맑음, 21°C, 습도 40%",
        "울산": "흐림, 24°C, 습도 65%",
        "제주": "맑음, 26°C, 습도 70%",
    }
    return weather_data.get(city, f"{city}의 날씨 정보를 찾을 수 없습니다.")


def calculate(expression: str) -> str:
    """수학 계산을 수행합니다."""
    try:
        # 보안상 eval 사용은 권장하지 않지만, 예제를 위해 사용
        # 실제로는 더 안전한 수식 파서 사용 권장
        allowed_chars = set("0123456789+-*/.() ")
        if not all(c in allowed_chars for c in expression):
            return "안전하지 않은 문자가 포함되어 있습니다."

        result = eval(expression)
        return f"{expression} = {result}"
    except Exception as e:
        return f"계산 오류: {str(e)}"


def get_current_time() -> str:
    """현재 시간을 가져옵니다."""
    current_time = datetime.now()
    return f"현재 시간: {current_time.strftime('%Y년 %m월 %d일 %H시 %M분 %S초')}"


def search_news(topic: str) -> str:
    """특정 주제의 뉴스를 검색합니다."""
    news_data = {
        "AI": [
            "OpenAI, 새로운 GPT 모델 발표로 AI 업계 주목",
            "한국형 AI 반도체 개발 프로젝트 본격 시동",
            "AI 윤리 가이드라인 국제 표준화 논의 활발",
        ],
        "파이썬": [
            "Python 3.13 정식 릴리스, 성능 대폭 개선",
            "PyCon Korea 2025, 역대 최대 규모로 개최 예정",
            "Django 5.1 업데이트, 새로운 기능 다수 추가",
        ],
        "기술": [
            "6G 기술 표준화 작업 국제적으로 진행 중",
            "양자컴퓨터 상용화, 2030년대 현실화 전망",
            "메타버스 플랫폼, 교육 분야 적용 확산",
        ],
        "경제": [
            "반도체 시장 회복세, 하반기 성장 전망",
            "스타트업 투자 시장, 선별적 투자 경향 강화",
            "디지털 화폐 규제 방안 정부 차원에서 검토",
        ],
    }

    for keyword, articles in news_data.items():
        if keyword.lower() in topic.lower() or topic.lower() in keyword.lower():
            return f"{keyword} 관련 최신 뉴스:\n" + "\n".join(
                [f"• {article}" for article in articles]
            )

    return f"'{topic}' 관련 뉴스를 찾을 수 없습니다. 다른 주제를 시도해보세요."


def get_restaurant_recommendations(location: str, cuisine_type: str = "한식") -> str:
    """특정 지역의 맛집을 추천합니다."""
    restaurants = {
        "서울": {
            "한식": ["광화문 한정식", "명동 갈비집", "강남 삼계탕"],
            "중식": ["차이나타운 짜장면", "홍콩반점", "북경반점"],
            "일식": ["스시 야마", "라멘 타로", "돈카츠 마츠"],
        },
        "부산": {
            "한식": ["해운대 회센터", "광안리 갈비", "서면 냉면"],
            "해산물": ["자갈치 활어회", "민락수변공원 회", "해동용궁 멸치쌈밥"],
        },
        "제주": {
            "한식": ["제주 흑돼지", "올레국수", "성산 해물탕"],
            "해산물": ["성산포 활전복", "우도 해물라면", "표선 갈치조림"],
        },
    }

    if location in restaurants:
        if cuisine_type in restaurants[location]:
            recs = restaurants[location][cuisine_type]
            return f"{location} {cuisine_type} 맛집 추천:\n" + "\n".join(
                [f"• {restaurant}" for restaurant in recs]
            )
        else:
            available = list(restaurants[location].keys())
            return f"{location}에서는 {', '.join(available)} 음식을 추천할 수 있습니다."

    return f"{location}의 맛집 정보가 없습니다."


# Tool 함수 매핑
AVAILABLE_FUNCTIONS = {
    "get_weather": get_weather,
    "calculate": calculate,
    "get_current_time": get_current_time,
    "search_news": search_news,
    "get_restaurant_recommendations": get_restaurant_recommendations,
}


async def execute_tool_call(tool_call) -> str:
    """Tool call을 실행하고 결과를 반환합니다."""
    function_name = tool_call.function.name
    function_args = json.loads(tool_call.function.arguments)

    logger.info(f"🔧 Tool 실행 시작: {function_name}")
    logger.info(f"📝 전달된 인자: {function_args}")

    if function_name in AVAILABLE_FUNCTIONS:
        function_to_call = AVAILABLE_FUNCTIONS[function_name]
        try:
            if function_name == "get_current_time":
                # get_current_time은 인자가 없음
                result = function_to_call()
            else:
                result = function_to_call(**function_args)

            logger.info(f"✅ Tool 실행 성공: {function_name}")
            logger.info(f"📊 실행 결과: {result}")
            return result
        except Exception as e:
            error_msg = f"Tool 실행 중 오류 발생: {str(e)}"
            logger.error(f"❌ Tool 실행 실패: {function_name} - {error_msg}")
            return error_msg
    else:
        error_msg = f"알 수 없는 함수: {function_name}"
        logger.error(f"❌ {error_msg}")
        return error_msg


async def stream_response(response):
    """스트리밍 응답을 처리하고 출력합니다."""
    full_content = ""
    chunk_count = 0

    async for chunk in response:
        if chunk.choices[0].delta.content:
            content = chunk.choices[0].delta.content
            print(content, end="", flush=True)
            full_content += content
            chunk_count += 1

    logger.info(f"📡 스트리밍 완료: {chunk_count}개 청크, {len(full_content)}자 응답")
    return full_content


async def chat_with_tools_streaming(
    client: AsyncOpenAI, messages: List[Dict[str, Any]]
) -> str:
    """Tool Calling을 지원하는 스트리밍 채팅 함수"""

    # 첫 번째 요청: Tool이 필요한지 확인 (non-streaming으로 tool_calls 확인)
    response = await client.chat.completions.create(
        model=MODEL_NAME,
        messages=messages,
        tools=TOOLS,
        tool_choice="auto",
        max_tokens=2048,
        temperature=0.7,
        stream=False,  # Tool calls 확인을 위해 non-streaming
    )

    response_message = response.choices[0].message

    # Tool call이 없으면 스트리밍으로 일반 응답 생성
    if not response_message.tool_calls:
        print("🤖 ", end="", flush=True)
        streaming_response = await client.chat.completions.create(
            model=MODEL_NAME,
            messages=messages,
            max_tokens=2048,
            temperature=0.7,
            stream=True,
        )
        content = await stream_response(streaming_response)
        print()  # 줄바꿈
        return content

    # Tool call이 있으면 실행
    logger.info(
        f"🔧 Tool Call 감지: {len(response_message.tool_calls)}개의 도구가 필요합니다"
    )
    logger.info(
        f"🔧 도구 사용 중: {len(response_message.tool_calls)}개의 도구를 실행합니다..."
    )

    # 원본 메시지에 어시스턴트 응답 추가
    messages.append(response_message)

    # 각 tool call 실행하고 결과 저장
    for i, tool_call in enumerate(response_message.tool_calls, 1):
        logger.info(
            f"🚀 Tool {i}/{len(response_message.tool_calls)} 실행 중: {tool_call.function.name}"
        )
        logger.info(f"   {i}. {tool_call.function.name} 실행 중...")
        function_result = await execute_tool_call(tool_call)
        logger.info("✅ 완료")
        logger.info(f"📤 Tool {i} 실행 완료: {tool_call.function.name}")

        # Tool 실행 결과를 메시지에 추가
        messages.append(
            {
                "tool_call_id": tool_call.id,
                "role": "tool",
                "name": tool_call.function.name,
                "content": function_result,
            }
        )

    logger.info("🎯 모든 Tool 실행 완료, 최종 응답 생성 중...")
    print("🤖 ", end="", flush=True)

    # Tool 실행 결과를 바탕으로 최종 응답을 스트리밍으로 생성
    final_response = await client.chat.completions.create(
        model=MODEL_NAME,
        messages=messages,
        max_tokens=2048,
        temperature=0.7,
        stream=True,
    )

    content = await stream_response(final_response)
    print()  # 줄바꿈
    return content


async def interactive_tool_calling():
    """대화형 Tool Calling 모드"""

    client = AsyncOpenAI(api_key="dummy", base_url=BASE_URL)
    logger.info("🚀 대화형 Tool Calling 모드 시작")
    logger.info(f"📡 서버: {BASE_URL}")
    logger.info(f"🤖 모델: {MODEL_NAME}")
    logger.info(f"🛠️ 사용 가능한 도구: {len(TOOLS)}개")

    logger.info("=" * 60)
    logger.info("🤖 대화형 Tool Calling 모드")
    logger.info("사용 가능한 기능:")
    logger.info("• 날씨 정보 (예: 서울 날씨 알려줘)")
    logger.info("• 계산기 (예: 123 + 456을 계산해줘)")
    logger.info("• 현재 시간 (예: 지금 몇 시야?)")
    logger.info("• 뉴스 검색 (예: AI 뉴스 찾아줘)")
    logger.info("• 맛집 추천 (예: 부산 해산물 맛집 추천해줘)")
    logger.info("• 종료하려면 'quit' 또는 'exit' 입력")
    logger.info("=" * 60)

    # 대화 히스토리 유지
    conversation_history = [
        {
            "role": "system",
            "content": """당신은 도움이 되는 AI 어시스턴트입니다.
사용자의 요청에 따라 적절한 도구를 사용하여 정확하고 유용한 정보를 제공하세요.
이전 대화 내용을 기억하고 맥락을 고려하여 답변해주세요.
항상 한국어로 친절하고 자세하게 답변해주세요.""",
        }
    ]

    conversation_count = 0

    while True:
        try:
            logger.info("사용자: ")
            user_input = read().strip()
            if user_input.lower() in ["quit", "exit", "종료", "나가기"]:
                logger.info(
                    f"👋 사용자 종료 요청. 총 {conversation_count}번의 대화 완료"
                )
                logger.info("대화를 종료합니다. 안녕히 가세요! 👋")
                break

            if not user_input:
                continue

            conversation_count += 1
            logger.info(f"💬 대화 {conversation_count}: 사용자 입력 - {user_input}")

            # 사용자 메시지 추가
            conversation_history.append({"role": "user", "content": user_input})

            # Tool calling으로 응답 생성 (스트리밍)
            logger.info(f"🎯 대화 {conversation_count}: AI 응답 생성 시작")
            result = await chat_with_tools_streaming(
                client, conversation_history.copy()
            )
            logger.info(f"✅ 대화 {conversation_count}: AI 응답 생성 완료")

            # 어시스턴트 응답을 히스토리에 추가
            conversation_history.append({"role": "assistant", "content": result})

            # 대화 히스토리가 너무 길어지면 줄이기 (시스템 메시지 + 최근 10개 메시지)
            if len(conversation_history) > 11:
                removed_count = len(conversation_history) - 11
                conversation_history = [conversation_history[0]] + conversation_history[
                    -10:
                ]
                logger.info(f"🗂️ 대화 히스토리 정리: {removed_count}개 메시지 제거")

        except KeyboardInterrupt:
            logger.info("⚠️ 사용자가 Ctrl+C로 강제 종료")
            logger.info("대화를 종료합니다. 안녕히 가세요! 👋")
            break
        except Exception as e:
            logger.error(f"❌ 대화 {conversation_count} 중 오류 발생: {str(e)}")
            logger.error(f"죄송합니다. 오류가 발생했습니다: {str(e)}")


async def main():
    logger.info(f"vLLM Tool Calling 예제 시작 - {MODEL_NAME=}")

    logger.info("🚀 vLLM + OpenAI API Tool Calling 예제")
    logger.info(f"모델: {MODEL_NAME}")
    logger.info(f"서버: {BASE_URL}")

    try:
        logger.info("🎯 대화형 모드를 시작합니다...")
        await interactive_tool_calling()

    except Exception as e:
        logger.error(f"실행 중 오류 발생: {str(e)}")
        logger.error(f"오류: {str(e)}")
        logger.error("vLLM 서버가 실행 중인지 확인해주세요:")
        logger.error("$ make serve")


if __name__ == "__main__":
    asyncio.run(main())
