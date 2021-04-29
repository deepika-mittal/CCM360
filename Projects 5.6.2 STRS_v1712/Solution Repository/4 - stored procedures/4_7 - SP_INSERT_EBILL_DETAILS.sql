
DROP PROCEDURE SP_INSERT_EBILL_DETAILS
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
-- Author:		Glenn Heying
-- Modifed date: 2016 03 14
-- Description:	Insert EBILL Details
-- =============================================
CREATE PROCEDURE SP_INSERT_EBILL_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSDOCID VARCHAR(50), 
	@p_BILLTYPE VARCHAR(20),
	@p_EMAILADDRESS VARCHAR(250),
	@p_SEGMENT INT, 
	@p_HTMLFILE VARCHAR(100), 
	@p_IMAGEFILE VARCHAR(100), 
	@p_CSVFILE	VARCHAR(100), 
	@p_INVOICELLINK VARCHAR(100),
	@p_COKEY VARCHAR(50),	
	@p_STRSSPOOLID VARCHAR(20),
	@p_STRSJOBID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSEBILL (
				STRSDOCID,
				CREATEDATETIME,
				BILLTYPE,
				EMAILADDRESS,
				SEGMENT,
				HTMLFILE,
				IMAGEFILE,
				CSVFILE,
				INVOICELLINK,
				COKEY,
				STRSSPOOLID,
				STRSBATCHID,
				STRSJOBID
		   )       
			VALUES (
				@p_STRSDOCID, 
				SYSDATETIME(), 
				@p_BILLTYPE,
				@p_EMAILADDRESS,
				@p_SEGMENT, 
				@p_HTMLFILE, 
				@p_IMAGEFILE, 
				@p_CSVFILE,	
				@p_INVOICELLINK,
				@p_COKEY,
				@p_STRSSPOOLID,
				'not initialized',
				@p_STRSJOBID
				) 
		END
END
GO

GRANT EXECUTE ON SP_INSERT_EBILL_DETAILS TO StrsSolutionDB
GO