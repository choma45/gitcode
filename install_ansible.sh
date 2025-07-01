#!/bin/bash 

# ansible 설치 작업
echo "Ansible 설치를 시작합니다."


# epel-release 설치 
echo "1. EPEL 저장소 설치"
sudo dnf install -y epel-release

# ansible 설치 
echo "2. Ansible 설치"
sudo dnf install -y ansible 

# 설치 확인 
if command -v ansible &> /dev/null; then
    echo "Ansible이 성공적으로 설치되었습니다."
    ansible --version
else 
    echo "Ansible이 설치되지 않았습니다."
    exit 1
fi
