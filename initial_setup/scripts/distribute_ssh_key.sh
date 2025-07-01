#!/bin/bash

Scripts_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. &> /dev/null && pwd )"

# ~/gitcode/initial_setup/scripts/distribute_ssh_keys.sh

# 현재 스크립트의 실행 권한 확인 (root 권한이 필요할 수 있습니다)
if [[ $(id -u) -ne 0 ]]; then
    echo "이 스크립트는 sudo 권한으로 실행되어야 합니다. (예: sudo ./distribute_ssh_keys.sh)"
    exit 1
fi

# 대상 호스트 목록 파일 경로 (메인 스크립트와 동일하게 정의)
Hosts_to_manage="$Scripts_dir/config_files/hosts_to_manage.txt"
# 함수 파일 로드 (함수를 사용하기 위해 source 합니다)
. "$Scripts_dir/functions/host_parser.sh"

echo "4. 생성된 공개키를 각 서버의 root 사용자에게 복사합니다."
echo "--- 중요: 이 단계에서 각 대상 서버의 'root' 비밀번호를 입력해야 합니다! ---"
echo ""

# 대상 호스트 목록 파일이 존재하는지 확인
if [ ! -f "$Hosts_to_manage" ]; then
    echo "오류: 대상 호스트 목록 파일 '$Hosts_to_manage'을 찾을 수 없습니다."
    echo "SSH 키 배포를 계속할 수 없습니다."
    exit 1
fi

# Hosts_to_manage 파일에서 대상 서버 목록을 다시 읽어와 SSH 키 복사 작업 수행
while IFS= read -r Line || [[ -n "$Line" ]]; do
    parse_and_get_host_info "$Line" # 헬퍼 함수 사용
    local Parse_Status=$? # 함수의 반환 코드 캡처

    if [[ $Parse_Status -ne 0 ]]; then # 파싱 실패(1 또는 2)인 경우 건너뜁니다.
        continue
    fi

    # 함수에서 설정된 전역 변수 (ParsedIp, ParsedHostname)를 사용합니다.
    read -p "호스트 '${Parsed_Hostname}' (${Parsed_IP})의 'root' 사용자에게 SSH 키를 복사하시겠습니까? (y/n): " ConfirmCopy
    if [[ "$ConfirmCopy" == "y" || "$ConfirmCopy" == "Y" ]]; then
        echo "호스트 '${Parsed_Hostname}' (${Parsed_IP})의 'root' 사용자로 키 복사를 시도합니다..."
        ssh-copy-id root@"${Parsed_IP}"
        if [ $? -eq 0 ]; then
            echo "호스트 '${Parsed_Hostname}'에 공개 키 복사 성공!"
        else
            echo "오류: 호스트 '${Parsed_Hostname}'에 공개 키 복사 실패. 비밀번호를 확인하거나, ssh-copy-id가 설치되었는지 확인하세요."
        fi
    else
        echo "호스트 '${Parsed_Hostname}'에 키 복사를 건너뜁니다."
    fi
    echo ""
done < "$Hosts_to_manage"

echo "SSH 키 배포 작업 완료."