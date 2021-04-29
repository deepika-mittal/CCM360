
DROP PROCEDURE SP_INSERT_POSTALOPT_DETAILS
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
-- Modifed date: 2018 02 10
-- Description:	Insert PostalOpt table from Address Table
-- =============================================
CREATE PROCEDURE SP_INSERT_POSTALOPT_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSBATCHDATE VARCHAR(8)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- INTerfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSPOSTALOPT
           (
			   STRSENVELOPEID,
			   STRSBATCHDATE,
			   STRSMULTICOUPONFLAG
		   )
		SELECT  
			STRSENVELOPEID,
			STRSBATCHDATE,
			STRSMULTICOUPONFLAG 
		FROM TAB_STRSPOSTALADRS 
		WHERE STRSBATCHDATE = @p_STRSBATCHDATE
		END
		/**
		update a
			set a.STRSMULTICOUPONFLAG = b.STRSMULTICOUPONFLAG ,a.STRSBATCHDATE=b.STRSBATCHDATE
			from TAB_STRSPOSTALOPT a INNER JOIN TAB_STRSPOSTALADRS b
				ON a.STRSENVELOPEID= b.STRSENVELOPEID
 				where a.STRSENVELOPEID = @p_STRSENVELOPEID	
		*/
END
GO

GRANT EXECUTE ON SP_INSERT_POSTALOPT_DETAILS TO StrsSolutionDB
GO