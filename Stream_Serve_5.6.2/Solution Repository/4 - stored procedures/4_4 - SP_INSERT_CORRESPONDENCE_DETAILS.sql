
DROP PROCEDURE SP_INSERT_CORRESPONDENCE_DETAILS
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
-- Modifed date: 2017 01 27
-- Description:	Insert Correspondence Details
-- =============================================
CREATE PROCEDURE SP_INSERT_CORRESPONDENCE_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSDOCID VARCHAR(50),  
	@p_DOCUMENTTYPE VARCHAR(20),
	@p_DOCUMENTTITLE VARCHAR(150),
	@p_DOCUMENTCATEGORY VARCHAR(30),
	@p_ACCOUNTNUMBER VARCHAR(15),
	@p_CUSTOMERNAME VARCHAR(40), 
	@p_DOCUMENTDATE VARCHAR(10),
	@p_CHANNEL VARCHAR(25), 
	@p_RESEND CHAR(1),
	@p_REPRINT CHAR(1),
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
	@p_SCANLINE VARCHAR(60)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSCORR (
				STRSDOCID,
				CREATEDATETIME,
				DOCUMENTTYPE,
				DOCUMENTTITLE,
				DOCUMENTCATEGORY,
				ACCOUNTNUMBER,
				CUSTOMERNAME,
				DOCUMENTDATE,
				CHANNEL,
				RESEND, 
				REPRINT,
				STRSAFPID,
				STRSPPIDARCHIVE,
				BATCHDATE,
				STRSSPOOLID,
				STRSBATCHID,
				STRSJOBID
				)       
			VALUES (
				@p_STRSDOCID, 
				SYSDATETIME(), 
				@p_DOCUMENTTYPE,
				@p_DOCUMENTTITLE,
				@p_DOCUMENTCATEGORY,
				@p_ACCOUNTNUMBER,
				@p_CUSTOMERNAME, 
				@p_DOCUMENTDATE,
				@p_CHANNEL, 
				@p_RESEND, 
				@p_REPRINT,
				'not initialized',
				'not initialized',
				'not initialized',
				@p_STRSSPOOLID,
				'not initialized',	
				@p_STRSJOBID
				) 

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
				STRSBATCHDATE
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
				'not initialized'
				) 
		END 		
END
GO

GRANT EXECUTE ON SP_INSERT_CORRESPONDENCE_DETAILS TO StrsSolutionDB
GO