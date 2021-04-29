

DROP PROCEDURE SP_UPDATE_AFP_ID
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
-- Author:          Don Orazulume
-- Modified date:     2017 03 29
-- Description:     Update AFP ID in TAB_STRSINV & TAB_STRSCORR & TAB_STRSPOSTALOPT
-- =============================================
CREATE PROCEDURE SP_UPDATE_AFP_ID
     -- Add the parameters for the stored procedure here
     @p_STRSDOCID VARCHAR(35), 
     @p_STRSAFPID VARCHAR(100),
     @p_SORTCODE VARCHAR(10)
AS
BEGIN
     -- SET NOCOUNT ON added to prevent extra result sets from
     -- interfering with SELECT statements.
     SET NOCOUNT ON

		IF @p_SORTCODE IN ('COR_DUPLX', 'COR_REGUR', 'COR_RESND', 'COR_OVWG', 'COR_DUPRE', 'COR_HPP', 'COR_DIVERT', 'COR_POSTC') 
			BEGIN                
				UPDATE TAB_STRSCORR SET STRSAFPID = @p_STRSAFPID 
				WHERE STRSDOCID = @p_STRSDOCID
			END
		ELSE IF  @p_SORTCODE IN ('INV_RSDIV', 'INV_EBILL', 'INV_COLIV', 'INV_RSREG', 'INV_OVWG', 'INV_RSOVWG', 'INV_SHOFF', 'INV_SHODIV', 'INV_SHOVWG', 'INV_CMREG')
            IF LEN(@p_STRSDOCID) > 20
				BEGIN                
					UPDATE TAB_STRSCORR SET STRSAFPID = @p_STRSAFPID 
					WHERE STRSDOCID = @p_STRSDOCID
				END
			ELSE
				BEGIN
					UPDATE TAB_STRSINV SET STRSAFPID = @p_STRSAFPID 
					WHERE STRSDOCID = @p_STRSDOCID
				END   
		
		BEGIN
			UPDATE TAB_STRSPOSTALOPT
			SET SORTCODE = @p_SORTCODE,
				STRSAFPID = @p_STRSAFPID
			WHERE STRSENVELOPEID IN (
				SELECT STRSENVELOPEID 
				FROM TAB_STRSPOSTALADRS
				WHERE STRSDOCID = @p_STRSDOCID
				)	
		END
END
GO

GRANT EXECUTE ON SP_UPDATE_AFP_ID TO StrsSolutionDB
GO
