--	TAB_STRSINV
DROP INDEX	IX_TAB_STRSINV_STRSAFPID ON TAB_STRSINV,
			IX_TAB_STRSINV_STRSSPOOLID ON TAB_STRSINV,
			IX_TAB_STRSINV_STRSBATCHID ON TAB_STRSINV,
			IX_TAB_STRSINV_STRSJOBID ON TAB_STRSINV,
			IX_TAB_STRSINV_CHANNEL ON TAB_STRSINV,
			IX_TAB_STRSINV_DOCUMENTTYPE ON TAB_STRSINV
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

--	TAB_STRSCORR
DROP INDEX	IX_TAB_STRSCORR_STRSAFPID ON TAB_STRSCORR,
			IX_TAB_STRSCORR_STRSSPOOLID ON TAB_STRSCORR,
			IX_TAB_STRSCORR_STRSBATCHID ON TAB_STRSCORR,
			IX_TAB_STRSCORR_STRSJOBID ON TAB_STRSCORR,
			IX_TAB_STRSCORR_CHANNEL ON TAB_STRSCORR,
			IX_TAB_STRSCORR_DOCUMENTTYPE ON TAB_STRSCORR
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSCORR_STRSAFPID
	ON TAB_STRSCORR (STRSAFPID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSCORR_STRSSPOOLID
	ON TAB_STRSCORR (STRSSPOOLID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSCORR_STRSBATCHID
	ON TAB_STRSCORR (STRSBATCHID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSCORR_STRSJOBID
	ON TAB_STRSCORR (STRSJOBID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSCORR_CHANNEL
	ON TAB_STRSCORR (CHANNEL ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSCORR_DOCUMENTTYPE
	ON TAB_STRSCORR (DOCUMENTTYPE ASC)
GO

--	TAB_STRSCOCM
DROP INDEX	IX_TAB_STRSCOCM_STRSSPOOLID ON TAB_STRSCOCM,
			IX_TAB_STRSCOCM_STRSBATCHID ON TAB_STRSCOCM,
			IX_TAB_STRSCOCM_STRSJOBID ON TAB_STRSCOCM
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSCOCM_STRSSPOOLID
	ON TAB_STRSCOCM (STRSSPOOLID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSCOCM_STRSBATCHID
	ON TAB_STRSCOCM (STRSBATCHID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSCOCM_STRSJOBID
	ON TAB_STRSCOCM (STRSJOBID ASC)
GO

--	TAB_STRSEBILL
DROP INDEX	IX_TAB_STRSEBILL_STRSSPOOLID ON TAB_STRSEBILL,
			IX_TAB_STRSEBILL_STRSBATCHID ON TAB_STRSEBILL,
			IX_TAB_STRSEBILL_STRSJOBID ON TAB_STRSEBILL
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

--	TAB_STRSPOSTALADRS
DROP INDEX	IX_TAB_STRSPOSTALADRS_STRSDOCID ON TAB_STRSPOSTALADRS,
			IX_TAB_STRSPOSTALADRS_STRSCONCATADDRESS ON TAB_STRSPOSTALADRS,
			IX_TAB_STRSPOSTALADRS_SORTCODE ON TAB_STRSPOSTALADRS,
			IX_TAB_STRSPOSTALADRS_STRSENVELOPEID ON TAB_STRSPOSTALADRS,
			IX_TAB_STRSPOSTALADRS_STRSSSORTFILEID ON TAB_STRSPOSTALADRS
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSPOSTALADRS_STRSDOCID
	ON TAB_STRSPOSTALADRS (STRSDOCID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSPOSTALADRS_STRSCONCATADDRESS
	ON TAB_STRSPOSTALADRS (STRSCONCATADDRESS ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSPOSTALADRS_SORTCODE
	ON TAB_STRSPOSTALADRS (SORTCODE ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSPOSTALADRS_STRSENVELOPEID
	ON TAB_STRSPOSTALADRS (STRSENVELOPEID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSPOSTALADRS_STRSSSORTFILEID
	ON TAB_STRSPOSTALADRS (STRSSSORTFILEID ASC)
GO

--	TAB_STRSPOSTALOPT
DROP INDEX	IX_TAB_STRSPOSTALOPT_STRSSSORTFILEID ON TAB_STRSPOSTALOPT,
			IX_TAB_STRSPOSTALOPT_STRSJOBID ON TAB_STRSPOSTALOPT
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSPOSTALOPT_STRSSSORTFILEID
	ON TAB_STRSPOSTALOPT (STRSSSORTFILEID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSPOSTALOPT_STRSJOBID
	ON TAB_STRSPOSTALOPT (STRSJOBID ASC)
GO

-- TAB_STRSPRESORTFILE
DROP INDEX	IX_TAB_STRSPRESORTFILE_STRSBATCHID ON TAB_STRSPRESORTFILE,
			IX_TAB_STRSPRESORTFILE_STRSJOBID ON TAB_STRSPRESORTFILE
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSPRESORTFILE_STRSBATCHID
	ON TAB_STRSPRESORTFILE (STRSBATCHID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSPRESORTFILE_STRSJOBID
	ON TAB_STRSPRESORTFILE (STRSJOBID ASC)

--	TAB_STRSNOTIFICATIONS
DROP INDEX	IX_TAB_STRSNOTIFICATIONS_STRSJOBID ON TAB_STRSNOTIFICATIONS
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSNOTIFICATIONS_STRSJOBID
	ON TAB_STRSNOTIFICATIONS (STRSJOBID ASC)
GO

--	TAB_STRSBATCH
DROP INDEX	IX_TAB_STRSBATCH_STRSJOBID ON TAB_STRSBATCH
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSBATCH_STRSJOBID
	ON TAB_STRSBATCH (STRSJOBID ASC)
GO

--	TAB_STRSSPOOL
DROP INDEX	IX_TAB_STRSSPOOL_STRSBATCHID ON TAB_STRSSPOOL,
			IX_TAB_STRSSPOOL_STRSTRAILERJOBID ON TAB_STRSSPOOL,
			IX_TAB_STRSSPOOL_STRSSPOOOLJOBID ON TAB_STRSSPOOL
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSSPOOL_STRSBATCHID
	ON TAB_STRSSPOOL (STRSBATCHID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSSPOOL_STRSTRAILERJOBID
	ON TAB_STRSSPOOL (STRSTRAILERJOBID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSSPOOL_STRSSPOOOLJOBID
	ON TAB_STRSSPOOL (STRSSPOOOLJOBID ASC)
GO

--	TAB_STRSPOSTPROCESSOR
DROP INDEX	IX_TAB_STRSPOSTPROCESSOR_STRSBATCHID ON TAB_STRSPOSTPROCESSOR,
			IX_TAB_STRSPOSTPROCESSOR_STRSJOBID ON TAB_STRSPOSTPROCESSOR
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSPOSTPROCESSOR_STRSBATCHID
	ON TAB_STRSPOSTPROCESSOR (STRSBATCHID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSPOSTPROCESSOR_STRSJOBID
	ON TAB_STRSPOSTPROCESSOR (STRSJOBID ASC)
	
--	TAB_STRSAFP
DROP INDEX	IX_TAB_STRSAFP_STRSSSORTFILEID ON TAB_STRSAFP,
			IX_TAB_STRSAFP_STRSBATCHID ON TAB_STRSAFP,
			IX_TAB_STRSAFP_STRSJOBID ON TAB_STRSAFP
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSAFP_STRSSSORTFILEID
	ON TAB_STRSAFP (STRSSSORTFILEID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSAFP_STRSBATCHID
	ON TAB_STRSAFP (STRSBATCHID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSAFP_STRSJOBID
	ON TAB_STRSAFP (STRSJOBID ASC)
GO

--	TAB_STRSINSERTS
DROP INDEX	IX_TAB_STRSINSERTS_STRSDOCID ON TAB_STRSINSERTS,
			IX_TAB_STRSINSERTS_BINNUMBER ON TAB_STRSINSERTS
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSINSERTS_STRSDOCID
	ON TAB_STRSINSERTS (STRSDOCID ASC)
GO

CREATE NONCLUSTERED INDEX IX_TAB_STRSINSERTS_BINNUMBER
	ON TAB_STRSINSERTS (BINNUMBER ASC)
GO