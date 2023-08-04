#!/bin/bash
#V1.0
#V1.1-changed for /opt/ and root to execute
#by Brand~o

echo "Setting permissions for current directory. If this is not your intent, ctrl-c now. Otherwise,"
read -rp "Press Enter to continue..."

sudo chown -R $(whoami):0 ./ #set me as owner, root as group
#sudo chown -R $(whoami):$(whoami) ./
sudo chmod 775 ./ #set permissions for the folder we are in. Allow root group to do everything, others to read all, (execute=list for folders) @TODO-is read necessary for a folder?
sudo chmod 774 ./* #root group can do all, all can read (later take away root group permissions to write to scripts and other's ability to even read them)
sudo chmod 750 ./*.py ./*.sh #take away others ability to read scripts

#chmod u+rwx,g+rx,g-w,o-rwx ./*.py ./*.sh


echo "Done!"
