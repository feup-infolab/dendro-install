$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$prev = "$PWD"
cd $scriptPath
./define_env_vars.ps1
$VM_NAME = (get-item env:VAGRANT_VM_NAME).Value

$confirmation = Read-Host "Are you Sure You Want To DELETE the VM :"$VM_NAME"?[y/n]"

if ($confirmation -eq 'y') {
  echo "Deleting virtual machine..."

  #Because the goddamn installation does not put PATH variables where it should.
  # on win 7 it works, on windows 10... Not so lucky (as Two-face would say).
  # I <3 windows.
  $VBoxManage = """$ENV:programfiles\Oracle\VirtualBox\VBoxManage.exe"""

  cd ..
  cd ..

  vagrant halt -f "dendroVagrantDemo"
  if ($? -ne 1)
  {
  	echo "Unable to power off VM "﻿$VM_NAME
  }

  vagrant destroy -f "﻿dendroVagrantDemo"
  if ($? -ne 1)
  {
  	echo "Unable to destroy VM "﻿$VM_NAME
  }

  $cmd = "$VBoxManage controlvm $VM_NAME poweroff"
  echo "$cmd"
  CMD /C $cmd
  $cmd = "$VBoxManage unregistervm $VM_NAME -delete"
  echo "$cmd"
  CMD /C $cmd

  #clean list of VMs
  vagrant global-status --prune
}
else
{
  echo "Delete canceled. No changes made."
}

cd $prev
