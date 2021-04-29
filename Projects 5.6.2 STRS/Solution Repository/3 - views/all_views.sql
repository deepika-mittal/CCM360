

DROP VIEW VW_BATCH_DETAIL
GO

CREATE VIEW VW_BATCH_DETAIL
AS 
	SELECT 
		b.STRSBATCHID,
		MAX(b.BATCHDATE) BATCHDATE,
		MAX(b.BATCHTYPE) BATCHTYPE,
		MAX(b.BATCHCYCLE) BATCHCYCLE,
		MAX(s.CREATEDATETIME) BATCH_LASTMODIFIED,
		COUNT(s.STRSSPOOLID) SPOOLCOUNT,
		MAX(b.SPOOLCOUNT) TRAILER_SPOOLCOUNT,
		(select count(*) from dbo.TAB_STRSCORR where STRSBATCHID = b.STRSBATCHID) CORR_TOTALDOCPROCESSED,
		(select count(*) from dbo.TAB_STRSINV where STRSBATCHID = b.STRSBATCHID) INV_TOTALDOCPROCESSED,
		MAX(b.TOTALDOCSSENT) TRAILER_TOTALDOCSENT,
		SUM(s.TOTALDOCSENT) SPOOL_TOTALDOCSENT,
		SUM(s.TOTALDOCPROCESSED) SPOOL_TOTALDOCPROCESSED,
		MAX(j.STRSJOBBEGIN) TRAILERRECEIVED,
		MIN(j.STRSINPUTFILE) TRAILERFILENAME,
		MAX(b.DATETIMECOMPLETE) BATCH_COMPLETE,
		DATEDIFF(mi, MAX(b.DATETIMERECEIVED), MAX(b.DATETIMECOMPLETE)) BATCH_DURATION_MM
	FROM 
		dbo.TAB_STRSBATCH AS b
			JOIN
		dbo.TAB_STRSSPOOL AS s
			ON b.STRSBATCHID = s.STRSBATCHID
			JOIN
		dbo.TAB_STRSJOBAUDIT AS j
			ON b.STRSJOBID = j.STRSJOBID
	GROUP BY
		b.STRSBATCHID
GO

GRANT SELECT ON VW_BATCH_DETAIL TO StrsSolutionDB
GO
DROP VIEW VW_EBILL_EMAIL
GO

CREATE VIEW VW_EBILL_EMAIL
AS 
	SELECT 
		b.STRSBATCHID, 
		b.BATCHDATE,
		e.BILLTYPE,
		e.SEGMENT,
		e.STRSDOCID,
		e.EMAILADDRESS,
		e.HTMLFILE,
		e.IMAGEFILE
	FROM dbo.TAB_STRSEBILL AS e
		JOIN dbo.TAB_STRSBATCH AS b ON e.STRSBATCHID = b.STRSBATCHID
GO

GRANT SELECT ON VW_EBILL_EMAIL TO StrsSolutionDB
GO
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

DROP VIEW VW_INV_MAIL_REPORT
GO

CREATE VIEW VW_INV_MAIL_REPORT
AS 
	SELECT 
		MMR.STRSAFPID,
		MAX(MMR.SORTCODE) SORTCODE, 
		COUNT(MMR.I_STRSDOCID) + COUNT(DISTINCT(MMR.C_STRSDOCID)) DOC_TABLE_COUNT,
		COUNT(DISTINCT(MMR.STRSENVELOPEID)) ENV_COUNT_DOCTYPE,
		SUM(MMR.PAGECOUNT) PAGECOUNT,
		SUM(MMR.SHEETCOUNT) SHEETCOUNT,
		MAX(MMR.AFPFILENAME) AFPFILENAME,
		MAX(MMR.TOTALDOCPROCESSED) AFP_TOTALDOCPROCESSED,
		(COUNT(MMR.I_STRSDOCID) + COUNT(DISTINCT(MMR.C_STRSDOCID)) ) - MAX(MMR.TOTALDOCPROCESSED) DOC_TABLE_AFP_DIFF,
		MAX(MMR.BEGINPSTRAYID) BEGINPSTRAYID,
		MAX(MMR.ENDPSTRAYID) ENDPSTRAYID,
		MAX(MMR.BEGINPSSEQUENCE) BEGINPSSEQUENCE,
		MAX(MMR.ENDPSSEQUENCE) ENDPSSEQUENCE,
		MAX(MMR.BATCHDATE) BATCHDATE,
		COUNT(CASE WHEN MMR.OTTFLAG = 'X' THEN 1 ElSE NULL END) OTT_COUNT
	FROM (	SELECT 
				I.STRSDOCID I_STRSDOCID,
				C.STRSDOCID C_STRSDOCID,
				P.SORTCODE SORTCODE,
				P.COPIES COPIES,
				P.PAGECOUNT PAGECOUNT,
				P.SHEETCOUNT SHEETCOUNT,
				P.WEIGHT WEIGHT,
				A.AFPFILENAME AFPFILENAME,
				A.TOTALDOCPROCESSED TOTALDOCPROCESSED,
				A.BEGINPSTRAYID BEGINPSTRAYID,
				A.ENDPSTRAYID ENDPSTRAYID,
				A.BEGINPSSEQUENCE BEGINPSSEQUENCE,
				A.ENDPSSEQUENCE ENDPSSEQUENCE,
				I.BATCHDATE BATCHDATE,
				I.STRSBATCHID STRSBATCHID,
				I.STRSSPOOLID STRSSPOOLID,
				P.STRSENVELOPEID STRSENVELOPEID,
				I.STRSAFPID	STRSAFPID,
				I.OTTFLAG OTTFLAG	
			FROM dbo.TAB_STRSINV AS I
				JOIN
			dbo.TAB_STRSPOSTALADRS AS P ON P.STRSDOCID = I.STRSDOCID
				JOIN
			dbo.TAB_STRSAFP AS A ON A.STRSAFPID = I.STRSAFPID
				LEFT JOIN
			dbo.TAB_STRSCORR AS C ON C.STRSAFPID = I.STRSAFPID
	) AS MMR
	GROUP BY MMR.STRSAFPID
