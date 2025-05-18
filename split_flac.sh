
#!/bin/bash

clear
echo "=================================="
echo "      🎧 CUE FLAC SPLITTER"
echo "=================================="
echo "1. FLAC (원본 그대로)"
echo "2. MP3 (320kbps)"
echo "3. 사용자 정의"
echo "q. 종료"
echo "----------------------------------"
read -p "옵션 선택 > " option

if [[ "$option" = "q" || "$option" = "Q" ]]; then
    echo "👋 종료합니다."
    exit 0
fi

read -p "CUE 파일 경로 입력: " cuefile
if [ ! -f "$cuefile" ]; then
    echo "❌ CUE 파일을 찾을 수 없습니다."
    exit 1
fi

dir="$(dirname "$cuefile")"
base="$(basename "$cuefile" .cue)"
flacfile="$dir/$base.flac"

if [ ! -f "$flacfile" ]; then
    echo "❌ FLAC 파일을 찾을 수 없습니다: $flacfile"
    exit 1
fi

cd "$dir" || exit 1

# FLAC 그대로 분할
if [ "$option" = "1" ]; then
    echo "[FLAC 그대로 트랙 분할 중...]"
    shnsplit -f "$cuefile" -t "%n - %t" -o flac "$flacfile"
    cuetag "$cuefile" *.flac 2>/dev/null
    echo "✅ 완료!"

# MP3 고정 품질
elif [ "$option" = "2" ]; then
    echo "[MP3 320kbps로 변환 중...]"
    shnsplit -f "$cuefile" -t "%n - %t" -o wav "$flacfile"
    for f in *.wav; do
        ffmpeg -i "$f" -ab 320k -map_metadata 0 -id3v2_version 3 "${f%.wav}.mp3"
        rm "$f"
    done
    cuetag "$cuefile" *.mp3 2>/dev/null
    echo "✅ 완료!"

# 사용자 정의
elif [ "$option" = "3" ]; then
    echo "출력 포맷을 선택하세요:"
    echo "1. MP3"
    echo "2. OGG"
    echo "3. FLAC"
    echo "4. WAV"
    read -p "번호 선택 > " fmt_option

    case "$fmt_option" in
        1)
            format="mp3"
            echo "MP3 음질 선택:"
            echo "1. 320k"
            echo "2. 192k"
            echo "3. 128k"
            read -p "선택 > " q
            case "$q" in
                1) bitrate="-ab 320k" ;;
                2) bitrate="-ab 192k" ;;
                3) bitrate="-ab 128k" ;;
                *) echo "❌ 잘못된 선택"; exit 1 ;;
            esac
            ;;
        2)
            format="ogg"
            echo "OGG 음질 선택:"
            echo "1. q10"
            echo "2. q7"
            echo "3. q5"
            read -p "선택 > " q
            case "$q" in
                1) bitrate="-qscale:a 10" ;;
                2) bitrate="-qscale:a 7" ;;
                3) bitrate="-qscale:a 5" ;;
                *) echo "❌ 잘못된 선택"; exit 1 ;;
            esac
            ;;
        3)
            format="flac"
            echo "FLAC은 무손실 포맷입니다."
            bitrate=""
            ;;
        4)
            format="wav"
            echo "WAV는 무압축 PCM입니다."
            bitrate=""
            ;;
        *)
            echo "❌ 포맷 선택 오류"; exit 1 ;;
    esac

    echo "[WAV로 트랙 분할 중...]"
    shnsplit -f "$cuefile" -t "%n - %t" -o wav "$flacfile"

    echo "[변환 중: $format $bitrate]"
    for f in *.wav; do
        outname="${f%.wav}.$format"
        if [ "$format" = "wav" ]; then
            mv "$f" "$outname"
        else
            ffmpeg -i "$f" $bitrate "$outname"
            rm "$f"
        fi
    done

    cuetag "$cuefile" *."$format" 2>/dev/null
    echo "✅ 완료!"
else
    echo "❌ 잘못된 옵션입니다."
    exit 1
fi

echo "🎉 모든 작업이 완료되었습니다!"
