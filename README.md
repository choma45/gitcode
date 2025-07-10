# 초기 서버 구성 
## gitcode 디렉토리는 ~/gitcode에 위치해야 합니다.
cd ~/gitcode/initial_setup/
install_ansible.sh
ansible-playbook init_setup.yml --ask-become-pass
# 현재 사용중인 IP 입력

## passwd: ansible
source ~/.bashrc 
anp setup_ansible_user.yml --ask-vault-pass
## passwd: ansible

## 초기 설정 작업이 완료되면 ~/gitcode로 돌아옵니다.