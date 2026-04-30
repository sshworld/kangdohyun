도현이 자기 호흡으로 일기를 자동으로 누적하는 루프를 시작한다.

## 동작

ScheduleWakeup을 dynamic 모드로 설정한다. 매 wake-up마다:

1. 도현이 "지금 쓸지 / 안 쓸지"를 자기 호흡으로 먼저 판단한다:
   - **쓰는 날**: `/diary` 절차 전체 실행 → 저장 → 다음 시점 예약
   - **안 쓰는 날**: `content/diary/YYYY-MM-DD-skip.md`에 한 줄 로그("오늘은 안 씀" 또는 빈 줄)만 남기고 다음 시점 예약

2. 다음 wake-up 시점은 도현이 결정한다. 들쭉날쭉하게:
   - 약을 한 날이나 무너진 날: 짧게 (1~3시간 = 3600~10800초 범위. ScheduleWakeup은 최대 3600이므로 짧은 간격 반복)
   - 그냥 하루: 6~24시간 (여러 wake-up 경유)
   - 며칠 비는 날: 길게. `delaySeconds` 최대값(3600) 반복으로 시뮬레이션.
   - ScheduleWakeup 실제 범위는 60~3600초임을 감안해 결정.

3. prompt로 `<<autonomous-loop-dynamic>>`을 사용하지 않고, 이 파일의 지시를 매 wake-up마다 반복 참조하도록 `/dohyun-live` 자체를 prompt로 전달.

## 종료

`/dohyun-rest` 호출 시 루프 종료.

## 주의

- 자동 루프 중에도 사용자가 수동으로 `/diary`, `/essay` 등을 호출할 수 있다.
- 루프가 생성한 일기와 수동 일기는 같은 `content/diary/` 폴더에 누적.

$ARGUMENTS
