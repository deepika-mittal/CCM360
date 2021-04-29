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

	$AppServer1="\\dca-dev1170"
	$AppServer2="\\dca-dev1171"
	$AppServer3="\\dca-dev1172"
	$AppServer4="\\dca-dev1405"
	$AppServer5="\\dca-dev1406"

# set folder path
	$filesrv_path="C:\CCM\Invoices\ccm_postal_reports\" 

	$inv_bat="D:\ManagementGateway\5.6.2\root\applications\StreamServeInvoicesBatch\dev\logs\"
	$inv_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeInvoicesRT\dev\logs\"
	$corr_bat="D:\ManagementGateway\5.6.2\root\applications\StreamServeCorrespondencesBatch\dev\logs\"	
	$corr_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeCorrespondencesRT\dev\logs\"
	$ebill="D:\ManagementGateway\5.6.2\root\applications\StreamServeEbill\dev\logs\"
	$ebill_eml="D:\ManagementGateway\5.6.2\root\applications\StreamServeEbillEmail\dev\logs\"
	$pp_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServePostProcessorBatch\dev\logs\"
	$rep_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServeReportingBatch\dev\logs\"
	$gate_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeServiceGatewayRT\dev\logs\"
	$ts_sch="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskScheduler\dev\logs\"
	$ts_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerBatch\dev\logs\"
	$sch_ebill="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerEbill\dev\logs\"
	$sch_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerRT\dev\logs\"
	$tmp="D:\opt\tmp\"


# set min age of files
	$max_days = "-1"

 }
 elseif($env -eq 'test')
 {
	$AppServer1="\\dca-acc1170"
	$AppServer2="\\dca-acc1171"
	$AppServer3="\\dca-acc1172"
	$AppServer4="\\dca-acc1173"
	$AppServer5="\\dca-acc1174"

# set folder path
	$filesrv_path="C:\CCM\Invoices\ccm_postal_reports\" 

	$inv_bat="D:\ManagementGateway\5.6.2\root\applications\StreamServeInvoicesBatch\qa\logs\"
	$inv_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeInvoicesRT\qa\logs\"
	$corr_bat="D:\ManagementGateway\5.6.2\root\applications\StreamServeCorrespondencesBatch\qa\logs\"	
	$corr_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeCorrespondencesRT\qa\logs\"
	$ebill="D:\ManagementGateway\5.6.2\root\applications\StreamServeEbill\qa\logs\"
	$ebill_eml="D:\ManagementGateway\5.6.2\root\applications\StreamServeEbillEmail\qa\logs\"
	$pp_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServePostProcessorBatch\qa\logs\"
	$rep_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServeReportingBatch\qa\logs\"
	$gate_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeServiceGatewayRT\qa\logs\"
	$ts_sch="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskScheduler\qa\logs\"
	$ts_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerBatch\qa\logs\"
	$sch_ebill="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerEbill\qa\logs\"
	$sch_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerRT\qa\logs\"
	$tmp="D:\opt\tmp\"

# set min age of files
	$max_days = "-2"

 }
 elseif($env -eq 'prod')
 {
	$AppServer1="\\dca-pro1171"
	$AppServer2="\\dca-pro1172"
	$AppServer3="\\dca-pro1173"
	$AppServer4="\\dca-pro1174"
	$AppServer5="\\dca-pro1275"

# set folder path
	$filesrv_path="C:\CCM\Invoices\ccm_postal_reports\" 

	$inv_bat="D:\ManagementGateway\5.6.2\root\applications\StreamServeInvoicesBatch\prod\logs\"
	$inv_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeInvoicesRT\prod\logs\"
	$corr_bat="D:\ManagementGateway\5.6.2\root\applications\StreamServeCorrespondencesBatch\prod\logs\"	
	$corr_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeCorrespondencesRT\prod\logs\"
	$ebill="D:\ManagementGateway\5.6.2\root\applications\StreamServeEbill\prod\logs\"
	$ebill_eml="D:\ManagementGateway\5.6.2\root\applications\StreamServeEbillEmail\prod\logs\"
	$pp_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServePostProcessorBatch\prod\logs\"
	$rep_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServeReportingBatch\prod\logs\"
	$gate_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeServiceGatewayRT\prod\logs\"
	$ts_sch="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskScheduler\prod\logs\"
	$ts_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerBatch\prod\logs\"
	$sch_ebill="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerEbill\prod\logs\"
	$sch_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerRT\prod\logs\"
	$tmp="D:\opt\tmp\"

# set min age of files
	$max_days = "-7"

 }
 else 
 {

	$AppServer1=NULL
	$AppServer2=NULL
	$AppServer3=NULL
	$AppServer4=NULL
	$AppServer5=NULL

# set folder path
	$filesrv_path=NULL
	$inv_bat=NULL
	$inv_rt=NULL
	$corr_bat=NULL	
	$corr_rt=NULL
	$ebill=NULL
	$ebill_eml=NULL
	$pp_batch=NULL
	$rep_batch=NULL
	$gate_rt=NULL
	$ts_sch=NULL
	$ts_batch=NULL
	$sch_ebill=NULL
	$sch_rt=NULL
	$tmp=NULL

 }

# get the current date
$curr_date = Get-Date


# Folder Paths on File Server	
#	$zbat_inv="opt\streamserve\in\zbat_inv\save\"	
#	$zbat_corr="opt\streamserve\in\zbat_corr\save\"
#	$dir_bill="opt\streamserve\in\dir_ebill\save\"
#	$pof_save="opt\streamserve\in\pof\save\"
#	$zpdf_inv="opt\streamserve\in\zpdf_inv\save\"

