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
 $DSRepository="CRBDMD17"
 $ReportServer="vistadev.serv.deco.com"
 $ReportArchivePath="/opt/csb/test_vista/capture/"
 $ReportUserID="csbrpts"
 }
 elseif($env -eq 'test'){
 $DSServer="\\dca-acc1122"
 $StreamServer="\\dca-acc1177"
 $DSRepository="CRBDM_AccRepo"
 $ReportServer="vistadev.serv.deco.com"
 $ReportArchivePath="/opt/csb/test_vista/capture/"
 $ReportUserID="csbrpts"
 }
 elseif($env -eq 'prod'){
 $DSServer="\\dca-pro1221"
 $StreamServer="\\dca-pro1177"
 $DSRepository="CRBDM_ProdRepo"
 $ReportServer="vista.serv.deco.com"
 $ReportArchivePath="/opt/csb/capture/opa/"
 $ReportUserID="csbrpts"
 }
 else {
 $StreamServer=NULL
 $DSRepository=NULL
 $ReportServer=NULL
 $ReportArchivePath=NULL
 $ReportUserID=NULL
 }
 

ECHO $("Data Services Box : " + $DSServer)
ECHO $("StreamServe Box : " + $StreamServer)
ECHO $("DS Repository : " + $DSRepository)
ECHO $("Reports Server : " + $ReportServer)
ECHO $("Reports Archive Path : " + $ReportArchivePath)
ECHO $("Reports UserID : " + $ReportUserID)
ECHO ""

$POFInputPath="\opt\streamserve\out\pof\invoices\bills\input\"
$ReportsOutputPath="\opt\streamserve\out\pof\invoices\bills\Reports\"
$ADSOutputPath="\opt\streamserve\in\pof\"

