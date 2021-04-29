
DROP PROCEDURE SP_INSERT_BATCH_DETAILS
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
-- Modifed date: 2017 02 28
-- Description:	Insert Batch Details
-- =============================================
CREATE PROCEDURE SP_INSERT_BATCH_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSBATCHID VARCHAR(20), 
	@p_BATCHTYPE VARCHAR(20),
	@p_BATCHDATE VARCHAR(8),
	@p_BATCHCYCLE VARCHAR(5),
	@p_SPOOLCOUNT INT,
	@p_TOTALDOCSSENT INT,
	@p_STRSJOBID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSBATCH (
				STRSBATCHID,
				BATCHTYPE,
				BATCHDATE,
				BATCHCYCLE,
				SPOOLCOUNT,
				TOTALDOCSSENT,
				DATETIMERECEIVED,
				STRSJOBID
		   )       
			VALUES (
				@p_STRSBATCHID, 
				@p_BATCHTYPE, 
				@p_BATCHDATE,
				@p_BATCHCYCLE,
				@p_SPOOLCOUNT,
				@p_TOTALDOCSSENT,
				SYSDATETIME(),
				@p_STRSJOBID
				) 
		END

END
GO

GRANT EXECUTE ON SP_INSERT_BATCH_DETAILS TO StrsSolutionDB
GO