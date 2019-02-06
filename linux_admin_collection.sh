#################################################
# Nutzliche Hacks fuer Linux Administration
#################################################

##############################################################
# How do I find all files containing specific text on Linux?
##############################################################
find / -type f -exec grep -H 'text-to-find-here' {} \; 
# How do I find all files containing specific text on Linux recursiv from current folder?
find ./ -type f -exec grep -H 'text-to-find-here' {} \;

# For example find the "gf01sxbd416t" server name in the inventory
find /export/home/vpoliako/stash/orchestration/inventory -type f -exec grep -H 'gf01sxbd416t' {} \;
# The same but just with grep
grep -inr "gf01sxbd416t"  /export/home/vpoliako/stash/orchestration/inventory/

# How to find files in Linux using 'find'
find / -name 'zookeeper-env.sh' 2>/dev/null
find / -name 'zookeeper-env.sh' 2>errors.txt
#Note : 2>/dev/null is not related to find tool as such. 2 indicates the error stream in Linux, and /dev/null is the device where anything you send simply disappears. So 2>/dev/null in this case means that while finding for the files, in case any error messages pop up simply send them to /dev/null i.e. simply discard all error messages.
#Alternatively you could use 2>error.txt where after the search is completed you would have a file named error.txt in the current directory with all the error messages in it. 

# Delete Files Older Than x Days on Linux
find /path/to/files/ -type f -name '*.jpg' -mtime +30 -exec rm {} \;
# or
find /path/to/files/* -mtime +5 -exec rm {} \;
# or
find ./ -type f -name 'hdfs-audit.log.*' -mtime +90 -exec rm {} \;
# Explanation
# The first argument is the path to the files. This can be a path, a directory, or a wildcard as in the example above. I would recommend using the full path, and make sure that you run the command without the exec rm to make sure  you are getting the right results.
# The second argument, -type, is used to specify the type of file
# The third argument, -name, is used to specify the name of file (alternative * --> to find all files)
# The fourth  argument, -mtime, is used to specify the number of days old that the file is. If you enter +5, it will find files older than 5 days.
# The fifth argument, -exec, allows you to pass in a command such as rm. The {} \; at the end is required to end the command.



##############################################################
# Network
##############################################################
# as root execute
netstat -tnlp

##############################################################
# Ansible
##############################################################
# Syntax Check eines Playbooks
ansible-playbook confluent-kafka-cluster-install.yml --syntax-check

# Ausfuehren des Playbooks via LDAP-User inkl. Passwortabfrage fuer Ansible-Vault
ansible-playbook confluent-kafka-cluster-install.yml -i ../inv_08e_tst/inventory/all -u vpoliako -k --ask-vault-pass