ECHO $("POF Input Path on StreamServer Box : " + $POFInputPath)
ECHO $("POF Output Path on StreamServer Box : " + $ReportsOutputPath)
ECHO $("POF Rptput Path on StreamServer Box : " + $ADSOutputPath)
ECHO ""

  
Function AV_PS 
# This is a function that runs the address validation job and then runs the presort and create reports and ads file. 
{ 
$Today = (Get-Date)
Write-Host $Today
$TimeStamp=$Today.Month.ToString() + '_' + $Today.Day + '_' + $Today.Year + '_' + $Today.Hour + '_' + $Today.Minute + '_' + $Today.Second
Write-Host "Time Stamp is: $TimeStamp"

$NextJulDay = (Get-Date).Addhours(4)
$DayOfYear=$NextJulDay.DayOfYear
Write-Host "Today's Julian Day: " (Get-Date).DayOfYear
echo "Julian Day to be used: $DayOfYear" 

$Year=(Get-Date).Year

Write-Host $Year
$OE=$Year%2
Write-Host $OE
if($OE -eq 1){ $DayOfYear+=500 }
$DayOfYear="$DayOfYear".PadLeft(3,"0")

Write-Host $DayOfYear

 $MFILNAME_REG="DECOB"+$DayOfYear
 $MFILNAME_SHUT='DECOS'+$DayOfYear
 $MFILNAME_OTHER='DECOO'+$DayOfYear
 $MFILNAME_RO='DECOD'+$DayOfYear
 $MFILNAME_SO='DECOR'+$DayOfYear
 $MFILNAME_CLA_REG='DECOC'+$DayOfYear
 $MFILNAME_CLA_DPL='DECOE'+$DayOfYear
 $MFILNAME_CLA_DPR='DECOF'+$DayOfYear
 $MFILNAME_HPP_REG='DECOH'+$DayOfYear
 $MFILNAME_HPP_DPL='DECOJ'+$DayOfYear
 $MFILNAME_PC='DECOP'+$DayOfYear
 $MFILNAME_KCS='DECOK'+$DayOfYear 

 $REG_MAILSEED=[string]$DayOfYear + "000001"
 $REG_TRAYSEED=[string]$DayOfYear + "09001"
 $REG_PALLETSEED=[string]$DayOfYear + "099000001"

 $SHUT_MAILSEED=$DayOfYear+'300001'
 $SHUT_TRAYSEED=$DayOfYear+'39001'
 $SHUT_PALLETSEED=$DayOfYear+'399000001'

 $RO_MAILSEED=$DayOfYear+'680001'
 $RO_TRAYSEED=$DayOfYear+'68901'
 $RO_PALLETSEED=$DayOfYear+'689900001'
 
 $SO_MAILSEED=$DayOfYear+'690001'
 $SO_TRAYSEED=$DayOfYear+'69901'
 $SO_PALLETSEED=$DayOfYear+'699900001'

 $CLA_REG_MAILSEED=$DayOfYear+'400001'
 $CLA_REG_TRAYSEED=$DayOfYear+'49001'
 $CLA_REG_PALLETSEED=$DayOfYear+'499000001'
 
 $CLA_DPL_MAILSEED=$DayOfYear+'530001'
 $CLA_DPL_TRAYSEED=$DayOfYear+'53001'
 $CLA_DPL_PALLETSEED=$DayOfYear+'539000001'

 $CLA_DPR_MAILSEED=$DayOfYear+'540001'
 $CLA_DPR_TRAYSEED=$DayOfYear+'54001'
 $CLA_DPR_PALLETSEED=$DayOfYear+'549000001'

 $HPP_REG_MAILSEED=$DayOfYear+'600001'
 $HPP_REG_TRAYSEED=$DayOfYear+'60901'
 $HPP_REG_PALLETSEED=$DayOfYear+'609900001'

 $HPP_DPL_MAILSEED=$DayOfYear+'640001'
 $HPP_DPL_TRAYSEED=$DayOfYear+'60901'
 $HPP_DPL_PALLETSEED=$DayOfYear+'609900001'

 $PC_MAILSEED=$DayOfYear+'700001'
 $PC_TRAYSEED=$DayOfYear+'79001'
 $PC_PALLETSEED=$DayOfYear+'799000001'

 $KCS_MAILSEED=$DayOfYear+'240001'
 $KCS_TRAYSEED=$DayOfYear+'20901'
 $KCS_PALLETSEED=$DayOfYear+'209000001'

 $OTHER_MAILSEED=1
 $OTHER_TRAYSEED=1
 $OTHER_PALLETSEED=1

  $FileName = gci D:\CCM\INVOICES\input\*.pof | % {$_.BaseName}|sort laswriteitem|select -last 1
  echo "FileName : "$FileName
  if($FileName -match 'INV_RSREG'){
  echo "REGULAR FILE"
  $FileType=1
  }
  elseif ($FileName -match 'INV_SHOFF') {
  echo "SHUTOFF FILE"
  $FileType=2
  }
  elseif ($FileName -match 'INV_RSOVWG') {
  echo "REGULAR OVERWEIGHT FILE"
  $FileType=3
  }
  elseif ($FileName -match 'SOverweight') {
  echo "SHUT OVERWEIGHT FILE"
  $FileType=4
  } 
  elseif ($FileName -match 'COR_REGUR') {
  echo "CLA REGULAR FILE"
  $FileType=5
  } 
  elseif ($FileName -match 'COR_DUPLX') {
  echo "CLA DUPLEX FILE"
  $FileType=6
  } 
  elseif ($FileName -match 'COR_DUPRE') {
  echo "CLA DUPRE FILE"
  $FileType=7
  } 
  elseif ($FileName -match 'COR_HPP') {
  echo "HPP REGULAR FILE"
  $FileType=8
  } 
  elseif ($FileName -match 'COR_HPP_DPL') {
  echo "HPP DUPLEX FILE"
  $FileType=9
  } 
  elseif ($FileName -match 'COR_POSTC') {
  echo "POSTCARDS FILE"
  $FileType=10
  } 
  elseif ($FileName -match 'INV_CMREG') {
  echo "KCS FILE"
  $FileType=11
  } 
  else {
  echo "OTHER FILE"
  $FileType=12
  }

New-Item d:\CCM\INVOICES\bkup\$TimeStamp -type directory
New-Item d:\CCM\INVOICES\bkup\$TimeStamp\input -type directory
New-Item d:\CCM\INVOICES\bkup\$TimeStamp\output -type directory
New-Item d:\CCM\INVOICES\bkup\$TimeStamp\work -type directory

$Folder = $FileName.substring(0,8) #+"_"+$FileName.substring(28,5)

$PSReportPath="\\dca-acc651\Print_Center\360\$Folder"
if (Test-Path $PSReportPath) { 
echo "Folder Exist for this Batch Date"
#New-Item \\dca-acc651\Print_Center\360\$Folder\$FileName -type directory
New-Item d:\CCM\invoices\ccm_postal_reports\$Folder\$FileName -type directory
}
else {
#New-Item \\dca-acc651\Print_Center\360\$Folder -type directory
#New-Item \\dca-acc651\Print_Center\360\$Folder\$FileName -type directory
New-Item d:\CCM\invoices\ccm_postal_reports\$Folder -type directory
New-Item d:\CCM\invoices\ccm_postal_reports\$Folder\$FileName -type directory
}

 $FullFileName = gci D:\CCM\INVOICES\input\*.pof | % {$_.Name}|sort laswriteitem|select -last 1
 echo ''
 echo "FullFileName : $FullFileName"
 echo ''
$Lines=Get-Content D:\CCM\INVOICES\input\$FullFileName
$count=$Lines.Length
Write-Host "$FullFileName has >> $count << records in it"
 echo ''
 

 Copy-Item D:\CCM\INVOICES\input\$FullFileName D:\CCM\INVOICES\input\DS_IN.txt

# DOING ADDRESS VALIDATION HERE
if($count -lt 267){ 
ECHO "PROCESSING WITHOUT NCOA"
 D:\CCM\INVOICES\bin\NO_NCOA_AV.bat	| out-null
 }
 else {
ECHO "PROCESSING WITH NCOA"
 D:\CCM\INVOICES\bin\NCOA_AV.bat | out-null
 }
 

Copy-Item D:\CCM\INVOICES\bin\presort_in.def D:\CCM\INVOICES\work\
Copy-Item D:\CCM\INVOICES\bin\presort_in.dmt D:\CCM\INVOICES\work\
Copy-Item D:\CCM\INVOICES\output\DS_OUT.csv D:\CCM\INVOICES\work\presort_in.csv

 #########################
ECHO $FileType
 
 if($FileType -eq 1){ 
	$MFILENAME=$MFILNAME_REG 
	$MSEED=$REG_MAILSEED
	$TSEED=$REG_TRAYSEED
	$PSEED=$REG_PALLETSEED
 }
 elseif($FileType -eq 2){
	$MFILENAME=$MFILNAME_SHUT
	$MSEED=$SHUT_MAILSEED
	$TSEED=$SHUT_TRAYSEED
	$PSEED=$SHUT_PALLETSEED
 } 
 elseif($FileType -eq 3){
	$MFILENAME=$MFILNAME_RO
	$MSEED=$RO_MAILSEED
	$TSEED=$RO_TRAYSEED
	$PSEED=$RO_PALLETSEED
 } 
 elseif($FileType -eq 4){
	$MFILENAME=$MFILNAME_SO
	$MSEED=$SO_MAILSEED
	$TSEED=$SO_TRAYSEED
	$PSEED=$SO_PALLETSEED
 } 
 elseif($FileType -eq 5){
	$MFILENAME=$MFILNAME_CLA_REG
	$MSEED=$CLA_REG_MAILSEED
	$TSEED=$CLA_REG_TRAYSEED
	$PSEED=$CLA_REG_PALLETSEED
 } 
 elseif($FileType -eq 6){
	$MFILENAME=$MFILNAME_CLA_DPL
	$MSEED=$CLA_DPL_MAILSEED
	$TSEED=$CLA_DPL_TRAYSEED
	$PSEED=$CLA_DPL_PALLETSEED
 } 
 elseif($FileType -eq 7){
	$MFILENAME=$MFILNAME_CLA_DPR
	$MSEED=$CLA_DPR_MAILSEED
	$TSEED=$CLA_DPR_TRAYSEED
	$PSEED=$CLA_DPR_PALLETSEED
 } 
 elseif($FileType -eq 8){
	$MFILENAME=$MFILNAME_HPP_REG
	$MSEED=$HPP_REG_MAILSEED
	$TSEED=$HPP_REG_TRAYSEED
	$PSEED=$HPP_REG_PALLETSEED
 } 
 elseif($FileType -eq 9){
	$MFILENAME=$MFILNAME_HPP_DPL
	$MSEED=$HPP_DPL_MAILSEED
	$TSEED=$HPP_DPL_TRAYSEED
	$PSEED=$HPP_DPL_PALLETSEED
 } 
 elseif($FileType -eq 10){
	$MFILENAME=$MFILNAME_PC
	$MSEED=$PC_MAILSEED
	$TSEED=$PC_TRAYSEED
	$PSEED=$PC_PALLETSEED
 } 
 elseif($FileType -eq 11){
	$MFILENAME=$MFILNAME_KCS
	$MSEED=$KCS_MAILSEED
	$TSEED=$KCS_TRAYSEED
	$PSEED=$KCS_PALLETSEED
 } 
 else {
	$MFILENAME=$MFILNAME_OTHER
	$MSEED=$OTHER_MAILSEED
	$TSEED=$OTHER_TRAYSEED
	$PSEED=$OTHER_PALLETSEED
 } 
 
Write-Host $MFILENAME
Write-Host $MSEED
Write-Host $TSEED
Write-Host $PSEED

									 
(Get-Content D:\CCM\INVOICES\bin\presort.pst) | ForEach-Object { 
	$_ -replace "%MFILENAME%", $MFILENAME `
	-replace "%MSEED%", $MSEED `
	-replace "%TSEED%", $TSEED `
	-replace "%PSEED%", $PSEED
	} | Set-Content D:\CCM\INVOICES\work\$FileName'.pst'


		edjob_ss /c D:\ss\pst\pwpstjob.upd D:\CCM\invoices\work\$FileName'.pst'
		edjob_ss /c D:\ss\pst\maildat_17_1.upd D:\CCM\invoices\work\$FileName'.pst'

		D:\ss\pst\presort /a /nos D:\CCM\invoices\work\$FileName'.pst' | out-null

COPY-Item D:\CCM\invoices\WORK\*.ads -destination $($StreamServer + $ADSOutputPath)
Move-Item D:\CCM\invoices\WORK\*.ads d:\CCM\INVOICES\bkup\$TimeStamp\work

ECHO "CSM Report is being updated"
 Invoke-Expression D:\CCM\INVOICES\bin\update_csm.ps1 | out-null
ECHO "CSM Report is updated"


# Moving reports from DS Repository to the Inv_Reports area
 D:\CCM\INVOICES\bin\job_move_inv_reports.bat | out-null
 Get-ChildItem -Path "D:\CCM\INVOICES\inv_reports\" -Filter "*ncoalinksummary*" | Rename-Item -NewName {$_.name -replace 'summary_USAR_ccm_NCOA_batch', "_$FileName" }
 Get-ChildItem -Path "D:\CCM\INVOICES\inv_reports\" -Filter "*summary*" | Rename-Item -NewName {$_.name -replace 'summary', "_$FileName" }
 Get-ChildItem -Path "D:\CCM\INVOICES\inv_reports\" -Filter "*USAR_ccm_NCOA_batch*" | Rename-Item -NewName {$_.name -replace 'USAR_ccm_NCOA_batch', "$FileName" }
 Get-ChildItem -Path "D:\CCM\INVOICES\inv_reports\" -Filter "*USAR_ccm_batch*" | Rename-Item -NewName {$_.name -replace 'USAR_ccm_batch', "$FileName" }

# Added for 353 Report to VISTA , Defect# 1517 - START
# $File353 = gci D:\CCM\invoices\output\*psform3553*.rtf | % {$_.Name}|sort laswriteitem|select -last 1
 
 $File353 = gci D:\CCM\INVOICES\inv_reports\*psform3553*.rtf | % {$_.Name}|sort laswriteitem|select -last 1
 echo ''
 echo "Found 353 Report File : $File353"
 echo ''

  if($File353 -match 'psform3553')
  {
	
    $Ren353 = $File353 + ".353"
    echo ''
    echo "353 File Before Rename: $File353"
    echo ''

	Copy-Item D:\CCM\INVOICES\inv_reports\$File353 D:\CCM\INVOICES\inv_reports\$Ren353 

    echo ''
    echo "353 File After Rename: $Ren353"
    echo 'Rename completed'
    echo ''
  }
  else
  {
	echo "353 Report file not found" 	
  }	
# Added for 353 Report to VISTA , Defect# 1517 - END

 Move-Item D:\CCM\INVOICES\inv_reports\*.* d:\CCM\INVOICES\bkup\$TimeStamp\output
		
		
 Move-Item D:\CCM\invoices\WORK\*.* d:\CCM\INVOICES\bkup\$TimeStamp\work
 Move-Item D:\CCM\invoices\OUTPUT\*.* d:\CCM\INVOICES\bkup\$TimeStamp\output
 Move-Item D:\CCM\invoices\INPUT\*.* d:\CCM\INVOICES\bkup\$TimeStamp\input


if ($FileName -match 'INV_SHOFF') {
  echo "SHUTOFF FILE - Sending reports to the PGP Server"
  scpg3 D:\CCM\INVOICES\bkup\$TimeStamp\output\DECOS*.* ddatbat@pgp.dteco.com:/opt/ddatbat/batch/data/outbound
  scpg3 D:\CCM\INVOICES\bkup\$TimeStamp\output\*psform3553*.rtf ddatbat@pgp.dteco.com:/opt/ddatbat/batch/data/outbound
  scpg3 D:\CCM\INVOICES\bkup\$TimeStamp\output\*.pqr ddatbat@pgp.dteco.com:/opt/ddatbat/batch/data/outbound
  echo "SHUTOFF FILE - Sending reports to the PGP Server Complete"
  echo "Placing Mail.Dat files for Shutoff on NAS1 /ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  scpg3 --password=file://c:/users/maestro/pwfile D:\CCM\INVOICES\bkup\$TimeStamp\output\DECOS*.* sshnas@dca-pro617:"/ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  echo "Placing Mail.Dat files for Shutoff on NAS1 Complete"
 }

if ($FileName -match 'INV_RSREG') {
  echo "Placing Mail.Dat files for Regular on NAS1 /ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  scpg3 --password=file://c:/users/maestro/pwfile D:\CCM\INVOICES\bkup\$TimeStamp\output\DECOB*.* sshnas@dca-pro617:"/ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  echo "Placing Mail.Dat files for Regular on NAS1 Complete"
 }
elseif ($FileName -match 'COR_REGUR') {
  echo "Placing Mail.Dat files for Regular Letters on NAS1 /ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  scpg3 --password=file://c:/users/maestro/pwfile D:\CCM\INVOICES\bkup\$TimeStamp\output\DECOC*.* sshnas@dca-pro617:"/ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  echo "Placing Mail.Dat files for Regular Letters on NAS1 Complete"
 } 
elseif ($FileName -match 'COR_DUPRE') {
  echo "Placing Mail.Dat files for Dupre Letters on NAS1 /ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  scpg3 --password=file://c:/users/maestro/pwfile D:\CCM\INVOICES\bkup\$TimeStamp\output\DECOF*.* sshnas@dca-pro617:"/ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  echo "Placing Mail.Dat files for Dupre Letters on NAS1 Complete"
 } 
elseif ($FileName -match 'COR_HPP') {
  echo "Placing Mail.Dat files for HPP on NAS1 /ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  scpg3 --password=file://c:/users/maestro/pwfile D:\CCM\INVOICES\bkup\$TimeStamp\output\DECOH*.* sshnas@dca-pro617:"/ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  echo "Placing Mail.Dat files for HPP on NAS1 Complete"
 }  
elseif ($FileName -match 'COR_POSTC') {
  echo "Placing Mail.Dat files for Postcards on NAS1 /ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  scpg3 --password=file://c:/users/maestro/pwfile D:\CCM\INVOICES\bkup\$TimeStamp\output\DECOP*.* sshnas@dca-pro617:"/ED/Customer Service/Customer Billing Support Services/Mail.dat/Streamserve/"
  echo "Placing Mail.Dat files for Postcards on NAS1 Complete"
 }  
 
ECHO "Sending Reports to VISTA."  
scpg3 D:\CCM\INVOICES\bkup\$TimeStamp\output\$FileName.* $($ReportUserID +"@"+ $ReportServer +":"+ $ReportArchivePath)
scpg3 D:\CCM\INVOICES\bkup\$TimeStamp\output\*.rtf $($ReportUserID +"@"+ $ReportServer +":"+ $ReportArchivePath)
scpg3 D:\CCM\INVOICES\bkup\$TimeStamp\output\*.353 $($ReportUserID +"@"+ $ReportServer +":"+ $ReportArchivePath)
ECHO "Done Sending Reports to VISTA."


COPY-Item d:\CCM\INVOICES\bkup\$TimeStamp\input d:\CCM\invoices\ccm_postal_reports\$Folder\$FileName -recurse
COPY-Item d:\CCM\INVOICES\bkup\$TimeStamp\output d:\CCM\invoices\ccm_postal_reports\$Folder\$FileName -recurse
COPY-Item d:\CCM\INVOICES\bkup\$TimeStamp\work d:\CCM\invoices\ccm_postal_reports\$Folder\$FileName -recurse

} 
$strFileName="d:\ccm\invoices\input\process.done"

Do {
ECHO "Move-item $($StreamServer + $POFInputPath + "*.pof") -destination D:/ccm/invoices/input/"

Move-item $($StreamServer + $POFInputPath + "*.pof") -destination D:/ccm/invoices/input/
Move-item $($StreamServer + $POFInputPath + "*process.done") -destination D:/ccm/invoices/input/

If (Test-Path 'D:\CCM\invoices\INPUT\*.pof'){
 write-host "New input file exist, processing through Address Validation and Presort"
 AV_PS
}Else{
  ECHO ""	
  write-host "Input file does not Exist"
}
write-host "Waiting for either new file to process or Process.done file to finish, Sleeping for 90 Seconds @" $(Get-Date)
		Start-Sleep -s 90
} While (![System.IO.File]::Exists($strFileName))

write-host "Process done. Exiting program"

Move-Item D:\CCM\invoices\input\*process.done d:\CCM\INVOICES\bkup -force
Get-ChildItem -Path  "D:\CCM\INVOICES\BKUP" -Recurse -Force| Where-Object CreationTime -lt (Get-Date).AddDays(-10) | Remove-Item -Recurse -Force
Get-ChildItem -Path  "D:\CCM\INVOICES\ccm_postal_reports" -Recurse -Force| Where-Object CreationTime -lt (Get-Date).AddDays(-30) | Remove-Item -Recurse -Force