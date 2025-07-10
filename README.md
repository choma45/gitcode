# gitcode 디렉토리는 ~/gitcode에 위치해야 합니다.

# 초기 서버 구성 
# 호스트 서버는 .10 대상서버는 .20, .30 ip를 사용해야 합니다.
# (예: ansible: 192.168.30.10 | ansible1: 192.168.30.20. ansible2: 192.168.30.30)
# 호스트 서버의 ansible 사용자로 실행되어야 합니다.

## 1. 호스트 서버에 초기 설정 작업을 진행합니다. 
### ansible, epel-release 설치 작업을 수행합니다.
cd ~/gitcode/initial_setup/
install_ansible.sh

### 호스트 서버가 현재 사용중인 PC의 IP대역을 바탕으로 기본 설정파일을 작성합니다.
## 작동순서
# 1) 호스트 서버의 ansible 사용자를 wheel 그룹에 추가하고 NOPASSWD 권한을 부여합니다.
# 2) bash 설정과 vi 편집기에 대한 설정을 복사합니다.
# 3) /etc/hosts 파일에 호스트 서버와 관리대상 서버 추가합니다.
# 4) 호스트서버의 ssh 키를 생성합니다.
### 초기 비밀번호는 ansible 입니다.
### 사용할 호스트서버의 IP를 입력받습니다. 
ansible-playbook init_setup.yml --ask-become-pass

### 변경된 bashrc 설정을 적용합니다.
source ~/.bashrc 

## 2. 관리 대상 서버에 대한 설정 작업을 진행합니다.
# 1) 관리 대상 서버에 ansible 유저를 추가합니다. (필요 시 수행 됨)
# 2) 각 서버의 root 사용자에게 공개키를 복사합니다.
# 3) 각 서버의 ansible 사용자에게 공개키를 복사합니다.
# 4) 각 서버의 wheel 그룹에게 NOPASSWD 권한을 부여합니다.
# 5) 각 서버의 /etc/hosts 파일에 호스트 서버의 /etc/hosts 파일을 복사합니다.
# 6) "nameserver 8.8.8.8"을 네임서버에 추가합니다.
# 7) 각 서버에 python을 설치하고 확인합니다. 
anp setup_ansible_user.yml --ask-vault-pass
### passwd: ansible

## 초기 설정 작업이 완료되면 ~/gitcode로 돌아옵니다.