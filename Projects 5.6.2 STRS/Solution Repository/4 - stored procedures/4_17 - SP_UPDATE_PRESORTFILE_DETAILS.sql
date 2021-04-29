
DROP PROCEDURE SP_UPDATE_PRESORTFILE_DETAILS
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
-- Modifed date: 2016 03 15
-- Description:	Update PResortFile table with postal optimization file Details
-- =============================================
CREATE PROCEDURE SP_UPDATE_PRESORTFILE_DETAILS
	-- Add the parameters for the stored procedure here
		@p_STRSSSORTFILEID VARCHAR(80),
		@p_RECORDCOUNTRETURNED INT,
		@p_PROCESSCOMPLETE INT  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			UPDATE TAB_STRSPRESORTFILE
			SET
			 RECORDCOUNTRETURNED = @p_RECORDCOUNTRETURNED,
			 RETURNEDDATETIME = SYSDATETIME(),
			 DOCUPDENDDATETIME = SYSDATETIME(),
			 PROCESSCOMPLETE = @p_PROCESSCOMPLETE
			 WHERE STRSSSORTFILEID = @p_STRSSSORTFILEID
  		END
		
END
GO

GRANT EXECUTE ON SP_UPDATE_PRESORTFILE_DETAILS TO StrsSolutionDB
GO