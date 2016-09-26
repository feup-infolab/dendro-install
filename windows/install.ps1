param (
    #[string]$price = 100, 
    #[string]$ComputerName = $env:computername,    
    #[string]$username = $(throw "-username is required."),
    #[string]$password = $( Read-Host -asSecureString "Input password" ),
    [switch]$refresh = $false
)

#function to zip a directory into a target zip folder
function ZipFiles( $zipfilename, $sourcedir )
{
    Add-Type -Assembly System.IO.Compression.FileSystem
    $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
    [System.IO.Compression.ZipFile]::CreateFromDirectory(
        $sourcedir,
        $zipfilename, 
        $compressionLevel, 
        $true);
}

# define vagrant environment variables
./scripts/define_env_vars.ps1

# read shell arguments to pass to vagrant script
    $VAGRANT_SHELL_ARGS=''

    if ($refresh -eq $true) {
	    $VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS + '-r '
	    echo "Performing a code refresh only"
    }
    else {
	    if(!$refresh) {
		    echo "Performing a full installation"
	    }
	    else
	    {
		    echo "Unrecognized option: $refresh"
	    }
    }

    $ENV:VAGRANT_SHELL_ARGS = $VAGRANT_SHELL_ARGS

#scripts zip file
    $targetZipFile = (get-item $PWD).Parent.FullName + "\scripts.zip";

#source scripts folder
    $sourceScriptsFolder = (get-item $PWD).Parent.FullName + "\scripts";

# delete existing scripts zip if exists
if([System.IO.File]::Exists($targetZipFile)){
    del $targetZipFile
}

#zip scripts folder
ZipFiles $targetZipFile $sourceScriptsFolder;

echo "Booting up machine " $ENV:VAGRANT_VM_NAME
     " with IP " + $ENV:VAGRANT_VM_IP 
     " and arguments " + $ENV:VAGRANT_SHELL_ARGS;

exit 1;

# vagrant box update &&
vagrant up --provider virtualbox --provision
if ($? -ne 1)
{
	echo "Unable to bring vagrant VM up"
	exit 1
}

echo "Cleaning up..."
del $targetZipFile
echo "Deleted temporary scripts package."

echo "Dendro setup complete."

# clean list of VMs
vagrant global-status --prune
