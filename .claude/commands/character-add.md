새 인물을 world/characters.md와 world/relations.md에 등록한다.
character-keeper의 제안을 확정하거나, 직접 메모를 써서 등록할 때 사용.

## 사용 방법

```
/character-add 신림에서 만난 형. 도현보다 4살 위. 인력시장 소개해줌. '긴 손 형'으로 부름.
/character-add character-keeper 제안 확정 — 2026-04-29.review.md 참조
```

## 절차

1. `world-keeper` 스킬 로드.
2. **character-keeper** 에이전트 호출.
3. 입력 메모 기반으로:
   - `world/characters.md`에 새 항목 추가
   - `world/relations.md` mermaid 그래프에 노드·연결선 추가
4. 갱신 내용 확인 출력.

## 규칙

- 자음 단독 호칭 금지: `ㄱ누나` → `수경 누나` 또는 `그 누나`
- 도현이 아는 것만 적는다. 본명·나이는 도현이 모르면 빈칸.

$ARGUMENTS
