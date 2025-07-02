# Initial server-setup
1. Ansible 설치 스크립트 실행 
# ./install_ansible.sh

2. 초기설정 플레이북 실행
# ansible 사용자에 대해 권한 상승이 이루어지지 않았으므로 
# --ask-become-pass 옵션 사용
# pass: ansible

# cd ~/gitcode/initial_setup
# ansible-playbook init_setup.yml --ask-become-pass

3. 관리대상 초기 설정
# cd ~/gitcode/setup_ansible_user
# anp setup_ansible_user.yml --ask-vault-pass #( 초기 vault-pass: ansible )

