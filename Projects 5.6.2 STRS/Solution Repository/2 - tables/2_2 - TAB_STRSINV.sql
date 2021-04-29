

DROP INDEX	IX_TAB_STRSINV_STRSAFPID ON TAB_STRSINV,
			IX_TAB_STRSINV_STRSSPOOLID ON TAB_STRSINV,
			IX_TAB_STRSINV_STRSBATCHID ON TAB_STRSINV,
			IX_TAB_STRSINV_STRSJOBID ON TAB_STRSINV,
			IX_TAB_STRSINV_CHANNEL ON TAB_STRSINV,
			IX_TAB_STRSINV_DOCUMENTTYPE ON TAB_STRSINV
GO

DROP TABLE TAB_STRSINV
GO
CREATE TABLE TAB_STRSINV
(	STRSDOCID VARCHAR(50) NOT NULL, 
	CREATEDATETIME DATETIME2, 
	DOCUMENTTYPE VARCHAR(20),
	DOCUMENTTITLE VARCHAR(150),
	ACCOUNTNUMBER VARCHAR(15),
	CUSTOMERNAME VARCHAR(50), 
	DOCUMENTDATE VARCHAR(10),
	BILLDUEDATE VARCHAR(10),	
	BILLTYPE VARCHAR(5),
	TOTALAMOUNTDUE VARCHAR(15),
	BILLFROMDATE VARCHAR(10),
	BILLTODATE VARCHAR(10),
	CHANNEL VARCHAR(25), 
	EBILL CHAR(1), 
	RESEND CHAR(1), 
	REPRINT CHAR(1),	
	STRSAFPID VARCHAR(100),
	STRSPPIDARCHIVE VARCHAR(20),
	STRSSPOOLID VARCHAR(20) NOT NULL, 
	STRSBATCHID VARCHAR(20),
	STRSJOBID INT NOT NULL,
	RICEFW VARCHAR(100),
	ADJREVFLAG CHAR(1),
	AUTOPAYFLAG CHAR(1),
	FIRSTFLAG CHAR(1),
	FINALFLAG CHAR(1),
	METERCHANGEFLAG CHAR(1),
	FREDBILLFLAG CHAR(1),
	SREDBILLFLAG CHAR(1),
	BANNERFLAG CHAR(1),
	BANNERCOKEY VARCHAR(40),
	BATCHDATE VARCHAR(15),
	GUID VARCHAR(40),
	LPCPRCNT VARCHAR(20),
	PASTDUEAMOUNT VARCHAR(15),
	REMINDERCODES VARCHAR(40),
	BADADDRESSFLAG CHAR(1),
	DONOTPRINTFLAG CHAR(1),
	EDIFLAG CHAR(1),
	BPNUMBER VARCHAR(12),
	MEMOFLAG CHAR(1),
	HPPFLAG CHAR(1),
	SENIORFLAG CHAR(1),
	LSPFLAG CHAR(1),
	BWBFLAG CHAR(1),
	PAFLAG CHAR(1),
	SPPFLAG CHAR(1),
	OTTFLAG CHAR(1)
	CONSTRAINT PK_TAB_STRSINV_STRSDOCID
		PRIMARY KEY CLUSTERED (STRSDOCID ASC)
)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSINV_STRSAFPID
	ON TAB_STRSINV (STRSAFPID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSINV_STRSSPOOLID
	ON TAB_STRSINV (STRSSPOOLID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSINV_STRSBATCHID
	ON TAB_STRSINV (STRSBATCHID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSINV_STRSJOBID
	ON TAB_STRSINV (STRSJOBID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSINV_CHANNEL
	ON TAB_STRSINV (CHANNEL ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSINV_DOCUMENTTYPE
	ON TAB_STRSINV (DOCUMENTTYPE ASC)
GO

GRANT SELECT ON TAB_STRSINV TO StrsSolutionDB
GO