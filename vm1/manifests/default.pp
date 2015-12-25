# ready for ceph installation
  exec { 'ready ceph':
    command => '/bin/echo Ready for Ceph-deploy',
    onlyif => [
      "/usr/bin/apt-get update && /usr/bin/apt-get install ntp openssh-server -y"
    ]
  }

  # add ceph-user for installation
  exec { 'Add user':
    command => '/bin/echo add management user OK',
    onlyif => [
      "/usr/sbin/useradd -d /home/ceph-user -m ceph-user",
      "/bin/echo ceph-user:1234 | chpasswd",
      "/bin/echo \"ceph-user ALL = (root) NOPASSWD:ALL\" | sudo tee /etc/sudoers.d/ceph-user",
      "/bin/chmod 0440 /etc/sudoers.d/ceph-user"
    ]
  }
