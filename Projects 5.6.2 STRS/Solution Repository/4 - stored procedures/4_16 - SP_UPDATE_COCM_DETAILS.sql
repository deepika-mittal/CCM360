
DROP PROCEDURE SP_UPDATE_COCM_DETAILS
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
-- Modifed date: 2016 04 12
-- Description:	Update COCM Details
-- =============================================
CREATE PROCEDURE SP_UPDATE_COCM_DETAILS	-- Add the parameters for the stored procedure here
	
	@p_STRSDOCID VARCHAR(50),	
	@p_HTTPRESPONSE VARCHAR(200) 	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			UPDATE TAB_STRSCOCM 
			SET HTTPRESPONSE = @p_HTTPRESPONSE
			WHERE STRSDOCID = @p_STRSDOCID                 
		END
END
GO

GRANT EXECUTE ON SP_UPDATE_COCM_DETAILS TO StrsSolutionDB
GO