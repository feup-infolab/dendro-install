ssh > $null
if ($? -eq 1)
{
	echo "SSH is not installed in this system! Download the GIT installer (https://git-scm.com/download/win), for example, which contains the ssh executable, and add it to your PATH variable before running this script again."
	exit 1
}

# define vagrant environment variables
./scripts/define_env_vars.ps1

#set installation flag for Vagrantfile

$ENV:VAGRANT_VM_INSTALL="false"
cd ..
vagrant ssh