# Actual Path on File Server
#	$inv_bat="D:\ManagementGateway\5.6.2\root\applications\StreamServeInvoicesBatch\prod\logs\"
#	$inv_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeInvoicesRT\prod\logs"
#	$corr_bat="D:\ManagementGateway\5.6.2\root\applications\StreamServeCorrespondencesBatch\prod\logs"	
#	$corr_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeCorrespondencesRT\prod\logs"
#	$ebill="D:\ManagementGateway\5.6.2\root\applications\StreamServeEbill\prod\logs"
#	$ebill_eml="D:\ManagementGateway\5.6.2\root\applications\StreamServeEbillEmail\prod\logs"
#	$pp_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServePostProcessorBatch\prod\logs"
#	$rep_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServeReportingBatch\prod\logs"
#	$gate_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeServiceGatewayRT\prod\logs"
#	$ts_sch="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskScheduler\prod\logs"
#	$ts_batch="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerBatch\prod\logs"
#	$sch_ebill="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerEbill\prod\logs"
#	$sch_rt="D:\ManagementGateway\5.6.2\root\applications\StreamServeTaskSchedulerRT\prod\logs"


ECHO "======================================================================"
ECHO $("Batch Run           : " + $curr_date)

ECHO " "

ECHO $("Application Server(s)   : " + $AppServer1 )
ECHO $("                          " + $AppServer2 )
ECHO $("                          " + $AppServer3 )
ECHO $("                          " + $AppServer4 )
ECHO $("                          " + $AppServer5 )

ECHO " "
ECHO "======================================================================"

#ECHO $("Application Server Path(s) : " + $filesrv_path)
ECHO " "
#ECHO $("Application Server Path(s) : " + $filesrv_path)
ECHO $("Application Server Path(s) : " + $inv_bat)
ECHO $("                             " + $inv_rt)
ECHO $("                             " + $corr_bat)
ECHO $("                             " + $corr_rt)
ECHO $("                             " + $ebill)
ECHO $("                             " + $ebill_eml)
ECHO $("                             " + $pp_batch)
ECHO $("                             " + $rep_batch)
ECHO $("                             " + $gate_rt)
ECHO $("                             " + $ts_sch)
ECHO $("                             " + $ts_batch)
ECHO $("                             " + $sch_ebill)
ECHO $("                             " + $sch_rt)
ECHO $("                             " + $tmp)
ECHO " "

ECHO "======================================================================"


# determine how far back we go based on current date
$del_date = $curr_date.AddDays($max_days)


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

#Deletion for inv_bat Folder 
ECHO $($Del_st + $inv_bat)

# delete the files
  Get-ChildItem $inv_bat -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $inv_bat -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $inv_bat)
ECHO " "

#Deletion for inv_rt Folder 
ECHO $($Del_st + $inv_rt)

# delete the files
  Get-ChildItem $inv_rt -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $inv_rt -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $inv_rt)
ECHO " "

#Deletion for corr_bat Folder 
ECHO $($Del_st + $corr_bat)

# delete the files
  Get-ChildItem $corr_bat -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $corr_bat -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $corr_bat)
ECHO " "

#Deletion for corr_rt Folder 
ECHO $($Del_st + $corr_rt)

# delete the files
  Get-ChildItem $corr_rt -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $corr_rt -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $corr_rt)
ECHO " "

#Deletion for ebill Folder 
ECHO $($Del_st + $ebill)

# delete the files
  Get-ChildItem $ebill -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $ebill -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $ebill)
ECHO " "

#Deletion for ebill_eml Folder 
ECHO $($Del_st + $ebill_eml)

# delete the files
  Get-ChildItem $ebill_eml -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $ebill_eml -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $ebill_eml)
ECHO " "

#Deletion for pp_batch Folder 
ECHO $($Del_st + $pp_batch)

# delete the files
  Get-ChildItem $pp_batch -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $pp_batch -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $pp_batch)
ECHO " "

#Deletion for rep_batch Folder 
ECHO $($Del_st + $rep_batch)

# delete the files
  Get-ChildItem $rep_batch -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $rep_batch -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $rep_batch)
ECHO " "

#Deletion for gate_rt Folder 
ECHO $($Del_st + $gate_rt)

# delete the files
  Get-ChildItem $gate_rt -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $gate_rt -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $gate_rt)
ECHO " "

#Deletion for ts_sch Folder 
ECHO $($Del_st + $ts_sch)

# delete the files
  Get-ChildItem $ts_sch -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $ts_sch -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $ts_sch)
ECHO " "

#Deletion for ts_batch Folder 
ECHO $($Del_st + $ts_batch)

# delete the files
  Get-ChildItem $ts_batch -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $ts_batch -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $ts_batch)
ECHO " "

#Deletion for sch_ebill Folder 
ECHO $($Del_st + $sch_ebill)

# delete the files
  Get-ChildItem $sch_ebill -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $sch_ebill -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $sch_ebill)
ECHO " "

#Deletion for sch_rt Folder 
ECHO $($Del_st + $sch_rt)

# delete the files
  Get-ChildItem $sch_rt -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $sch_rt -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $sch_rt)
ECHO " "

#Deletion for sch_rt Folder 
ECHO $($Del_st + $tmp)

# delete the files
  Get-ChildItem $tmp -Recurse -Force | Where-Object { $_.LastWriteTime -lt $del_date } | Remove-Item -Force -Recurse

# Delete any empty directories left behind after deleting the old files.
  Get-ChildItem -Path $tmp -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

ECHO $($Del_end + $tmp)
ECHO " "

ECHO "Deleted Successfully !"
ECHO " "