
DROP PROCEDURE SP_UPDATE_BATCH_DETAILS
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
-- Modifed date: 2016 05 27
-- Description:	Update BATCH Details
-- =============================================
CREATE PROCEDURE SP_UPDATE_BATCH_DETAILS	
	
	@p_STRSBATCHID VARCHAR(20)		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			UPDATE TAB_STRSBATCH 
			SET DATETIMECOMPLETE = SYSDATETIME()
			WHERE STRSBATCHID = @p_STRSBATCHID                 
		END
		
		BEGIN
			UPDATE TAB_STRSSPOOL
			SET COMPLETEDATETIME = SYSDATETIME()
			WHERE STRSBATCHID = @p_STRSBATCHID                 
		END
END
GO

GRANT EXECUTE ON SP_UPDATE_BATCH_DETAILS TO StrsSolutionDB
GO