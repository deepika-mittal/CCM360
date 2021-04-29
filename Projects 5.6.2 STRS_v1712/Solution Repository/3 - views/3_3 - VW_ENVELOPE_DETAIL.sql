
/**DROP INDEX	UIX_TAB_STRSINV_STRSENVELOPEID ON VW_ENVELOPE_DETAIL
GO
*/
DROP VIEW VW_ENVELOPE_DETAIL
GO

CREATE VIEW VW_ENVELOPE_DETAIL

AS 
	SELECT 
		CONCAT(row_number() OVER (ORDER BY PA.STRSCONCATADDRESS), '_', MAX(PA.DPZIP)) STRSENVELOPEID,
		MAX( REPLACE(I.DOCUMENTTYPE, 'ZSS', '') )INV_DOCUMENTTYPE,
		MAX( REPLACE(C.DOCUMENTTYPE, 'ZSS', '') ) CORR_DOCUMENTTYPE,
		PA.SORTCODE,
		MAX(PA.DPCUSTOMERNAME) DPCUSTOMERNAME,
		MAX(PA.DPATT) DPATT,
		MAX(PA.DPSECDADDR) DPSECDADDR,
		MAX(PA.DPADDRLINE1) DPADDRLINE1,
		MAX(PA.DPADDRLINE2) DPADDRLINE2,
		MAX(PA.DPZIP) DPZIP,
		MAX(PA.DPZIPEXT) DPZIPEXT,
		MAX(PA.DPCITY) DPCITY,
		MAX(PA.DPSTATE) DPSTATE,
		MAX(PA.DPCOUNTRY) DPCOUNTRY,
		( SELECT SUM(IRT.INSERTWEIGHT) FROM dbo.TAB_STRSINSERTS IRT WHERE IRT.STRSDOCID = MAX(I.STRSDOCID) OR IRT.STRSDOCID = MAX(C.STRSDOCID)  ) ENVELOPEWEIGHT,
		( SELECT CASE WHEN IRT.BINNUMBER = 1 THEN 'X' ELSE '' END FROM dbo.TAB_STRSINSERTS IRT WHERE IRT.BINNUMBER = 1 AND (IRT.STRSDOCID = MAX(I.STRSDOCID) OR IRT.STRSDOCID = MAX(C.STRSDOCID)) ) BIN_1,
		( SELECT CASE WHEN IRT.BINNUMBER = 2 THEN 'X' ELSE '' END FROM dbo.TAB_STRSINSERTS IRT WHERE IRT.BINNUMBER = 2 AND (IRT.STRSDOCID = MAX(I.STRSDOCID) OR IRT.STRSDOCID = MAX(C.STRSDOCID)) ) BIN_2,
		( SELECT CASE WHEN IRT.BINNUMBER = 3 THEN 'X' ELSE '' END FROM dbo.TAB_STRSINSERTS IRT WHERE IRT.BINNUMBER = 3 AND (IRT.STRSDOCID = MAX(I.STRSDOCID) OR IRT.STRSDOCID = MAX(C.STRSDOCID)) ) BIN_3,
		( SELECT CASE WHEN IRT.BINNUMBER = 4 THEN 'X' ELSE '' END FROM dbo.TAB_STRSINSERTS IRT WHERE IRT.BINNUMBER = 4 AND (IRT.STRSDOCID = MAX(I.STRSDOCID) OR IRT.STRSDOCID = MAX(C.STRSDOCID)) ) BIN_4,
		MAX(I.STRSBATCHID ) INV_BATCHID,
		MAX(C.STRSBATCHID ) CORR_BATCHID,
		MAX(PA.STRSSSORTFILEID) STRSSSORTFILEID,
		PA.STRSCONCATADDRESS
	FROM dbo.TAB_STRSPOSTALADRS PA
		LEFT JOIN dbo.TAB_STRSINV I ON I.STRSDOCID = PA.STRSDOCID
		LEFT JOIN dbo.TAB_STRSCORR C ON C.STRSDOCID = PA.STRSDOCID
	WHERE I.CHANNEL = 'document_broker' OR C.CHANNEL = 'document_broker'
	GROUP BY PA.STRSCONCATADDRESS, PA.SORTCODE
GO
/**
CREATE NONCLUSTERED INDEX UIX_TAB_STRSINV_STRSENVELOPEID
	ON VW_ENVELOPE_DETAIL (STRSENVELOPEID ASC)
GO
*/
GRANT SELECT ON VW_ENVELOPE_DETAIL TO StrsSolutionDB
GO