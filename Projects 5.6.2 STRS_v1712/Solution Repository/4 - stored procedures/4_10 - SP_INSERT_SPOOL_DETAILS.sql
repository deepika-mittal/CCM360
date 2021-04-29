
DROP PROCEDURE SP_INSERT_SPOOL_DETAILS
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
-- Modifed date: 2016 05 04
-- Description:	Insert Spool Details
-- =============================================
CREATE PROCEDURE SP_INSERT_SPOOL_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSSPOOLID VARCHAR(20), 
	@p_SPOOLTYPE VARCHAR(20),
	@p_TOTALDOCPROCESSED INT,
	@p_STRSSPOOOLJOBID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSSPOOL (
				STRSSPOOLID,
				SPOOLTYPE,
				CREATEDATETIME,
				TOTALDOCPROCESSED,
				STRSBATCHID,
				STRSBATCHDATE,
				STRSSPOOOLJOBID
		   )       
			VALUES (
				@p_STRSSPOOLID, 
				@p_SPOOLTYPE, 
				SYSDATETIME(),
				@p_TOTALDOCPROCESSED,
				'not initialized',
				'not initialized',
				@p_STRSSPOOOLJOBID
				) 
		END
END
GO

GRANT EXECUTE ON SP_INSERT_SPOOL_DETAILS TO StrsSolutionDB
GO