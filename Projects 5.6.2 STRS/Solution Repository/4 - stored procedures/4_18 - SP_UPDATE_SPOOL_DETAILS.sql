
DROP PROCEDURE SP_UPDATE_SPOOL_DETAILS
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
-- Description:	Update Spool Details
-- =============================================
CREATE PROCEDURE SP_UPDATE_SPOOL_DETAILS	-- Add the parameters for the stored procedure here
	
	@p_STRSSPOOLID VARCHAR(20),	
	@p_TOTALDOCSENT INT,
	@p_SPOOLTITLE VARCHAR(50),	
	@p_STRSBATCHID VARCHAR(20),
	@p_STRSBATCHDATE VARCHAR(15),
	@p_STRSTRAILERJOBID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			UPDATE TAB_STRSSPOOL 
			SET 
				TRAILERRECEIVED = SYSDATETIME(),
				TOTALDOCSENT = @p_TOTALDOCSENT,
				SPOOLTITLE = @p_SPOOLTITLE,
				STRSBATCHID = @p_STRSBATCHID,
				STRSBATCHDATE = @p_STRSBATCHDATE,
				STRSTRAILERJOBID = @p_STRSTRAILERJOBID
			WHERE STRSSPOOLID  = @p_STRSSPOOLID                 
		END
		
		BEGIN
			UPDATE TAB_STRSINV 
			SET 
				STRSBATCHID = @p_STRSBATCHID,
				BATCHDATE = @p_STRSBATCHDATE
			WHERE STRSSPOOLID  = @p_STRSSPOOLID  

			UPDATE TAB_STRSPOSTALADRS
			SET
				STRSBATCHDATE = @p_STRSBATCHDATE
			WHERE	
				STRSDOCID IN (
				SELECT I.STRSDOCID
				FROM TAB_STRSINV I
				WHERE I.STRSSPOOLID  = @p_STRSSPOOLID
				)
		END
		
		BEGIN
			UPDATE TAB_STRSCORR 
			SET 
				STRSBATCHID = @p_STRSBATCHID,
				BATCHDATE = @p_STRSBATCHDATE
			WHERE STRSSPOOLID  = @p_STRSSPOOLID 

			UPDATE TAB_STRSPOSTALADRS
			SET
				STRSBATCHDATE = @p_STRSBATCHDATE
			WHERE	
				STRSDOCID IN (
				SELECT C.STRSDOCID
				FROM TAB_STRSCORR C
				WHERE C.STRSSPOOLID  = @p_STRSSPOOLID
				)
		END
		
		BEGIN
			UPDATE TAB_STRSEBILL 
			SET 
				STRSBATCHID = @p_STRSBATCHID
			WHERE STRSSPOOLID  = @p_STRSSPOOLID                 
		END
		
		BEGIN
			UPDATE TAB_STRSCOCM 
			SET 
				STRSBATCHID = @p_STRSBATCHID
			WHERE STRSSPOOLID  = @p_STRSSPOOLID                 
		END
END
GO

GRANT EXECUTE ON SP_UPDATE_SPOOL_DETAILS TO StrsSolutionDB
GO