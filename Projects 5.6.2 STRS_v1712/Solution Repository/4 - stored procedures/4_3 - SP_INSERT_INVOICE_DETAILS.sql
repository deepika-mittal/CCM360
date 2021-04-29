
DROP PROCEDURE SP_INSERT_INVOICE_DETAILS
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Don Orazulume
-- Modifed date: 2017 02 09
-- Description:	Insert Invoice Details
-- =============================================
CREATE PROCEDURE SP_INSERT_INVOICE_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSDOCID VARCHAR(35), 
	@p_DOCUMENTTYPE VARCHAR(20),
	@p_DOCUMENTTITLE VARCHAR(150),
	@p_ACCOUNTNUMBER VARCHAR(15),
	@p_CUSTOMERNAME VARCHAR(50), 
	@p_DOCUMENTDATE VARCHAR(10),

	@p_BILLDUEDATE VARCHAR(10),	
	@p_BILLTYPE VARCHAR(5),
	@p_TOTALAMOUNTDUE VARCHAR(15),
	@p_BILLFROMDATE VARCHAR(10),
	@p_BILLTODATE VARCHAR(10),
	
	@p_CHANNEL VARCHAR(25), 
	@p_EBILL CHAR(1), 
	@p_RESEND CHAR(1),
	@p_STRSSPOOLID VARCHAR(20),
	
	@p_STRSJOBID INT,		
	@p_STRSADRSID VARCHAR(20),  
	@p_MAILTYPE VARCHAR(10), 
	@p_SORTCODE VARCHAR(10),
	@p_DPCUSTOMERNAME VARCHAR(50), 	
	
	@p_DPATT VARCHAR(50), 
	@p_DPSECDADDR VARCHAR(50),
	@p_DPADDRLINE1 VARCHAR(50), 
	@p_DPADDRLINE2 VARCHAR(50),  
	@p_DPZIP VARCHAR(5),
	@p_DPZIPEXT VARCHAR(10),
	
	@p_DPCITY VARCHAR(40),
	@p_DPSTATE VARCHAR(5), 
	@p_DPCOUNTRY VARCHAR(20),
	@p_FOREIGNADDRESS CHAR(1),
	@p_COPIES INT,	
	
	@p_PAGECOUNT INT,
	@p_SHEETCOUNT INT,
	@p_WEIGHT DECIMAL(5,2),
	@p_SCANLINE VARCHAR(60),
	@p_RICEFW VARCHAR(100),

	@p_GUID VARCHAR(40),
	@p_LPCPRCNT VARCHAR(20),	
	@p_AUTOPAYFLAG CHAR(1),
	@p_PASTDUEAMOUNT VARCHAR(15),
	@p_REMINDERCODES VARCHAR(40),
	
	@p_FIRSTFLAG CHAR(1),
	@p_FINALFLAG CHAR(1),
	@p_METERCHANGEFLAG CHAR(1),
	@p_ADJREVFLAG CHAR(1),
	@p_FREDBILLFLAG CHAR(1),
	
	@p_SREDBILLFLAG CHAR(1),
	@p_BANNERFLAG CHAR(1),
	@p_BANNERCOKEY VARCHAR(40),
	@p_BADADDRESSFLAG CHAR(1),	
	@p_DONOTPRINTFLAG CHAR(1),

	@p_EDIFLAG CHAR(1),
	@p_BPNUMBER VARCHAR(12),
	@p_MEMOFLAG CHAR(1),
	@p_HPPFLAG CHAR(1),
	@p_SENIORFLAG CHAR(1),

	@p_LSPFLAG CHAR(1),
	@p_BWBFLAG CHAR(1),
	@p_PAFLAG CHAR(1),
	@p_SPPFLAG CHAR(1),
	@p_OTTFLAG CHAR(1)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSINV (
				STRSDOCID,
				CREATEDATETIME,
				DOCUMENTTYPE, 
				DOCUMENTTITLE,
				ACCOUNTNUMBER,
				CUSTOMERNAME,
				DOCUMENTDATE,
				BILLDUEDATE,
				BILLTYPE,
				TOTALAMOUNTDUE, 
				BILLFROMDATE,
				BILLTODATE,
				CHANNEL,
				RESEND,
				STRSAFPID,
				STRSPPIDARCHIVE,
				STRSSPOOLID,
				STRSBATCHID,
				STRSJOBID,
				EBILL,				
				RICEFW,
				ADJREVFLAG,
				AUTOPAYFLAG,
				FIRSTFLAG,
				FINALFLAG,
				METERCHANGEFLAG,
				FREDBILLFLAG ,
				SREDBILLFLAG ,
				BANNERFLAG,
				BANNERCOKEY,
				BATCHDATE,
				GUID,
				LPCPRCNT,
				PASTDUEAMOUNT,
				REMINDERCODES,
				BADADDRESSFLAG,
				DONOTPRINTFLAG,
				EDIFLAG,
				BPNUMBER,
				MEMOFLAG,
				HPPFLAG,
				SENIORFLAG,
				LSPFLAG,
				BWBFLAG,
				PAFLAG,
				SPPFLAG,
				OTTFLAG
				)       
			VALUES (
				@p_STRSDOCID, 
				SYSDATETIME(), 
				@p_DOCUMENTTYPE,
				@p_DOCUMENTTITLE,
				@p_ACCOUNTNUMBER,
				@p_CUSTOMERNAME, 
				@p_DOCUMENTDATE,
				@p_BILLDUEDATE,	
				@p_BILLTYPE,
				@p_TOTALAMOUNTDUE,
				@p_BILLFROMDATE,
				@p_BILLTODATE,
				@p_CHANNEL, 
				@p_RESEND,
				'not initialized',
				'not initialized',
				@p_STRSSPOOLID,
				'not initialized',	
				@p_STRSJOBID,
				@p_EBILL,
				@p_RICEFW,
				@p_ADJREVFLAG,
				@p_AUTOPAYFLAG,
				@p_FIRSTFLAG,
				@p_FINALFLAG ,
				@p_METERCHANGEFLAG,
				@p_FREDBILLFLAG,
				@p_SREDBILLFLAG,
				@p_BANNERFLAG,
				@p_BANNERCOKEY,
				'not initialized',
				@p_GUID,
				@p_LPCPRCNT,
				@p_PASTDUEAMOUNT,
				@p_REMINDERCODES,
				@p_BADADDRESSFLAG,	
				@p_DONOTPRINTFLAG,
				@p_EDIFLAG,
				@p_BPNUMBER,
				@p_MEMOFLAG,
				@p_HPPFLAG,
				@p_SENIORFLAG,
				@p_LSPFLAG,
				@p_BWBFLAG,
				@p_PAFLAG,
				@p_SPPFLAG,
				@p_OTTFLAG
				) 
			if(@p_DONOTPRINTFLAG = '')
			begin

			INSERT INTO TAB_STRSPOSTALADRS (
				STRSADRSID,
				MAILTYPE,
				SORTCODE,
				DPCUSTOMERNAME,
				DPATT,
				DPSECDADDR,
				DPADDRLINE1, 
				DPADDRLINE2,
				DPZIP,
				DPZIPEXT,
				DPCITY,
				DPSTATE, 
				DPCOUNTRY,
				FOREIGNADDRESS,
				COPIES,
				PAGECOUNT,
				SHEETCOUNT,
				WEIGHT,
				SCANLINE,
				STRSDOCID,
				STRSCONCATADDRESS,
				STRSENVELOPEID,
				STRSSSORTFILEID,
				STRSBATCHDATE,
				BPNUMBER
				)       
			VALUES (
				@p_STRSADRSID,  
				@p_MAILTYPE, 
				@p_SORTCODE,
				@p_DPCUSTOMERNAME, 	
				@p_DPATT,
				@p_DPSECDADDR,
				@p_DPADDRLINE1, 
				@p_DPADDRLINE2,  
				@p_DPZIP,
				@p_DPZIPEXT,
				@p_DPCITY,
				@p_DPSTATE, 
				@p_DPCOUNTRY,
				@p_FOREIGNADDRESS,
				@p_COPIES,	
				@p_PAGECOUNT,
				@p_SHEETCOUNT,
				@p_WEIGHT,
				@p_SCANLINE,
				@p_STRSDOCID,
				CONCAT(UPPER(@p_DPCUSTOMERNAME), UPPER(@p_DPATT), UPPER(@p_DPSECDADDR), UPPER(@p_DPADDRLINE1), UPPER(@p_DPADDRLINE2), UPPER(@p_DPZIP), UPPER(@p_DPZIPEXT), UPPER(@p_DPCITY), UPPER(@p_DPSTATE), UPPER(@p_DPCOUNTRY)),
				'not initialized',
				'not initialized',
				'not initialized',
				@p_BPNUMBER
			) 
			end
		END
END
GO

GRANT EXECUTE ON SP_INSERT_INVOICE_DETAILS TO StrsSolutionDB
GO