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
 }
 elseif($env -eq 'test'){
 $DSServer="\\dca-acc1122"
 $StreamServer="\\dca-acc1177"
 $DSRepository="CRBDM_AccRepo"
 }
 elseif($env -eq 'prod'){
 $DSServer="\\dca-pro1221"
 $StreamServer="\\dca-pro1177"
 $DSRepository="CRBDM_ProdRepo"
 }
 else {
 $StreamServer=NULL
 $DSRepository=NULL
 }
 

ECHO $("Data Services Box : " + $DSServer)
ECHO $("StreamServe Box : " + $StreamServer)
ECHO $("DS Repository : " + $DSRepository)

$POFInputPath="\opt\streamserve\out\pof\correspondences\cla\input\"
$ReportsOutputPath="\opt\streamserve\out\pof\correspondences\cla\Reports\"
$ADSOutputPath="\opt\streamserve\in\pof\"

ECHO $("POF Input Path on StreamServer Box : " + $POFInputPath)
ECHO $("POF Output Path on StreamServer Box : " + $ReportsOutputPath)
ECHO $("POF Rptput Path on StreamServer Box : " + $ADSOutputPath)


  
Function CLA_AV_PS
# This is a function that runs the address validation job and then runs the presort and create reports and ads file. 
{ 
$DayOfYear = (Get-Date).DayofYear
Write-Host $DayOfYear
echo "Day                      :" $DayOfYear > $log_file

$Year=(Get-Date).Year
#$Year+=1
Write-Host $Year
$OE=$Year%2
Write-Host $OE
if($OE -eq 1){ $DayOfYear+=500 }
$DayOfYear="$DayOfYear".PadLeft(3,"0")

Write-Host $DayOfYear

$Today = (Get-Date)
Write-Host $Today
$TimeStamp=$Today.Month.ToString() + '_' + $Today.Day + '_' + $Today.Year + '_' + $Today.Hour + '_' + $Today.Minute + '_' + $Today.Second
Write-Host $TimeStamp

 $MFILNAME_REG="DECOC"+$DayOfYear
 $MFILNAME_DPL='DECOE'+$DayOfYear
 $MFILNAME_DPR='DECOF'+$DayOfYear

 $REG_MAILSEED=[string]$DayOfYear + "400001"
 $REG_TRAYSEED=[string]$DayOfYear + "49001"
 $REG_PALLETSEED=[string]$DayOfYear + "499000001"

 $DPL_MAILSEED=$DayOfYear+'530001'
 $DPL_TRAYSEED=$DayOfYear+'53001'
 $DPL_PALLETSEED=$DayOfYear+'539000001'

 $DPR_MAILSEED=$DayOfYear+'540001'
 $DPR_TRAYSEED=$DayOfYear+'54001'
 $DPR_PALLETSEED=$DayOfYear+'549000001'


  $FileName = gci D:\CCM\Correspondence\CLA\input\*.pof | % {$_.BaseName}|sort laswriteitem|select -last 1
  echo "FileName : "$FileName
  if($FileName -match 'COR_REGUR'){
  echo "REGULAR LETTERS"
  $FileType=1
  }
  elseif ($FileName -match 'COR_DUPLX') {
  echo "DUPLEX LETTERS"
  $FileType=2
  }
  elseif ($FileName -match 'COR_DUPRE') {
  echo "DUPRE LETTERS"
  $FileType=3
  }
  else {
  echo "OTHER FILE"
  $FileType=5
  }
  

New-Item d:\CCM\Correspondence\CLA\bkup\$TimeStamp -type directory
New-Item d:\CCM\Correspondence\CLA\bkup\$TimeStamp\input -type directory
New-Item d:\CCM\Correspondence\CLA\bkup\$TimeStamp\output -type directory
New-Item d:\CCM\Correspondence\CLA\bkup\$TimeStamp\work -type directory

$Folder = $FileName.substring(0,8) #+"_"+$FileName.substring(28,5)

$PSReportPath="\\dca-acc651\Print_Center\360\$Folder"
if (Test-Path $PSReportPath) { 
echo "Folder Exist for this Batch Date"
#New-Item \\dca-acc651\Print_Center\360\$Folder\$FileName -type directory
New-Item d:\CCM\Correspondence\CLA\ccm_postal_reports\$Folder\$FileName -type directory
}
else {
#New-Item \\dca-acc651\Print_Center\360\$Folder -type directory
#New-Item \\dca-acc651\Print_Center\360\$Folder\$FileName -type directory
New-Item d:\CCM\Correspondence\CLA\ccm_postal_reports\$Folder -type directory
New-Item d:\CCM\Correspondence\CLA\ccm_postal_reports\$Folder\$FileName -type directory
}

 $FullFileName = gci D:\CCM\Correspondence\CLA\input\*.pof | % {$_.Name}|sort laswriteitem|select -last 1
 echo ''
 echo "FullFileName : $FullFileName"
 echo ''
$Lines=Get-Content D:\CCM\Correspondence\CLA\input\$FullFileName
$count=$Lines.Length
Write-Host "$FullFileName has >> $count << records in it"
 echo ''
 

 Copy-Item D:\CCM\Correspondence\CLA\input\$FullFileName D:\CCM\Correspondence\CLA\input\CLA_DS_IN.txt

# DOING ADDRESS VALIDATION HERE
if($count -lt 267){ 
ECHO "PROCESSING WITHOUT NCOA"
 D:\CCM\Correspondence\CLA\bin\CLA_AV.bat	| out-null
<# Get-ChildItem -Path  $("D:\CCM\Correspondence\CLA\reports\" + $DSRepository + "\job_ccm_batch_AV\") -Filter "*USAR_ccm_batch*" | Rename-Item -NewName {$_.name -replace 'USAR_ccm_batch', $FileName }
 Get-ChildItem -Path  $("D:\CCM\Correspondence\CLA\reports\" + $DSRepository + "\job_ccm_batch_AV\") -Filter "*summary*" | Rename-Item -NewName {$_.name -replace 'summary', "SUMMARY_$FileName" }
 Move-Item $("D:\CCM\Correspondence\CLA\reports\" + $DSRepository + "\job_ccm_batch_AV\*.pdf") D:\CCM\Correspondence\CLA\OUTPUT
#> }
 else {
ECHO "PROCESSING WITH NCOA"
 D:\CCM\Correspondence\CLA\bin\CLA_NCOA_AV.bat | out-null
<# Get-ChildItem -Path  $("D:\CCM\Correspondence\CLA\reports\" + $DSRepository + "\job_ccm_NCOA_batch_AV\") -Filter "*USAR_ccm_NCOA_batch*" | Rename-Item -NewName {$_.name -replace 'USAR_ccm_NCOA_batch', $FileName }
 Get-ChildItem -Path  $("D:\CCM\Correspondence\CLA\reports\" + $DSRepository + "\job_ccm_NCOA_batch_AV\") -Filter "add*summary*" | Rename-Item -NewName {$_.name -replace 'summary', "SUMMARY_$FileName" }
 Get-ChildItem -Path  $("D:\CCM\Correspondence\CLA\reports\" + $DSRepository + "\job_ccm_NCOA_batch_AV\") -Filter "dpv*summary*" | Rename-Item -NewName {$_.name -replace 'summary', "SUMMARY_$FileName" }
 Move-Item $("D:\CCM\Correspondence\CLA\reports\" + $DSRepository + "\job_ccm_NCOA_batch_AV\*.pdf") D:\CCM\Correspondence\CLA\OUTPUT
#> }


Copy-Item D:\CCM\Correspondence\CLA\bin\presort_CLA_in.def D:\CCM\Correspondence\CLA\work\
Copy-Item D:\CCM\Correspondence\CLA\bin\presort_CLA_in.dmt D:\CCM\Correspondence\CLA\work\
Copy-Item D:\CCM\Correspondence\CLA\output\CLA_DS_OUT.csv D:\CCM\Correspondence\CLA\work\presort_CLA_in.csv

 #########################
														  
ECHO $FileType
 
 if($FileType -eq 1){ 
	$MFILENAME=$MFILNAME_REG 
	$MSEED=$REG_MAILSEED
	$TSEED=$REG_TRAYSEED
	$PSEED=$REG_PALLETSEED
 }
 elseif($FileType -eq 2){
	$MFILENAME=$MFILNAME_DPL
	$MSEED=$DPL_MAILSEED
	$TSEED=$DPL_TRAYSEED
	$PSEED=$DPL_PALLETSEED
 } 
 elseif($FileType -eq 3){
	$MFILENAME=$MFILNAME_DPR
	$MSEED=$DPR_MAILSEED
	$TSEED=$DPR_TRAYSEED
	$PSEED=$DPR_PALLETSEED
 } 
 else {
    Write-Host "Not a correct file"
 } 
 
Write-Host $MFILENAME
Write-Host $MSEED
Write-Host $TSEED
Write-Host $PSEED

									 
(Get-Content D:\CCM\Correspondence\CLA\bin\cla_presort.pst) | ForEach-Object { 
	$_ -replace "%MFILENAME%", $MFILENAME `
	-replace "%MSEED%", $MSEED `
	-replace "%TSEED%", $TSEED `
	-replace "%PSEED%", $PSEED `
	-replace "%FILENAME%", $FileName
	} | Set-Content D:\CCM\Correspondence\CLA\work\$FileName'.pst'


		edjob_ss /c D:\ss\pst\pwpstjob.upd D:\CCM\Correspondence\CLA\work\$FileName'.pst'
		edjob_ss /c D:\ss\pst\maildat_15_1.upd D:\CCM\Correspondence\CLA\work\$FileName'.pst'

		D:\ss\pst\presort /a /nos D:\CCM\Correspondence\CLA\work\$FileName'.pst' | out-null

COPY-Item D:\CCM\Correspondence\CLA\WORK\*.ads -destination $($StreamServer + $ADSOutputPath)
Move-Item D:\CCM\Correspondence\CLA\WORK\*.ads d:\CCM\Correspondence\CLA\bkup\$TimeStamp\work

		
Move-Item D:\CCM\Correspondence\CLA\WORK\*.* d:\CCM\Correspondence\CLA\bkup\$TimeStamp\work
Move-Item D:\CCM\Correspondence\CLA\OUTPUT\*.* d:\CCM\Correspondence\CLA\bkup\$TimeStamp\output
Move-Item D:\CCM\Correspondence\CLA\INPUT\*.* d:\CCM\Correspondence\CLA\bkup\$TimeStamp\input

COPY-Item d:\CCM\Correspondence\CLA\bkup\$TimeStamp\input d:\CCM\Correspondence\CLA\ccm_postal_reports\$Folder\$FileName -recurse
COPY-Item d:\CCM\Correspondence\CLA\bkup\$TimeStamp\output d:\CCM\Correspondence\CLA\ccm_postal_reports\$Folder\$FileName -recurse
COPY-Item d:\CCM\Correspondence\CLA\bkup\$TimeStamp\work d:\CCM\Correspondence\CLA\ccm_postal_reports\$Folder\$FileName -recurse

} 

$strFileName="d:\ccm\Correspondence\CLA\input\process.done"

Do {
ECHO Move-item $($StreamServer + $POFInputPath + "*.pof") -destination D:/ccm/Correspondence/CLA/input/

#Move-item $($StreamServer + "\opt\streamserve\out\pof\INVOICES\cni\input\*.pof") D:/ccm/Correspondence/CLA/input/
#Move-item $($StreamServer + "\opt\streamserve\out\pof\correspondences\pc\input\*.pof") D:/ccm/Correspondence/CLA/input/
#Move-item $($StreamServer + "\opt\streamserve\out\pof\correspondences\hpp\input\*.pof") D:/ccm/Correspondence/CLA/input/
Move-item $($StreamServer + $POFInputPath + "*.pof") -destination D:/ccm/Correspondence/CLA/input/
Move-item $($StreamServer + $POFInputPath + "*process.done") -destination D:/ccm/Correspondence/CLA/input/

If (Test-Path 'D:\CCM\Correspondence\CLA\INPUT\*.pof'){
 write-host "New input file exist, processing through Address Validation and Presort"
 CLA_AV_PS
}Else{
  write-host "Input file does not Exist"
}
write-host "Waiting for either new file to process or Process.done file to finish, Sleeping for 90 Seconds @" $(Get-Date)
		Start-Sleep -s 90
} While (![System.IO.File]::Exists($strFileName))

write-host "Process done. Exiting program"

Move-Item D:\CCM\Correspondence\CLA\input\*process.done d:\CCM\Correspondence\CLA\bkup -force
Get-ChildItem -Path  "D:\CCM\Correspondence\CLA\BKUP" -Recurse -Force| Where-Object CreationTime -lt (Get-Date).AddDays(-20) | Remove-Item -Recurse -Force
