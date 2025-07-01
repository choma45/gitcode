#!/bin/bash

Scripts_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "==== Ansible 컨트롤러 초기 설정 시작 ===="

# 실행권한 확인
if [[ $(id -u) -ne 0 ]]; then 
    echo -e "이 스크립트는 sudo 권한으로 실행되어야 합니다. \n# sudo ~/gitcode/initial_setup/setup_controller_initial.sh"
    exit 1
fi

# 컨트롤러(자신) 정보
Target_Hostname="ansible"
Controller_IP="192.168.30.11"
Controller_Entry="${Controller_IP} ${Target_Hostname}"

# 대상 호스트 목록 
Hosts_to_manage="$Scripts_dir/config_files/hosts_to_manage.txt"
# 시스템 호스트 파일 경로
Hosts_File="/etc/hosts"
# 함수 파일 로드
. "$Scripts_dir/functions/host_paser.sh"

# 1. 192.168.30.11 --> hostname = ansible
echo "1. 컨트롤러의 호스트네임을 ${Target_Hostname}로 변경합니다."
hostnamectl set-hostname "${Target_Hostname}" 
echo "호스트네임 변경 완료. 변경사항은 재부팅/재접속 후 적용됩니다."
echo "현재 호스트네임:  $(hostname)"
echo ""

# /etc/hosts 파일 수정
echo "2. /etc/hosts 파일을 수정합니다."

# Controller_Entry 추가
if ! grep -q "^${Controller_Entry}$" "$Hosts_File"; then
    echo "$Controller_Entry" >> "$Hosts_File"
    echo "-> '$Controller_Entry' 추가 완료."
else
    echo "--> '$Controller_Entry'는 이미 '$Hosts_File'에 존재합니다."
fi

# 대상 호스트_Entry 추가
if [ ! -f "$Hosts_to_manage" ]; then 
    echo "대상 호스트 목록이 존재하지 않습니다."
    exit 1
fi  

echo "==== 대상 호스트 목록 추가 ===="
while IFS= read -r Line || [[ -n "$Line" ]]; do
    parse_and_get_host_info "$Line"
    Parse_Status=$?

    if [[ $Parse_Status -ne 0 ]]; then 
        continue 
    fi 

    # 대상 엔트리가 /etc/hosts에 존재하지 않는 경우에만 추가
    if ! grep -q "^${Parsed_IP} ${Parsed_Hostname}" "$Hosts_File"; then 
        echo "${Parsed_IP} ${Parsed_Hostname}" >> "$Hosts_File"
        echo "${Parsed_IP} ${Parsed_Hostname} 추가 완료."
    else   
        echo "대상 호스트가 이미 존재합니다."
    fi 
done < "$Hosts_to_manage"

# 수정된 파일 확인
echo "==== 수정사항 확인 ===="
cat "$Hosts_File" | tail -n 10
echo "" 

# SSH 키 생성 및 배포 
sudo "$Scripts_dir/scripts/distribute_ssh_key.sh"

echo "==== Ansible 컨트롤러 초기 설정 완료 ===="
echo "변경사항을 적용하려면 재접속/재부팅이 필요할 수 있습니다."
