

DROP PROCEDURE SP_UPDATE_POSTALADRS_SORTCODE
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
-- Modifed date: 2016 07 25
-- Description:	Update PostalAdrs table with new sort code
-- =============================================
CREATE PROCEDURE SP_UPDATE_POSTALADRS_SORTCODE

	@p_STRSDOCID VARCHAR(30),
	@p_SORTCODE VARCHAR(10)

AS
BEGIN

	IF @p_STRSDOCID = 'set_over_weights'

		UPDATE PA
		SET PA.SORTCODE = SUBSTRING(PA.SORTCODE, 1, 4) + @p_SORTCODE
		FROM TAB_STRSPOSTALADRS PA INNER JOIN VW_ENVELOPE_DETAIL E
			ON PA.STRSENVELOPEID = E.STRSENVELOPEID
		WHERE E.ENVELOPEWEIGHT >  2
		
	ELSE
	
		UPDATE TAB_STRSPOSTALADRS
		SET SORTCODE = @p_SORTCODE
		WHERE STRSDOCID = @p_STRSDOCID
	
END 
GO

GRANT EXECUTE ON SP_UPDATE_POSTALADRS_SORTCODE TO StrsSolutionDB
GO