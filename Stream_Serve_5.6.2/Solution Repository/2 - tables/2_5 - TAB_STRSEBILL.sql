

DROP INDEX	IX_TAB_STRSEBILL_STRSSPOOLID ON TAB_STRSEBILL,
			IX_TAB_STRSEBILL_STRSBATCHID ON TAB_STRSEBILL,
			IX_TAB_STRSEBILL_STRSJOBID ON TAB_STRSEBILL
GO

DROP TABLE TAB_STRSEBILL
GO

CREATE TABLE TAB_STRSEBILL
(	STRSDOCID VARCHAR(50) NOT NULL, 
	CREATEDATETIME DATETIME2, 
	BILLTYPE VARCHAR(20),
	EMAILADDRESS VARCHAR(250),
	SEGMENT INT,
	HTMLFILE VARCHAR(100), 
	IMAGEFILE VARCHAR(100), 
	CSVFILE	VARCHAR(100), 
	INVOICELLINK VARCHAR(100),
	COKEY VARCHAR(50),
	STRSEBILLEMAILJOBID INT, 
	STRSSPOOLID VARCHAR(20), 
	STRSBATCHID VARCHAR(20),
	STRSJOBID INT,
	CONSTRAINT PK_TAB_STRSEBILL_STRSDOCID
		PRIMARY KEY CLUSTERED (STRSDOCID ASC)
)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSEBILL_STRSSPOOLID
	ON TAB_STRSEBILL (STRSSPOOLID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSEBILL_STRSBATCHID
	ON TAB_STRSEBILL (STRSBATCHID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSEBILL_STRSJOBID
	ON TAB_STRSEBILL (STRSJOBID ASC)
GO

GRANT SELECT ON TAB_STRSEBILL TO StrsSolutionDB
GO