GO

GRANT SELECT ON VW_INV_MAIL_REPORT TO StrsSolutionDB 
GO
DROP VIEW VW_CORR_MAIL_REPORT
GO

CREATE VIEW VW_CORR_MAIL_REPORT
AS 
	SELECT 
		MMR.STRSAFPID,
		MAX(MMR.SORTCODE) SORTCODE, 
		MMR.DOCUMENTTYPE,
		MAX(MMR.DOCUMENTTITLE) DOCUMENTTITLE,
		COUNT(MMR.STRSDOCID) DOC_COUNT,
		COUNT(DISTINCT(MMR.STRSENVELOPEID)) ENV_COUNT_DOCTYPE,
		SUM(MMR.PAGECOUNT) PAGECOUNT,
		SUM(MMR.SHEETCOUNT) SHEETCOUNT,
		MAX(MMR.AFPFILENAME) AFPFILENAME,
		MAX(MMR.TOTALDOCPROCESSED) AFP_TOTALDOCPROCESSED,
		MAX(MMR.BEGINPSTRAYID) BEGINPSTRAYID,
		MAX(MMR.ENDPSTRAYID) ENDPSTRAYID,
		MAX(MMR.BEGINPSSEQUENCE) BEGINPSSEQUENCE,
		MAX(MMR.ENDPSSEQUENCE) ENDPSSEQUENCE,
		MAX(MMR.BATCHDATE) BATCHDATE
	FROM (	SELECT 
				C.STRSDOCID STRSDOCID,
				C.DOCUMENTTYPE DOCUMENTTYPE,
				C.DOCUMENTTITLE DOCUMENTTITLE,
				P.SORTCODE SORTCODE,
				P.COPIES COPIES,
				P.PAGECOUNT PAGECOUNT,
				P.SHEETCOUNT SHEETCOUNT,
				P.WEIGHT WEIGHT,
				A.AFPFILENAME AFPFILENAME,
				A.TOTALDOCPROCESSED TOTALDOCPROCESSED,
				A.BEGINPSTRAYID BEGINPSTRAYID,
				A.ENDPSTRAYID ENDPSTRAYID,
				A.BEGINPSSEQUENCE BEGINPSSEQUENCE,
				A.ENDPSSEQUENCE ENDPSSEQUENCE,
				C.BATCHDATE BATCHDATE,
				C.STRSBATCHID STRSBATCHID,
				C.STRSSPOOLID STRSSPOOLID,
				P.STRSENVELOPEID STRSENVELOPEID,
				C.STRSAFPID	STRSAFPID	
			FROM dbo.TAB_STRSCORR AS C
				JOIN
			dbo.TAB_STRSPOSTALADRS AS P ON P.STRSDOCID = C.STRSDOCID
				JOIN
			dbo.TAB_STRSAFP AS A ON A.STRSAFPID = C.STRSAFPID
			WHERE P.SORTCODE != 'INV_RSREG'

	) AS MMR
	GROUP BY MMR.STRSAFPID, MMR.DOCUMENTTYPE
		
GO

GRANT SELECT ON VW_CORR_MAIL_REPORT TO StrsSolutionDB 
GO
DROP VIEW VW_NOTIFICATION_DETAIL
GO

CREATE VIEW VW_NOTIFICATION_DETAIL
AS 
	SELECT 
		 N.STRNOTIFICATIONID,
		 N.CREATEDATETIME,
		 N.NOTIFICATIONTYPE,
		 N.NOTIFICATIONCLASS,
		 N.BATCHDATE,
		 N.PROJECTNAME,
		 N.FUNCTIONCLASS,
		 N.FUNCTIONCNAME,
		 N.NOTIFICATION,
		 JA.STRSINPUTFILE,
		 JA.STRSINPUTCHANNEL,
		 JA.STRSNODEIP,
		 JA.STRSJOBSTATUS,
		 N.STRSJOBID,
		 JA.STRSSAVEFILE
	FROM dbo.TAB_STRSNOTIFICATIONS N 
		INNER JOIN dbo.TAB_STRSJOBAUDIT JA ON N.STRSJOBID = JA.STRSJOBID
GO

GRANT SELECT ON VW_NOTIFICATION_DETAIL TO StrsSolutionDB
GO