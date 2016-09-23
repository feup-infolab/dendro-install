# read shell arguments to pass to vagrant script
set SHELL_ARGS=''

echo "First parameter: " $p1

if ($p1 -eq "-r") {
	echo "Refreshing code"; 
	set VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS;'-r '
}
else {
	if(($p1 -ne $null)) {
		echo Unrecognized parameter supplied.
		exit 1
	}
}

$name = Read-Host 'What is your username?'read $1

# set constants
./scripts/constants.ps1

# compress scripts folder
del -rf scripts.zip
function ZipFiles( $zipfilename, $sourcedir )
{
   Add-Type -Assembly System.IO.Compression.FileSystem
   $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
   [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,
        $zipfilename, $compressionLevel, $false)
}

ZipFiles './scripts.zip' './scripts'
	
# define vagrant environment variables
./define_env_vars.ps1

# vagrant box update &&
vagrant up --provider virtualbox --provision
if ($? -ne 1)
{
	echo "Unable to bring vagrant VM up"
	exit 1
} 

echo "Cleaning up..."
del ./scripts.zip
echo "Deleted temporary scripts package."

echo "Dendro setup complete."

# clean list of VMs
vagrant global-status --prune
