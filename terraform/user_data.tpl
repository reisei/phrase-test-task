#cloud-config
users:
  - name: ansible
    groups: users,admin,wheel 
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ansible_ssh_key}
  - name: phrase_admin
    groups: users,admin,wheel
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${admin_ssh_key}
  - name: phrase_user
    groups: users
    shell: /bin/bash
    ssh_authorized_keys:
      - ${user_ssh_key}
package_update: true
package_upgrade: true
packages:
  - fail2ban
runcmd:
  - printf "[sshd]\nenabled = true\nbanaction = iptables-multiport" > /etc/fail2ban/jail.local
  - systemctl enable fail2ban
  - systemctl start fail2ban
  - sed -ie '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
  - sed -ie '/^PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
  - sed -ie '/^X11Forwarding/s/^.*$/X11Forwarding no/' /etc/ssh/sshd_config
  - sed -ie '/^#AllowTcpForwarding/s/^.*$/AllowTcpForwarding no/' /etc/ssh/sshd_config
  - sed -ie '/^#AllowAgentForwarding/s/^.*$/AllowAgentForwarding no/' /etc/ssh/sshd_config
  - sed -ie '/^#AuthorizedKeysFile/s/^.*$/AuthorizedKeysFile .ssh/authorized_keys/' /etc/ssh/sshd_config
  - systemctl restart ssh

