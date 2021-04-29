
DROP PROCEDURE SP_UPDATE_EBILL_DETAILS
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
CREATE PROCEDURE SP_UPDATE_EBILL_DETAILS
	-- Add the parameters for the stored procedure here
	@p_COKEY	VARCHAR(50),	
	@p_PROJECTNAME VARCHAR(50), 
	@p_SEGMENT INT,
	@p_HTMLFILE VARCHAR(80), 
	@p_IMAGEFILE VARCHAR(80), 
	@p_CSVFILE	VARCHAR(80),
	@p_STRSBATCHID VARCHAR(20),
	@p_STRSJOBID INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
		IF
			@p_PROJECTNAME = 'eb_dte_ebill'
			BEGIN
				UPDATE TAB_STRSEBILL 
				SET SEGMENT = @p_SEGMENT,
					HTMLFILE = @p_HTMLFILE,
					IMAGEFILE = @p_IMAGEFILE,
					CSVFILE = @p_CSVFILE,
					STRSJOBID = @p_STRSJOBID
				WHERE COKEY = @p_COKEY                 
			END
		ELSE IF
			@p_PROJECTNAME = 'eb_dte_ebills_email'
			BEGIN
				UPDATE TAB_STRSEBILL 
				SET STRSEBILLEMAILJOBID = @p_STRSJOBID
				WHERE STRSBATCHID = @p_STRSBATCHID                 
			END
		
END
GO

GRANT EXECUTE ON SP_UPDATE_EBILL_DETAILS TO StrsSolutionDB
GO