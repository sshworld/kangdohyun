voice-editor를 단독으로 호출해 특정 파일의 톤을 검수한다.

## 사용 방법

```
/voice-check content/diary/2026-04-29.md
/voice-check content/essay/분냄새.md
```

## 절차

1. 지정 파일 읽기.
2. **voice-editor** 에이전트 호출.
3. 결과: 위반 좌표·이유·대안 리포트.

$ARGUMENTS
