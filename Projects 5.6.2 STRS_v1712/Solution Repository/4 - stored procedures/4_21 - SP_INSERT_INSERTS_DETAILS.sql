

DROP PROCEDURE SP_INSERT_INSERTS_DETAILS
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
-- Modifed date: 2016 07 13
-- Description:	Insert Inserts Details
-- =============================================
CREATE PROCEDURE SP_INSERT_INSERTS_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSINSERTID VARCHAR(80), 
	@p_INSERTDESCRIPTION VARCHAR(80),
	@p_INSERTWEIGHT DECIMAL(5,2),
	@p_BINNUMBER VARCHAR(10),
	@p_STRSDOCID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN				
			INSERT INTO TAB_STRSINSERTS (
				STRSINSERTID, 
				CREATEDATETIME,
				INSERTDESCRIPTION,
				INSERTWEIGHT,
				BINNUMBER,	
				STRSDOCID
				)
			VALUES (
				@p_STRSINSERTID,  
				SYSDATETIME(), 
				@p_INSERTDESCRIPTION, 	
				@p_INSERTWEIGHT, 
				@p_BINNUMBER, 
				@p_STRSDOCID
				)
		END 		
END
GO

GRANT EXECUTE ON SP_INSERT_INSERTS_DETAILS TO StrsSolutionDB
GO