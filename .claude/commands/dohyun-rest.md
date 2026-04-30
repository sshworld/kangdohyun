자동 일기 루프를 종료한다.

## 동작

현재 실행 중인 dohyun-live 루프를 다음 wake-up에서 종료한다.

ScheduleWakeup을 다시 호출하지 않아 루프가 자연스럽게 끝난다.

종료 후 마지막 로그 한 줄을 `content/diary/YYYY-MM-DD-rest.md`에 남긴다:
```
루프 종료. 쉰다.
```

$ARGUMENTS
