:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::          Script:   batchenv.bat
::        Platform:   Windows Scripting, BAT FILE
::            Date:   02/18/2016
::         Version:   $Header: batchenv.bat \main\1 2013/05/29 15:35 UTC u05330 Exp $
::         Purpose:   Facilitates the evironment setup of the paths and folders for address validation and presort process in 360 
::
::  Scripts called:   None
::
:: Calling Scripts:   All the batch processing scripts in DS and Presort
::
::     Input Files:   None
::
::    Output Files:   None
::
::            Exits:  End of Program                    
::
::    Return Values:  None
::
::    Special Logic:  None
::			
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@ECHO OFF

 SET CCM_HOME=D$\CCM
  
 SET PRISMA=162.9.19.111
 SET PRISMA_IN=/u/home/streamserve/Documents
 SET PRISMA_BKUP=/u/home/streamserve_bkup/Documents


 SET env_name=%1

 goto %env_name% 
   
:prod
	SET HOST_NAME=DCA-PRO1121.dtenet.com
    SET CCM_OUT=%CCM_HOME%\invoices\output
    SET CCM_IN=%CCM_HOME%\invoices\input
	SET CCM_WORK=%CCM_HOME%\invoices\work
  	SET CCM_LOG=%CCM_HOME%\invoices\log
 	SET CCM_BKUP=%CCM_HOME%\invoices\bkup
	SET CCM_BIN=%CCM_HOME%\invoices\bin
	SET CCM_RBBS=%CCM_HOME%\invoices\RBBS
	goto :EOF

:dev
	SET HOST_NAME=DCA-DEV1121.dtenet.com
    SET CCM_OUT=%CCM_HOME%\invoices\output
    SET CCM_IN=%CCM_HOME%\invoices\input
	SET CCM_WORK=%CCM_HOME%\invoices\work
  	SET CCM_LOG=%CCM_HOME%\invoices\log
 	SET CCM_BKUP=%CCM_HOME%\invoices\bkup
	SET CCM_BIN=%CCM_HOME%\invoices\bin
	SET CCM_RBBS=%CCM_HOME%\invoices\RBBS
	goto :EOF

:test
	SET HOST_NAME=DCA-ACC1121.dtenet.com
    SET CCM_OUT=%CCM_HOME%\invoices\output
    SET CCM_IN=%CCM_HOME%\invoices\input
	SET CCM_WORK=%CCM_HOME%\invoices\work
  	SET CCM_LOG=%CCM_HOME%\invoices\log
 	SET CCM_BKUP=%CCM_HOME%\invoices\bkup
	SET CCM_BIN=%CCM_HOME%\invoices\bin
	SET CCM_RBBS=%CCM_HOME%\invoices\RBBS
    goto :EOF
       

:*
	SET HOST_NAME=DCA-DEV1121
::    SET ETL_SERVER=hp603a
::    SET ETL_CSB_DIR=\opt\bfs\csb\input
::    SET ETL_USR=strsftp
::    SET PRT_Q=newtriplex
