# cue2flac# 🎧 CUE/FLAC 트랙 분할 및 포맷 변환 스크립트

이 쉘 스크립트는 `.cue`와 `.flac` 파일을 기반으로 트랙을 분할하고, 다양한 포맷으로 변환하는 **올인원 도구**입니다.  
음악 파일 관리를 효율적으로 하고 싶은 오디오 애호가, 리핑 마니아, DJ를 위한 필수 도구입니다.

---

## 📦 주요 기능

- ✅ 다중 CUE 파일 탐색 및 선택 메뉴
- ✅ CUE 파일 인코딩 자동 감지 및 UTF-8 변환
- ✅ FLAC 존재 여부 자동 확인
- ✅ `shnsplit` 이용한 트랙 분할 (`WAV`)
- ✅ 사용자 정의 가능한 변환 옵션
  - FLAC
  - MP3 (320k, 192k, 128k)
  - OGG (q10, q7, q5)
  - WAV
- ✅ 출력 디렉토리 자동 분리 (예: `앨범명_mp3`)
- ✅ 변환 후 자동 태그 삽입 (`cuetag`)
- ✅ 공백 및 특수문자 완전 대응
- ✅ 잘못된 입력에 대한 반복 처리 (안정성 ↑)
- ✅ WAV 찌꺼기 자동 정리

---

## 🔧 필요한 패키지 (Debian/Ubuntu 기준)

```bash
sudo apt install cuetools shntool ffmpeg vorbis-tools flac
