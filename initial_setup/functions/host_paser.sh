# ~/gitcode/functions/host_parser_function.sh

# ==============================================================================
# 헬퍼 함수: 호스트 엔트리 파싱 및 유효성 검사
# 인자: 호스트 엔트리 한 줄 ($1)
# 전역 변수 설정: ParsedIp, ParsedHostname
# 반환 코드: 0 (성공), 1 (빈 줄 또는 주석), 2 (파싱 오류)
# ==============================================================================

# 대상 호스트 엔트리 파싱 및 유효성 검사
parse_and_get_host_info(){
    local Current_Line="%1"
    Parsed_IP=""
    Parsed_Hostname=""

    # 앞뒤 공백 제거
    Current_Line=$(echo "$Current_Line" | xargs)

    # 빈칸 또는 주석은 건너뜀 
    if [[ -z "$Current_Line" || "$Current_Line" =~ ^# ]]; then
        return 1 
    fi 

    # IP, Hostname 파싱 
    Parsed_IP=$(echo "$Current_Line" | awk '{print $1}')
    Parsed_Hostname=$(echo "$Current_Line" | awk '{print $2}')

    # 파싱된 값 유효성 확인
    if [[ -z "$Parsed_IP" || -z "$Parsed_Hostname" ]]; then 
        echo "형식이 올바르지 않습니다"
        return 2
    fi 

    return 0
}
