sudo apt-get install nfs-kernel-server
sudo mkdir -p /srv/data
if ! grep /srv/data /etc/exports ; then
	sudo echo '/srv/data 	*(rw,sec=sys,sync,no_root_squash,no_subtree_check)' >> /etc/exports
fi
sudo service nfs-kernel-server restart
