param (
	#[parameter(Mandatory=$true)]
    [string[]]$env = $(throw "-env is required.")
)

Write-Host "Num Args:" $env.Length;
foreach ($arg in $env)
{
  Write-Host "Arg: $arg";
}

  if($env -ne 'dev' -AND $env -ne 'test' -AND $env -ne 'prod'){
  echo "INCORRECT PARAMETER PASSED, it has to be either DEV(dev), TEST(test), or PROD(prod)";
  EXIT
  }
  
 if($env -eq 'dev'){
 $DSServer="\\dca-dev1121"
 $StreamServer="\\dca-dev1173"
 }
 elseif($env -eq 'test'){
 $DSServer="\\dca-acc1122"
 $StreamServer="\\dca-acc1177"
 }
 elseif($env -eq 'prod'){
 $DSServer="\\dca-pro1221"
 $StreamServer="\\dca-pro1177"
 }
 else {
 $StreamServer=NULL
 $DSRepository=NULL
 }
 
ECHO $("StreamServe Box : " + $StreamServer)
$BillsAFPOutputPath="\E$\opt\streamserve\out\afp\invoices\bills"
ECHO $("AFP Output Path on StreamServer Box : " + $BillsAFPOutputPath)
$BillsBKUPPath="E:\opt\ccmbatch\invoices\bkup\afp"
ECHO $("CCM Bills Backup Path on StreamServer Box : " + $BillsBKUPPath)
  
Function BILLS_AFP_FTP 
# This is a function that runs the ftp job that send the bills to Print Centre and back them up. 
{ 
$Today = (Get-Date)
Write-Host $Today
$TimeStamp=$Today.Month.ToString() + '_' + $Today.Day + '_' + $Today.Year + '_' + $Today.Hour + '_' + $Today.Minute + '_' + $Today.Second
Write-Host $TimeStamp


#  $FileName = gci D:\opt\streamserve\out\afp\invoices\bills\*.afp | % {$_.BaseName}|sort laswriteitem|select -first 1
#  echo "FileName : "$FileName

  $FullFileName = gci E:\opt\streamserve\out\afp\invoices\bills\*.afp | % {$_.Name}|sort laswriteitem|select -first 1
  echo ''
  echo "FullFileName : $FullFileName"
  echo ''

  if($FullFileName -match 'inv_sho'){
  echo "Sending SHUTT File to PGP Server"
  scpg3 E:\opt\streamserve\out\afp\invoices\bills\$FullFileName ddatbat@pgp.dteco.com:/opt/ddatbat/batch/data/outbound
  echo "Sending SHUTT File to PGP Server Finished"
  }
  
  echo "Sending File to Prisma"
  scpg3 E:\opt\streamserve\out\afp\invoices\bills\$FullFileName streamserve@162.9.19.111:/u/home/streamserve_bkup
  echo "Sending File to Prisma Finished, copying file to the main folder"
  #echo ssh2 streamserve@162.9.19.111 cp /u/home/streamserve_bkup/$FullFileName /u/home/streamserve/
  #ssh2 streamserve@162.9.19.111 cp /u/home/streamserve_bkup/$FullFileName /u/home/streamserve_bkup/"TESTING_"+$FullFileName
  scpg3 E:\opt\streamserve\out\afp\invoices\bills\$FullFileName streamserve@162.9.19.111:/u/home/streamserve


$Folder = $FullFileName.substring(0,8)
ECHO "BATCH DATE: $Folder"

$PSOutputPath=$DSServer+"\CCM\invoices\ccm_postal_reports\$Folder"
if (Test-Path $PSOutputPath) { 
echo "Folder Exist for this Batch Date"
Copy-Item E:\opt\streamserve\out\afp\invoices\bills\$FullFileName $PSOutputPath -Force
Move-Item E:\opt\streamserve\out\afp\invoices\bills\$FullFileName $BillsBKUPPath -Force
}
else {
New-Item $DSServer\CCM\invoices\ccm_postal_reports\$Folder -type directory
Copy-Item E:\opt\streamserve\out\afp\invoices\bills\$FullFileName $PSOutputPath -Force
Move-Item E:\opt\streamserve\out\afp\invoices\bills\$FullFileName $BillsBKUPPath -Force 
}


 #########################

Get-ChildItem -Path  "E:\opt\ccmbatch\invoices\bkup\afp" -Recurse -Force| Where-Object CreationTime -lt (Get-Date).AddDays(-15) | Remove-Item -Recurse -Force

}

$ENDFileName="E:\opt\streamserve\out\afp\invoices\bills\process.done"
Do {
Move-Item E:\opt\streamserve\out\afp\correspondences\cla\*.afp E:\opt\streamserve\out\afp\invoices\bills -Force
Move-Item E:\opt\streamserve\out\afp\correspondences\hpp\*.afp E:\opt\streamserve\out\afp\invoices\bills -Force
Move-Item E:\opt\streamserve\out\afp\correspondences\pc\*.afp E:\opt\streamserve\out\afp\invoices\bills -Force

If (Test-Path 'E:\opt\streamserve\out\afp\invoices\bills\*.afp'){
 write-host "New afp file exist, doing the ftp process"
 BILLS_AFP_FTP
}Else{
  write-host "afp file does not Exist"
#  write-host "Waiting for new afp file to arrive, Sleeping for 600 Seconds @" $(Get-Date)
#  Start-Sleep -s 600
}
} While (Test-Path 'E:\opt\streamserve\out\afp\invoices\bills\*.afp')


write-host "FTP Done. Exiting program"
