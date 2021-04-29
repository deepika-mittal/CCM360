param (
	#[parameter(Mandatory=$true)]
    [string[]]$env = $(throw "-env is required.")
	
)

ECHO " "
ECHO " "

Write-Host "Num Args:" $env.Length;
foreach ($arg in $env)
{
  Write-Host "Arg: $arg";
}

  if($env -ne 'dev' -AND $env -ne 'test' -AND $env -ne 'prod')
  {
  	ECHO "INCORRECT PARAMETER PASSED, it has to be either DEV(dev), TEST(test), or PROD(prod)";
        EXIT
  }

  
 if($env -eq 'dev')
 {

 	$StreamServer="\\dca-dev1173"

# set folder path
	$filesrv_path="C:\CCM\Invoices\ccm_postal_reports\" 

# set min age of files
	$max_days = "-1"
	$max_days_rdi = "-1"


 }
 elseif($env -eq 'test')
 {

 	$StreamServer="\\dca-acc1177"

# set folder path
	$filesrv_path="C:\CCM\Invoices\ccm_postal_reports\"

# set min age of files
	$max_days = "-2"
	$max_days_rdi = "-2"

 }
 elseif($env -eq 'prod')
 {

	$StreamServer="\\dca-pro1177"

# set folder path
	$filesrv_path="C:\CCM\Invoices\ccm_postal_reports\"

# set min age of files
	$max_days = "-14"
	$max_days_rdi = "-30"

 }
 else 
 {

 	$StreamServer=NULL

# set folder path
	$filesrv_path=NULL

 }

# get the current date
$curr_date = Get-Date


# Folder Paths on File Server	
	$zbat_inv="opt\streamserve\in\zbat_inv\save\"	
	$zbat_corr="opt\streamserve\in\zbat_corr\save\"
	$dir_bill="opt\streamserve\in\dir_ebill\save\"
	$pof_save="opt\streamserve\in\pof\save\"
	$zpdf_inv="opt\streamserve\in\zpdf_inv\save\"

# Actual Path on File Server
	$inv="$StreamServer\$zbat_inv"
	$corr="$StreamServer\$zbat_corr"
	$bill="$StreamServer\$dir_bill"
	$pof="$StreamServer\$pof_save"
	$pdf="$StreamServer\$zpdf_inv"


ECHO "======================================================================"
ECHO $("Batch Run           : " + $curr_date)
ECHO " "
ECHO $("File Server         : " + $StreamServer)
ECHO " "
ECHO "======================================================================"

#ECHO $("File Server Path(s) : " + $filesrv_path)
ECHO $("File Server Path(s) : " + $inv)
ECHO $("                      " + $corr)
ECHO $("                      " + $bill)
ECHO $("                      " + $pof)
ECHO $("                      " + $pdf)

ECHO "======================================================================"


# determine how far back we go based on current date
$del_date 	= $curr_date.AddDays($max_days)
$del_date_rdi 	= $curr_date.AddDays($max_days_rdi)


ECHO " "
ECHO $("Deletion to date     : " + $del_date)
ECHO " "
ECHO "======================================================================"
ECHO " "
ECHO "Deletion Started ......";
ECHO " "

$Del_st= "Started deletion for :"
$Del_end="Ended deletion for   :"

# Deletion for Local file for Testing
#ECHO $($Del_st + $filesrv_path)

# delete the files
#  Get-ChildItem $filesrv_path -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
#  Get-ChildItem -Path $filesrv_path -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse #-Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

#ECHO $($Del_end + $filesrv_path)
#ECHO " "

#Deletion for Invoice Folder 
ECHO $($Del_st + $inv)

# delete the files
  Get-ChildItem $inv -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date_rdi } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $inv -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $inv)
ECHO " "

#Deletion for Corr Folder 
ECHO $($Del_st + $corr)

# delete the files
  Get-ChildItem $corr -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $corr -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $corr)
ECHO " "

#Deletion for Bill Folder 
ECHO $($Del_st + $bill)

# delete the files
  Get-ChildItem $bill -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $bill -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $bill)
ECHO " "

#Deletion for POF Folder 
ECHO $($Del_st + $pof)

# delete the files
  Get-ChildItem $pof -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $pof -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $pof)
ECHO " "

#Deletion for PDF Folder 
ECHO $($Del_st + $pdf)

# delete the files
  Get-ChildItem $pdf -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $pdf -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $pdf)
ECHO " "

ECHO "Deleted Successfully !"
ECHO " "