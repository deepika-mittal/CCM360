

DROP PROCEDURE SP_INSERT_AFP_DETAILS
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
-- Modifed date: 2017 03 19
-- Description:	Insert AFP Details
-- =============================================
CREATE PROCEDURE SP_INSERT_AFP_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSAFPID VARCHAR(100), 
	@p_AFPFILENAME VARCHAR(80),
	@p_SORTCODE VARCHAR(10),
	@p_PLEX VARCHAR(10),
	@p_TOTALDOCPROCESSED INT, 
	@p_AFPFILEPATH VARCHAR(150),
	@p_BATCHDATE VARCHAR(8),
	@p_STRSSSORTFILEID VARCHAR(30),
	@p_STRSBATCHID VARCHAR(20),
	@p_STRSJOBID INT,
	@p_BEGINPSTRAYID INT,
	@p_ENDPSTRAYID INT,
	@p_BEGINPSSEQUENCE INT,
	@p_ENDPSSEQUENCE INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN				
			INSERT INTO TAB_STRSAFP (
				STRSAFPID, 
				AFPFILENAME,
				SORTCODE,
				PLEX,
				COMPLETEDATETIME,	
				TOTALDOCPROCESSED,
				AFPFILEPATH,
				BATCHDATE,
				STRSSSORTFILEID,
				STRSBATCHID,
				STRSJOBID,
				BEGINPSTRAYID,
				ENDPSTRAYID,
				BEGINPSSEQUENCE,
				ENDPSSEQUENCE
				)
			VALUES (
				@p_STRSAFPID,  
				@p_AFPFILENAME, 
				@p_SORTCODE, 	
				@p_PLEX, 
				SYSDATETIME(), 
				@p_TOTALDOCPROCESSED,
				@p_AFPFILEPATH,
				@p_BATCHDATE,
				@p_STRSSSORTFILEID,
				@p_STRSBATCHID,
				@p_STRSJOBID,
				@p_BEGINPSTRAYID,
				@p_ENDPSTRAYID,
				@p_BEGINPSSEQUENCE,
				@p_ENDPSSEQUENCE
				)
		END 	
END
GO

GRANT EXECUTE ON SP_INSERT_AFP_DETAILS TO StrsSolutionDB
GO