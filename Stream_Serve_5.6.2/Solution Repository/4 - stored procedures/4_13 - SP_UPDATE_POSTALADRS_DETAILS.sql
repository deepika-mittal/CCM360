
DROP PROCEDURE SP_UPDATE_POSTALADRS_DETAILS
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
-- Description:	Update PostalAdrs table with mailng address Details
-- =============================================
CREATE PROCEDURE SP_UPDATE_POSTALADRS_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSADRSID VARCHAR(50),
	@p_STRSDOCID VARCHAR(30),
	@p_STRSENVELOPEID VARCHAR(50),
	@p_MAILTYPE VARCHAR(10),	
	@p_FOREIGNADDRESS CHAR(1),
	@p_COPIES INT,
	@p_PAGECOUNT INT,
	@p_WEIGHT DECIMAL(5,2),
	@p_SCANLINE VARCHAR(60),
	@p_STRSSSORTFILEID VARCHAR(20)  	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- INTerfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			UPDATE TAB_STRSPOSTALADRS 
			SET 
				MAILTYPE = @p_MAILTYPE,
				FOREIGNADDRESS = @p_FOREIGNADDRESS,
				COPIES = @p_COPIES,
				PAGECOUNT = @p_PAGECOUNT,
				WEIGHT = @p_WEIGHT,
				SCANLINE = @p_SCANLINE,
				STRSENVELOPEID = @p_STRSENVELOPEID,
				STRSSSORTFILEID = @p_STRSSSORTFILEID
			WHERE STRSDOCID = @p_STRSDOCID 
				AND STRSADRSID = @p_STRSADRSID                 
		END
END
GO

GRANT EXECUTE ON SP_UPDATE_POSTALADRS_DETAILS TO StrsSolutionDB
GO