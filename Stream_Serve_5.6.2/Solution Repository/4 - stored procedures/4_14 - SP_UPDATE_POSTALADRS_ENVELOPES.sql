

DROP PROCEDURE SP_UPDATE_POSTALADRS_ENVELOPES
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
-- Modified by Don Orazulume
-- Changed to handle residential invoice co-enveloping by batchdate, all other doc types will use docid and rownumber combo
-- Last Modified date: 2017 03 11
-- Description:	Update PostalAdrs table with envelope ids
-- =============================================

CREATE PROCEDURE [dbo].[SP_UPDATE_POSTALADRS_ENVELOPES]
 @p_STRSBATCHDATE VARCHAR(20)	
AS

BEGIN

	UPDATE a
		SET a.STRSENVELOPEID = b.newSTRSENVELOPEID
		FROM TAB_STRSPOSTALADRS a INNER JOIN 
			(SELECT STRSDOCID, concat(@p_STRSBATCHDATE,'_',ROW_NUMBER() OVER (ORDER BY STRSDOCID), '_', STRSDOCID) AS newSTRSENVELOPEID
				FROM TAB_STRSPOSTALADRS WHERE STRSENVELOPEID = 'not initialized') b
			ON a.STRSDOCID = b.STRSDOCID
END

BEGIN
	UPDATE p
		SET p.STRSENVELOPEID = e.STRSENVELOPEID
		FROM    TAB_STRSPOSTALADRS p INNER JOIN TAB_STRSPOSTALADRS e 
			ON p.STRSCONCATADDRESS = e.STRSCONCATADDRESS
                       	where p.SORTCODE='INV_RSREG'
                        and p.strsbatchdate= @p_STRSBATCHDATE
                       	and e.strsbatchdate= p.strsbatchdate
			and e.SORTCODE= p.SORTCODE
			and e.BPNUMBER= p.BPNUMBER
	
END
begin
	update x
		set STRSMULTICOUPONFLAG = 'X'
		from TAB_STRSPOSTALADRS x INNER JOIN (select STRSENVELOPEID from 
						(select count(*) as total,STRSENVELOPEID from TAB_STRSPOSTALADRS where SORTCODE='INV_RSREG'
                        and strsbatchdate= @p_STRSBATCHDATE group by STRSENVELOPEID) z where z.total > 1 ) y
				ON x.STRSENVELOPEID= y.STRSENVELOPEID
end

GO


GRANT EXECUTE ON SP_UPDATE_POSTALADRS_ENVELOPES TO StrsSolutionDB
GO