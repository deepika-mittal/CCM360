 $FullFileName = gci D:\ccm\invoices\output\*.csm | % {$_.Name}|sort laswriteitem|select -last 1
 $FileName = gci D:\ccm\invoices\output\*.csm | % {$_.BaseName}|sort laswriteitem|select -last 1

 ECHO "File Name is : $FullFileName"
 ECHO "File Name is : $FileName"
  
$Pallet=1

ForEach ($line in (Get-Content D:\ccm\invoices\output\$FullFileName)) {
$SeqNo=$line.SubString(72,3)
$TraySize=$line.SubString(12,1)
if ($TraySize -match 'T' -and $SeqNo -match '   ') {
$UIL="2*P00"
}
ElseIf ($TraySize -match 'O' -and $SeqNo -match '   ') {
$UIL="1*P00"
}
ElseIf ($TraySize -match 'P' -and $SeqNo -match '   ') {
$Pallet+=1
$UIL="     "
}
ElseIf ($TraySize -match 'T' -and $SeqNo -ne '   ') {
$UIL="2*P"+$Pallet.tostring("00")
}
ElseIf ($TraySize -match 'O' -and $SeqNo -ne '   ') {
$UIL="1*P"+$Pallet.tostring("00")
}
Else {
$UIL="     "
}
#ECHO "$TraySize    $UIL $SeqNo    $Pallet"

	$line.SubString(0,533)+($line.SubString(534,5) -replace "     ", $UIL) + $line.SubString(538,230) | Out-File D:\ccm\invoices\output\tempcsm.csm -Encoding ASCII -Append
} 

#Move-Item D:\ccm\invoices\output\tempcsm.csm D:\ccm\invoices\output\$FullFileName -Force 
Move-Item D:\ccm\invoices\output\tempcsm.csm D:\ccm\invoices\output\$FileName'.csm' -Force 