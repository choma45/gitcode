# 초기 서버 구성 
## gitcode 디렉토리는 ~/gitcode에 위치해야 합니다.
cd ~/gitcode/initial_setup/
install_ansible.sh
ansible-playbook init_setup.yml --ask-become-pass
## passwd: ansible
source ~/.bashrc 
anp setup_ansible_user.yml --ask-vault-pass
## passwd: ansible

