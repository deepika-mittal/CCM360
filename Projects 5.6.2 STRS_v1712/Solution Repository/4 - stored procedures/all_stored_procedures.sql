
DROP PROCEDURE SP_JOB_AUDIT_BEGIN
go

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
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE SP_JOB_AUDIT_BEGIN
	-- Add the parameters for the stored procedure here
	@p_STRSJOBID INT,
	@p_STRSPROJECTNAME VARCHAR(40),
	@p_STRSINPUTFILE VARCHAR(80), 
	@p_STRSINPUTCHANNEL VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

    -- Insert statements for procedure here
	INSERT INTO TAB_STRSJOBAUDIT (
				STRSJOBID,
				STRSPROJECTNAME,
				STRSINPUTFILE,
				STRSSAVEFILE,
				STRSJOBBEGIN,  -- dynamic
				STRSINPUTCHANNEL,
				STRSJOBSTATUS,
				STRSNODENAME,  -- dynamic
				STRSNODEIP
				)       
			VALUES (
				@p_STRSJOBID,
				@p_STRSPROJECTNAME,
				@p_STRSINPUTFILE,
				'not initialized',
				SYSDATETIME(),   -- dynamic
				@p_STRSINPUTCHANNEL,
				'in progress',
				HOST_NAME(),  -- dynamic
				cast(CONNECTIONPROPERTY('client_net_address') as VARCHAR)
				)  
END
GO

GRANT EXECUTE ON SP_JOB_AUDIT_BEGIN TO StrsSolutionDB
GO
DROP PROCEDURE SP_INSERT_SPOOL_DETAILS
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
-- Modifed date: 2016 05 04
-- Description:	Insert Spool Details
-- =============================================
CREATE PROCEDURE SP_INSERT_SPOOL_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSSPOOLID VARCHAR(20), 
	@p_SPOOLTYPE VARCHAR(20),
	@p_TOTALDOCPROCESSED INT,
	@p_STRSSPOOOLJOBID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSSPOOL (
				STRSSPOOLID,
				SPOOLTYPE,
				CREATEDATETIME,
				TOTALDOCPROCESSED,
				STRSBATCHID,
				STRSBATCHDATE,
				STRSSPOOOLJOBID
		   )       
			VALUES (
				@p_STRSSPOOLID, 
				@p_SPOOLTYPE, 
				SYSDATETIME(),
				@p_TOTALDOCPROCESSED,
				'not initialized',
				'not initialized',
				@p_STRSSPOOOLJOBID
				) 
		END
END
GO

GRANT EXECUTE ON SP_INSERT_SPOOL_DETAILS TO StrsSolutionDB
GO
DROP PROCEDURE SP_INSERT_BATCH_DETAILS
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
-- Modifed date: 2017 02 28
-- Description:	Insert Batch Details
-- =============================================
CREATE PROCEDURE SP_INSERT_BATCH_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSBATCHID VARCHAR(20), 
	@p_BATCHTYPE VARCHAR(20),
	@p_BATCHDATE VARCHAR(8),
	@p_BATCHCYCLE VARCHAR(5),
	@p_SPOOLCOUNT INT,
	@p_TOTALDOCSSENT INT,
	@p_STRSJOBID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSBATCH (
				STRSBATCHID,
				BATCHTYPE,
				BATCHDATE,
				BATCHCYCLE,
				SPOOLCOUNT,
				TOTALDOCSSENT,
				DATETIMERECEIVED,
				STRSJOBID
		   )       
			VALUES (
				@p_STRSBATCHID, 
				@p_BATCHTYPE, 
				@p_BATCHDATE,
				@p_BATCHCYCLE,
				@p_SPOOLCOUNT,
				@p_TOTALDOCSSENT,
				SYSDATETIME(),
				@p_STRSJOBID
				) 
		END

END
GO

GRANT EXECUTE ON SP_INSERT_BATCH_DETAILS TO StrsSolutionDB
GO
DROP PROCEDURE SP_UPDATE_EBILL_DETAILS
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
-- Modifed date: 2016 03 14
-- Description:	Insert EBILL Details
-- =============================================
CREATE PROCEDURE SP_UPDATE_EBILL_DETAILS
	-- Add the parameters for the stored procedure here
	@p_COKEY	VARCHAR(50),	
	@p_PROJECTNAME VARCHAR(50), 
	@p_SEGMENT INT,
	@p_HTMLFILE VARCHAR(80), 
	@p_IMAGEFILE VARCHAR(80), 
	@p_CSVFILE	VARCHAR(80),
	@p_STRSBATCHID VARCHAR(20),
	@p_STRSJOBID INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
		IF
			@p_PROJECTNAME = 'eb_dte_ebill'
			BEGIN
				UPDATE TAB_STRSEBILL 
				SET SEGMENT = @p_SEGMENT,
					HTMLFILE = @p_HTMLFILE,
					IMAGEFILE = @p_IMAGEFILE,
					CSVFILE = @p_CSVFILE,
					STRSJOBID = @p_STRSJOBID
				WHERE COKEY = @p_COKEY                 
			END
		ELSE IF
			@p_PROJECTNAME = 'eb_dte_ebills_email'
			BEGIN
				UPDATE TAB_STRSEBILL 
				SET STRSEBILLEMAILJOBID = @p_STRSJOBID
				WHERE STRSBATCHID = @p_STRSBATCHID                 
			END
		
END
GO

GRANT EXECUTE ON SP_UPDATE_EBILL_DETAILS TO StrsSolutionDB
GO
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
DROP PROCEDURE SP_UPDATE_COCM_DETAILS
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
-- Modifed date: 2016 04 12
-- Description:	Update COCM Details
-- =============================================
CREATE PROCEDURE SP_UPDATE_COCM_DETAILS	-- Add the parameters for the stored procedure here
	
	@p_STRSDOCID VARCHAR(50),	
	@p_HTTPRESPONSE VARCHAR(200) 	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			UPDATE TAB_STRSCOCM 
			SET HTTPRESPONSE = @p_HTTPRESPONSE
			WHERE STRSDOCID = @p_STRSDOCID                 
		END
END
GO

GRANT EXECUTE ON SP_UPDATE_COCM_DETAILS TO StrsSolutionDB
GO
DROP PROCEDURE SP_UPDATE_PRESORTFILE_DETAILS
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
-- Description:	Update PResortFile table with postal optimization file Details
-- =============================================
CREATE PROCEDURE SP_UPDATE_PRESORTFILE_DETAILS
	-- Add the parameters for the stored procedure here
		@p_STRSSSORTFILEID VARCHAR(80),
		@p_RECORDCOUNTRETURNED INT,
		@p_PROCESSCOMPLETE INT  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			UPDATE TAB_STRSPRESORTFILE
			SET
			 RECORDCOUNTRETURNED = @p_RECORDCOUNTRETURNED,
			 RETURNEDDATETIME = SYSDATETIME(),
			 DOCUPDENDDATETIME = SYSDATETIME(),
			 PROCESSCOMPLETE = @p_PROCESSCOMPLETE
			 WHERE STRSSSORTFILEID = @p_STRSSSORTFILEID
  		END
		
END
GO

GRANT EXECUTE ON SP_UPDATE_PRESORTFILE_DETAILS TO StrsSolutionDB
GO
DROP PROCEDURE SP_UPDATE_SPOOL_DETAILS
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
-- Modifed date: 2017 01 27
-- Description:	Update Spool Details
-- =============================================
CREATE PROCEDURE SP_UPDATE_SPOOL_DETAILS	-- Add the parameters for the stored procedure here
	
	@p_STRSSPOOLID VARCHAR(20),	
	@p_TOTALDOCSENT INT,
	@p_SPOOLTITLE VARCHAR(50),	
	@p_STRSBATCHID VARCHAR(20),
	@p_STRSBATCHDATE VARCHAR(15),
	@p_STRSTRAILERJOBID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			UPDATE TAB_STRSSPOOL 
			SET 
				TRAILERRECEIVED = SYSDATETIME(),
				TOTALDOCSENT = @p_TOTALDOCSENT,
				SPOOLTITLE = @p_SPOOLTITLE,
				STRSBATCHID = @p_STRSBATCHID,
				STRSBATCHDATE = @p_STRSBATCHDATE,
				STRSTRAILERJOBID = @p_STRSTRAILERJOBID
			WHERE STRSSPOOLID  = @p_STRSSPOOLID                 
		END
		
		BEGIN
			UPDATE TAB_STRSINV 
			SET 
				STRSBATCHID = @p_STRSBATCHID,
				BATCHDATE = @p_STRSBATCHDATE
			WHERE STRSSPOOLID  = @p_STRSSPOOLID  

			UPDATE TAB_STRSPOSTALADRS
			SET
				STRSBATCHDATE = @p_STRSBATCHDATE
			WHERE	
				STRSDOCID IN (
				SELECT I.STRSDOCID
				FROM TAB_STRSINV I
				WHERE I.STRSSPOOLID  = @p_STRSSPOOLID
				)
		END
		
		BEGIN
			UPDATE TAB_STRSCORR 
			SET 
				STRSBATCHID = @p_STRSBATCHID,
				BATCHDATE = @p_STRSBATCHDATE
			WHERE STRSSPOOLID  = @p_STRSSPOOLID 

			UPDATE TAB_STRSPOSTALADRS
			SET
				STRSBATCHDATE = @p_STRSBATCHDATE
			WHERE	
				STRSDOCID IN (
				SELECT C.STRSDOCID
				FROM TAB_STRSCORR C
				WHERE C.STRSSPOOLID  = @p_STRSSPOOLID
				)
		END
		
		BEGIN
			UPDATE TAB_STRSEBILL 
			SET 
				STRSBATCHID = @p_STRSBATCHID
			WHERE STRSSPOOLID  = @p_STRSSPOOLID                 
		END
		
		BEGIN
			UPDATE TAB_STRSCOCM 
			SET 
				STRSBATCHID = @p_STRSBATCHID
			WHERE STRSSPOOLID  = @p_STRSSPOOLID                 
		END
END
GO

GRANT EXECUTE ON SP_UPDATE_SPOOL_DETAILS TO StrsSolutionDB
GO
DROP PROCEDURE SP_UPDATE_BATCH_DETAILS
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
-- Modifed date: 2016 05 27
-- Description:	Update BATCH Details
-- =============================================
CREATE PROCEDURE SP_UPDATE_BATCH_DETAILS	
	
	@p_STRSBATCHID VARCHAR(20)		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			UPDATE TAB_STRSBATCH 
			SET DATETIMECOMPLETE = SYSDATETIME()
			WHERE STRSBATCHID = @p_STRSBATCHID                 
		END
		
		BEGIN
			UPDATE TAB_STRSSPOOL
			SET COMPLETEDATETIME = SYSDATETIME()
			WHERE STRSBATCHID = @p_STRSBATCHID                 
		END
END
GO

GRANT EXECUTE ON SP_UPDATE_BATCH_DETAILS TO StrsSolutionDB
GO
DROP PROCEDURE SP_JOB_AUDIT_END
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
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE SP_JOB_AUDIT_END
	-- Add the parameters for the stored procedure here
	@p_STRSJOBID INT,
	@p_STRSJOBSTATUS VARCHAR(50),
	@p_STRSSAVEFILE VARCHAR(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	UPDATE TAB_STRSJOBAUDIT
	SET STRSJOBEND = SYSDATETIME(),
		STRSSAVEFILE = @p_STRSSAVEFILE,
	    STRSJOBSTATUS = @p_STRSJOBSTATUS
	WHERE STRSJOBID = @p_STRSJOBID
	
END
GO

GRANT EXECUTE ON SP_JOB_AUDIT_END TO StrsSolutionDB
GO
DROP PROCEDURE SP_INSERT_POSTALADRS_DETAILS
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
-- Modifed date: 2017 02 28
-- Description:	Insert Postal Address Details 
-- =============================================
CREATE PROCEDURE SP_INSERT_POSTALADRS_DETAILS
	-- Add the parameters for the stored procedure here
	 
	@p_STRSADRSID VARCHAR(20),  
	@p_MAILTYPE VARCHAR(10), 
	@p_SORTCODE VARCHAR(10),
	@p_DPCUSTOMERNAME VARCHAR(50), 	
	@p_DPATT VARCHAR(50), 
	@p_DPSECDADDR VARCHAR(50),
	@p_DPADDRLINE1 VARCHAR(50), 
	@p_DPADDRLINE2 VARCHAR(50),  
	@p_DPZIP VARCHAR(5),
	@p_DPZIPEXT VARCHAR(10),
	@p_DPCITY VARCHAR(40),
	@p_DPSTATE VARCHAR(5), 
	@p_DPCOUNTRY VARCHAR(20),
	@p_FOREIGNADDRESS CHAR(1),
	@p_COPIES INT,	
	@p_PAGECOUNT INT,
	@p_SHEETCOUNT INT,
	@p_WEIGHT DECIMAL(5,2),
	@p_SCANLINE VARCHAR(60),
	@p_STRSDOCID VARCHAR(35),
	@p_BPNUMBER VARCHAR(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
			BEGIN

			INSERT INTO TAB_STRSPOSTALADRS (
				STRSADRSID,
				MAILTYPE,
				SORTCODE,
				DPCUSTOMERNAME,
				DPATT,
				DPSECDADDR,
				DPADDRLINE1, 
				DPADDRLINE2,
				DPZIP,
				DPZIPEXT,
				DPCITY,
				DPSTATE, 
				DPCOUNTRY,
				FOREIGNADDRESS,
				COPIES,
				PAGECOUNT,
				SHEETCOUNT,
				WEIGHT,
				SCANLINE,
				STRSDOCID,
				STRSCONCATADDRESS,
				STRSENVELOPEID,
				STRSSSORTFILEID,
				STRSBATCHDATE,
				BPNUMBER
				)       
			VALUES (
				@p_STRSADRSID,  
				@p_MAILTYPE, 
				@p_SORTCODE,
				@p_DPCUSTOMERNAME, 	
				@p_DPATT,
				@p_DPSECDADDR,
				@p_DPADDRLINE1, 
				@p_DPADDRLINE2,  
				@p_DPZIP,
				@p_DPZIPEXT,
				@p_DPCITY,
				@p_DPSTATE, 
				@p_DPCOUNTRY,
				@p_FOREIGNADDRESS,
				@p_COPIES,	
				@p_PAGECOUNT,
				@p_SHEETCOUNT,
				@p_WEIGHT,
				@p_SCANLINE,
				@p_STRSDOCID,
				CONCAT(UPPER(@p_DPCUSTOMERNAME), UPPER(@p_DPATT), UPPER(@p_DPSECDADDR), UPPER(@p_DPADDRLINE1), UPPER(@p_DPADDRLINE2), UPPER(@p_DPZIP), UPPER(@p_DPZIPEXT), UPPER(@p_DPCITY), UPPER(@p_DPSTATE), UPPER(@p_DPCOUNTRY)),
				'not initialized',
				'not initialized',
				'not initialized',
				@p_BPNUMBER
			) 
		END
END
GO

GRANT EXECUTE ON SP_INSERT_POSTALADRS_DETAILS TO StrsSolutionDB
GO

DROP PROCEDURE SP_INSERT_INSERTS_DETAILS
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
-- Description:	Insert Inserts Details
-- =============================================
CREATE PROCEDURE SP_INSERT_INSERTS_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSINSERTID VARCHAR(80), 
	@p_INSERTDESCRIPTION VARCHAR(80),
	@p_INSERTWEIGHT DECIMAL(5,2),
	@p_BINNUMBER VARCHAR(10),
	@p_STRSDOCID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN				
			INSERT INTO TAB_STRSINSERTS (
				STRSINSERTID, 
				CREATEDATETIME,
				INSERTDESCRIPTION,
				INSERTWEIGHT,
				BINNUMBER,	
				STRSDOCID
				)
			VALUES (
				@p_STRSINSERTID,  
				SYSDATETIME(), 
				@p_INSERTDESCRIPTION, 	
				@p_INSERTWEIGHT, 
				@p_BINNUMBER, 
				@p_STRSDOCID
				)
		END 		
END
GO

GRANT EXECUTE ON SP_INSERT_INSERTS_DETAILS TO StrsSolutionDB
GO

DROP PROCEDURE SP_INSERT_AFP_DETAILS
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
-- Modifed date: 2017 03 19
-- Description:	Insert AFP Details
-- =============================================
CREATE PROCEDURE SP_INSERT_AFP_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSAFPID VARCHAR(100), 
	@p_AFPFILENAME VARCHAR(80),
	@p_SORTCODE VARCHAR(10),
	@p_PLEX VARCHAR(10),
	@p_TOTALDOCPROCESSED INT, 
	@p_AFPFILEPATH VARCHAR(150),
	@p_BATCHDATE VARCHAR(8),
	@p_STRSSSORTFILEID VARCHAR(30),
	@p_STRSBATCHID VARCHAR(20),
	@p_STRSJOBID INT,
	@p_BEGINPSTRAYID INT,
	@p_ENDPSTRAYID INT,
	@p_BEGINPSSEQUENCE INT,
	@p_ENDPSSEQUENCE INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN				
			INSERT INTO TAB_STRSAFP (
				STRSAFPID, 
				AFPFILENAME,
				SORTCODE,
				PLEX,
				COMPLETEDATETIME,	
				TOTALDOCPROCESSED,
				AFPFILEPATH,
				BATCHDATE,
				STRSSSORTFILEID,
				STRSBATCHID,
				STRSJOBID,
				BEGINPSTRAYID,
				ENDPSTRAYID,
				BEGINPSSEQUENCE,
				ENDPSSEQUENCE
				)
			VALUES (
				@p_STRSAFPID,  
				@p_AFPFILENAME, 
				@p_SORTCODE, 	
				@p_PLEX, 
				SYSDATETIME(), 
				@p_TOTALDOCPROCESSED,
				@p_AFPFILEPATH,
				@p_BATCHDATE,
				@p_STRSSSORTFILEID,
				@p_STRSBATCHID,
				@p_STRSJOBID,
				@p_BEGINPSTRAYID,
				@p_ENDPSTRAYID,
				@p_BEGINPSSEQUENCE,
				@p_ENDPSSEQUENCE
				)
		END 	
END
GO

GRANT EXECUTE ON SP_INSERT_AFP_DETAILS TO StrsSolutionDB
GO
DROP PROCEDURE SP_UPDATE_POSTALADRS_OVWG
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
-- Modifed date: 2016 11 21
-- Description:	Update Postaladrs table for overweights

USE [StrsSolutionDB]
GO

/****** Object:  StoredProcedure [dbo].[SP_UPDATE_POSTALADRS_OVWG]    Script Date: 3/21/2017 10:44:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Glenn Heying
-- Modifed date: 2017 03 21
-- Description:	Update Postaladrs table for overweights
-- Changed to send envelopes with 4 sheets or more to overweight file

CREATE PROCEDURE [dbo].[SP_UPDATE_POSTALADRS_OVWG]
	@p_STRSBATCHDATE VARCHAR(10)
AS
BEGIN
	Declare    
	@p_STRSENVELOPEID varchar(50),
	@pCounter int	
	--select distinct STRSENVELOPEID from dbo.TAB_STRSPOSTALADRS where strsbatchdate = @p_STRSBATCHDATE and SORTCODE in('INV_RSREG','INV_SHOFF')
	Declare EnvelopeId_Cursor cursor For

	select a.STRSENVELOPEID from 
	(select sum(sheetcount) as 'totalsheets',STRSENVELOPEID from dbo.TAB_STRSPOSTALADRS  where strsbatchdate = @p_STRSBATCHDATE and SORTCODE in('INV_RSREG','INV_SHOFF')
	 group by  STRSENVELOPEID) a 
	where a.totalsheets > 3		
	set @pCounter = 0
	OPEN EnvelopeId_Cursor 
	FETCH NEXT FROM EnvelopeId_Cursor INTO @p_STRSENVELOPEID
	While @@Fetch_Status = 0 Begin

		if(@pCounter > 1000)
		begin
			print ('@pCounter: ')
			print ( CONVERT(varchar(10), @pCounter))
		end
		print ('******************* OVERWEIGHT   ' +  @p_STRSENVELOPEID)
		update dbo.TAB_STRSPOSTALADRS set sortcode = SUBSTRING(sortcode, 1, 6)+'OVWG' where STRSENVELOPEID = @p_STRSENVELOPEID
	FETCH NEXT FROM EnvelopeId_Cursor INTO @p_STRSENVELOPEID

	End 
	Close EnvelopeId_Cursor
	Deallocate EnvelopeId_Cursor
END

GO



GRANT EXECUTE ON SP_UPDATE_POSTALADRS_OVWG TO StrsSolutionDB
GO
DROP PROCEDURE SP_UPDATE_POSTALOPT_DETAILS
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
-- Modifed date: 2017 02 10
-- Description:	Update PostalOpt table with return file Details
-- =============================================
CREATE PROCEDURE SP_UPDATE_POSTALOPT_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSENVELOPEID VARCHAR(50),
	@p_MAILTYPE VARCHAR(10),
	@p_DSCUSTOMERNAME VARCHAR(50),
	@p_DSATT VARCHAR(50),
	@p_DSSECDADDR VARCHAR(50),
	@p_DSADDRESSLINE1 VARCHAR(50),
	@p_DSADDRESSLINE2 VARCHAR(50),
	@p_DSZIP VARCHAR(10),
	@p_DSZIPEXT VARCHAR(10),
	@p_DSCITY VARCHAR(40),
	@p_DSSTATE VARCHAR(5),
	@p_DSCOUNTRY VARCHAR(20),	
	@p_DSDPVSTATUS INT,
	@p_DSROUTECODE VARCHAR(5),
	@p_DSMEMOIDN INT,
	@p_DSNCOAFLAG CHAR(1),
	@p_PSZIPMARK CHAR(1),
	@p_PSENDORSELINE VARCHAR(100),
	@p_PSOUTPUTCLASS VARCHAR(50),
	@p_PSIMBBARCODE VARCHAR(50),
	@p_PSTRAYID INT,
	@p_PSPALLETID INT,
	@p_PSSEQUENCE INT,
	@p_PSTRAYSIZE INT,
	@p_STRSSSORTFILEID VARCHAR(50),
	@p_STRSJOBID INT 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- INTerfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			UPDATE TAB_STRSPOSTALOPT
			SET  
			   MAILTYPE = @p_MAILTYPE,
			   DSCUSTOMERNAME = @p_DSCUSTOMERNAME,
			   DSATT = @p_DSATT,
			   DSSECDADDR = @p_DSSECDADDR,
			   DSADDRESSLINE1 = @p_DSADDRESSLINE1,
			   DSADDRESSLINE2 = @p_DSADDRESSLINE2,
			   DSZIP = @p_DSZIP,
			   DSZIPEXT = @p_DSZIPEXT,
			   DSCITY = @p_DSCITY,
			   DSSTATE = @p_DSSTATE,
			   DSCOUNTRY = @p_DSCOUNTRY,	
			   DSDPVSTATUS = @p_DSDPVSTATUS,
			   DSROUTECODE = @p_DSROUTECODE,
			   DSMEMOIDN = @p_DSMEMOIDN,
			   DSNCOAFLAG = @p_DSNCOAFLAG,
			   PSZIPMARK = @p_PSZIPMARK,
			   PSENDORSELINE = @p_PSENDORSELINE,
			   PSOUTPUTCLASS = @p_PSOUTPUTCLASS,
			   PSIMBBARCODE = @p_PSIMBBARCODE,
			   PSTRAYID = @p_PSTRAYID,
			   PSPALLETID = @p_PSPALLETID,
			   PSSEQUENCE = @p_PSSEQUENCE,
			   PSTRAYSIZE = @p_PSTRAYSIZE,
			   STRSSSORTFILEID = @p_STRSSSORTFILEID,
			   STRSJOBID = @p_STRSJOBID	
	               	WHERE STRSENVELOPEID = @p_STRSENVELOPEID		
		END
END
GO

GRANT EXECUTE ON SP_UPDATE_POSTALOPT_DETAILS TO StrsSolutionDB
GO




















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



DROP PROCEDURE SP_UPDATE_INVOICE_TO_TODAYS_BATCH_DATE
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
-- Author:          Glenn Heying
-- Modified date:     2017 03 15
-- Description:     Update batch date for the invoice docid to current batch date.
-- =============================================
CREATE PROCEDURE SP_UPDATE_INVOICE_TO_TODAYS_BATCH_DATE
     -- Add the parameters for the stored procedure here
     @p_STRSDOCID VARCHAR(35),
	 @p_STRSBATCHDATE VARCHAR(15)
AS
BEGIN
     -- SET NOCOUNT ON added to prevent extra result sets from
     -- interfering with SELECT statements.
     SET NOCOUNT ON

		BEGIN                
			UPDATE TAB_STRSINV SET BATCHDATE = @p_STRSBATCHDATE,REPRINT='X'  
             WHERE STRSDOCID = @p_STRSDOCID
        END    
		
		BEGIN                
			UPDATE TAB_STRSPOSTALADRS SET STRSBATCHDATE = @p_STRSBATCHDATE 
             WHERE STRSDOCID = @p_STRSDOCID
        END  
		BEGIN                
			 UPDATE p
				SET STRSBATCHDATE = @p_STRSBATCHDATE 
				FROM TAB_STRSPOSTALOPT p INNER JOIN TAB_STRSPOSTALADRS e 
				ON p.STRSENVELOPEID = e.STRSENVELOPEID
				where e.STRSDOCID = @p_STRSDOCID
        END  
END
GO

GRANT EXECUTE ON SP_UPDATE_INVOICE_TO_TODAYS_BATCH_DATE TO StrsSolutionDB
GO

DROP PROCEDURE SP_DELETE_EXPIRED_RECORDS
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
-- Modified date:   2017 03 28
-- Description:     DELETE records from StrsSolutionDB where TAB_STRSJOBAUDIT.STRSJOBBEGIN < given date
-- =============================================
CREATE PROCEDURE SP_DELETE_EXPIRED_RECORDS
     -- Add the parameters for the stored procedure here
     @p_DELETEDATE DATETIME2
AS	 
BEGIN
     -- SET NOCOUNT ON added to prevent extra result sets from
     -- interfering with SELECT statements.
     SET NOCOUNT ON
		
		DELETE FROM TAB_STRSINSERTS WHERE STRSDOCID
			IN (SELECT 	STRSDOCID 
				FROM 	TAB_STRSINV i JOIN TAB_STRSJOBAUDIT j ON j.STRSJOBID = i.STRSJOBID
				WHERE 	j.STRSJOBBEGIN < @p_DELETEDATE)
		
		DELETE FROM TAB_STRSINSERTS WHERE STRSDOCID
			IN (SELECT 	STRSDOCID 
				FROM 	TAB_STRSCORR i JOIN TAB_STRSJOBAUDIT j ON j.STRSJOBID = i.STRSJOBID
				WHERE 	j.STRSJOBBEGIN < @p_DELETEDATE)
		
		DELETE FROM TAB_STRSPOSTALADRS WHERE STRSDOCID
			IN (SELECT 	STRSDOCID 
				FROM 	TAB_STRSINV i JOIN TAB_STRSJOBAUDIT j ON j.STRSJOBID = i.STRSJOBID
				WHERE 	j.STRSJOBBEGIN < @p_DELETEDATE)
		
		DELETE FROM TAB_STRSPOSTALADRS WHERE STRSDOCID
			IN (SELECT 	STRSDOCID 
				FROM 	TAB_STRSCORR i JOIN TAB_STRSJOBAUDIT j ON j.STRSJOBID = i.STRSJOBID
				WHERE 	j.STRSJOBBEGIN < @p_DELETEDATE)
		
		DELETE FROM TAB_STRSINV WHERE STRSJOBID 
			IN (SELECT STRSJOBID FROM TAB_STRSJOBAUDIT WHERE STRSJOBBEGIN < @p_DELETEDATE)
			
		DELETE FROM TAB_STRSCORR WHERE STRSJOBID 
			IN (SELECT STRSJOBID FROM TAB_STRSJOBAUDIT WHERE STRSJOBBEGIN < @p_DELETEDATE)
			
		DELETE FROM TAB_STRSCOCM WHERE STRSJOBID 
			IN (SELECT STRSJOBID FROM TAB_STRSJOBAUDIT WHERE STRSJOBBEGIN < @p_DELETEDATE)
			
		DELETE FROM TAB_STRSEBILL WHERE STRSJOBID 
			IN (SELECT STRSJOBID FROM TAB_STRSJOBAUDIT WHERE STRSJOBBEGIN < @p_DELETEDATE)
			
		DELETE FROM TAB_STRSPOSTALOPT WHERE STRSJOBID 
			IN (SELECT STRSJOBID FROM TAB_STRSJOBAUDIT WHERE STRSJOBBEGIN < @p_DELETEDATE)
		
		DELETE FROM TAB_STRSPRESORTFILE WHERE STRSJOBID 
			IN (SELECT STRSJOBID FROM TAB_STRSJOBAUDIT WHERE STRSJOBBEGIN < @p_DELETEDATE)
			
		DELETE FROM TAB_STRSAFP WHERE STRSJOBID 
			IN (SELECT STRSJOBID FROM TAB_STRSJOBAUDIT WHERE STRSJOBBEGIN < @p_DELETEDATE)
			
		DELETE FROM TAB_STRSSPOOL WHERE STRSSPOOOLJOBID 
			IN (SELECT STRSJOBID FROM TAB_STRSJOBAUDIT WHERE STRSJOBBEGIN < @p_DELETEDATE)
			
		DELETE FROM TAB_STRSSPOOL WHERE STRSTRAILERJOBID 
			IN (SELECT STRSJOBID FROM TAB_STRSJOBAUDIT WHERE STRSJOBBEGIN < @p_DELETEDATE)
			
		DELETE FROM TAB_STRSBATCH WHERE STRSJOBID 
			IN (SELECT STRSJOBID FROM TAB_STRSJOBAUDIT WHERE STRSJOBBEGIN < @p_DELETEDATE)
		  
END
GO

GRANT EXECUTE ON SP_DELETE_EXPIRED_RECORDS TO StrsSolutionDB
GO

DROP PROCEDURE SP_INSERT_INVOICE_DETAILS
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
-- Modifed date: 2017 02 09
-- Description:	Insert Invoice Details
-- =============================================
CREATE PROCEDURE SP_INSERT_INVOICE_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSDOCID VARCHAR(35), 
	@p_DOCUMENTTYPE VARCHAR(20),
	@p_DOCUMENTTITLE VARCHAR(150),
	@p_ACCOUNTNUMBER VARCHAR(15),
	@p_CUSTOMERNAME VARCHAR(50), 
	@p_DOCUMENTDATE VARCHAR(10),

	@p_BILLDUEDATE VARCHAR(10),	
	@p_BILLTYPE VARCHAR(5),
	@p_TOTALAMOUNTDUE VARCHAR(15),
	@p_BILLFROMDATE VARCHAR(10),
	@p_BILLTODATE VARCHAR(10),
	
	@p_CHANNEL VARCHAR(25), 
	@p_EBILL CHAR(1), 
	@p_RESEND CHAR(1),
	@p_STRSSPOOLID VARCHAR(20),
	
	@p_STRSJOBID INT,		
	@p_STRSADRSID VARCHAR(20),  
	@p_MAILTYPE VARCHAR(10), 
	@p_SORTCODE VARCHAR(10),
	@p_DPCUSTOMERNAME VARCHAR(50), 	
	
	@p_DPATT VARCHAR(50), 
	@p_DPSECDADDR VARCHAR(50),
	@p_DPADDRLINE1 VARCHAR(50), 
	@p_DPADDRLINE2 VARCHAR(50),  
	@p_DPZIP VARCHAR(5),
	@p_DPZIPEXT VARCHAR(10),
	
	@p_DPCITY VARCHAR(40),
	@p_DPSTATE VARCHAR(5), 
	@p_DPCOUNTRY VARCHAR(20),
	@p_FOREIGNADDRESS CHAR(1),
	@p_COPIES INT,	
	
	@p_PAGECOUNT INT,
	@p_SHEETCOUNT INT,
	@p_WEIGHT DECIMAL(5,2),
	@p_SCANLINE VARCHAR(60),
	@p_RICEFW VARCHAR(100),

	@p_GUID VARCHAR(40),
	@p_LPCPRCNT VARCHAR(20),	
	@p_AUTOPAYFLAG CHAR(1),
	@p_PASTDUEAMOUNT VARCHAR(15),
	@p_REMINDERCODES VARCHAR(40),
	
	@p_FIRSTFLAG CHAR(1),
	@p_FINALFLAG CHAR(1),
	@p_METERCHANGEFLAG CHAR(1),
	@p_ADJREVFLAG CHAR(1),
	@p_FREDBILLFLAG CHAR(1),
	
	@p_SREDBILLFLAG CHAR(1),
	@p_BANNERFLAG CHAR(1),
	@p_BANNERCOKEY VARCHAR(40),
	@p_BADADDRESSFLAG CHAR(1),	
	@p_DONOTPRINTFLAG CHAR(1),

	@p_EDIFLAG CHAR(1),
	@p_BPNUMBER VARCHAR(12),
	@p_MEMOFLAG CHAR(1),
	@p_HPPFLAG CHAR(1),
	@p_SENIORFLAG CHAR(1),

	@p_LSPFLAG CHAR(1),
	@p_BWBFLAG CHAR(1),
	@p_PAFLAG CHAR(1),
	@p_SPPFLAG CHAR(1),
	@p_OTTFLAG CHAR(1)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSINV (
				STRSDOCID,
				CREATEDATETIME,
				DOCUMENTTYPE, 
				DOCUMENTTITLE,
				ACCOUNTNUMBER,
				CUSTOMERNAME,
				DOCUMENTDATE,
				BILLDUEDATE,
				BILLTYPE,
				TOTALAMOUNTDUE, 
				BILLFROMDATE,
				BILLTODATE,
				CHANNEL,
				RESEND,
				STRSAFPID,
				STRSPPIDARCHIVE,
				STRSSPOOLID,
				STRSBATCHID,
				STRSJOBID,
				EBILL,				
				RICEFW,
				ADJREVFLAG,
				AUTOPAYFLAG,
				FIRSTFLAG,
				FINALFLAG,
				METERCHANGEFLAG,
				FREDBILLFLAG ,
				SREDBILLFLAG ,
				BANNERFLAG,
				BANNERCOKEY,
				BATCHDATE,
				GUID,
				LPCPRCNT,
				PASTDUEAMOUNT,
				REMINDERCODES,
				BADADDRESSFLAG,
				DONOTPRINTFLAG,
				EDIFLAG,
				BPNUMBER,
				MEMOFLAG,
				HPPFLAG,
				SENIORFLAG,
				LSPFLAG,
				BWBFLAG,
				PAFLAG,
				SPPFLAG,
				OTTFLAG
				)       
			VALUES (
				@p_STRSDOCID, 
				SYSDATETIME(), 
				@p_DOCUMENTTYPE,
				@p_DOCUMENTTITLE,
				@p_ACCOUNTNUMBER,
				@p_CUSTOMERNAME, 
				@p_DOCUMENTDATE,
				@p_BILLDUEDATE,	
				@p_BILLTYPE,
				@p_TOTALAMOUNTDUE,
				@p_BILLFROMDATE,
				@p_BILLTODATE,
				@p_CHANNEL, 
				@p_RESEND,
				'not initialized',
				'not initialized',
				@p_STRSSPOOLID,
				'not initialized',	
				@p_STRSJOBID,
				@p_EBILL,
				@p_RICEFW,
				@p_ADJREVFLAG,
				@p_AUTOPAYFLAG,
				@p_FIRSTFLAG,
				@p_FINALFLAG ,
				@p_METERCHANGEFLAG,
				@p_FREDBILLFLAG,
				@p_SREDBILLFLAG,
				@p_BANNERFLAG,
				@p_BANNERCOKEY,
				'not initialized',
				@p_GUID,
				@p_LPCPRCNT,
				@p_PASTDUEAMOUNT,
				@p_REMINDERCODES,
				@p_BADADDRESSFLAG,	
				@p_DONOTPRINTFLAG,
				@p_EDIFLAG,
				@p_BPNUMBER,
				@p_MEMOFLAG,
				@p_HPPFLAG,
				@p_SENIORFLAG,
				@p_LSPFLAG,
				@p_BWBFLAG,
				@p_PAFLAG,
				@p_SPPFLAG,
				@p_OTTFLAG
				) 
			if(@p_DONOTPRINTFLAG = '')
			begin

			INSERT INTO TAB_STRSPOSTALADRS (
				STRSADRSID,
				MAILTYPE,
				SORTCODE,
				DPCUSTOMERNAME,
				DPATT,
				DPSECDADDR,
				DPADDRLINE1, 
				DPADDRLINE2,
				DPZIP,
				DPZIPEXT,
				DPCITY,
				DPSTATE, 
				DPCOUNTRY,
				FOREIGNADDRESS,
				COPIES,
				PAGECOUNT,
				SHEETCOUNT,
				WEIGHT,
				SCANLINE,
				STRSDOCID,
				STRSCONCATADDRESS,
				STRSENVELOPEID,
				STRSSSORTFILEID,
				STRSBATCHDATE,
				BPNUMBER
				)       
			VALUES (
				@p_STRSADRSID,  
				@p_MAILTYPE, 
				@p_SORTCODE,
				@p_DPCUSTOMERNAME, 	
				@p_DPATT,
				@p_DPSECDADDR,
				@p_DPADDRLINE1, 
				@p_DPADDRLINE2,  
				@p_DPZIP,
				@p_DPZIPEXT,
				@p_DPCITY,
				@p_DPSTATE, 
				@p_DPCOUNTRY,
				@p_FOREIGNADDRESS,
				@p_COPIES,	
				@p_PAGECOUNT,
				@p_SHEETCOUNT,
				@p_WEIGHT,
				@p_SCANLINE,
				@p_STRSDOCID,
				CONCAT(UPPER(@p_DPCUSTOMERNAME), UPPER(@p_DPATT), UPPER(@p_DPSECDADDR), UPPER(@p_DPADDRLINE1), UPPER(@p_DPADDRLINE2), UPPER(@p_DPZIP), UPPER(@p_DPZIPEXT), UPPER(@p_DPCITY), UPPER(@p_DPSTATE), UPPER(@p_DPCOUNTRY)),
				'not initialized',
				'not initialized',
				'not initialized',
				@p_BPNUMBER
			) 
			end
		END
END
GO

GRANT EXECUTE ON SP_INSERT_INVOICE_DETAILS TO StrsSolutionDB
GO
DROP PROCEDURE SP_INSERT_CORRESPONDENCE_DETAILS
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
-- Modifed date: 2017 01 27
-- Description:	Insert Correspondence Details
-- =============================================
CREATE PROCEDURE SP_INSERT_CORRESPONDENCE_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSDOCID VARCHAR(50),  
	@p_DOCUMENTTYPE VARCHAR(20),
	@p_DOCUMENTTITLE VARCHAR(150),
	@p_DOCUMENTCATEGORY VARCHAR(30),
	@p_ACCOUNTNUMBER VARCHAR(15),
	@p_CUSTOMERNAME VARCHAR(40), 
	@p_DOCUMENTDATE VARCHAR(10),
	@p_CHANNEL VARCHAR(25), 
	@p_RESEND CHAR(1),
	@p_REPRINT CHAR(1),
	@p_STRSSPOOLID VARCHAR(20),
	@p_STRSJOBID INT,
	
	@p_STRSADRSID VARCHAR(20),  
	@p_MAILTYPE VARCHAR(10), 
	@p_SORTCODE VARCHAR(10),
	@p_DPCUSTOMERNAME VARCHAR(50), 
	@p_DPATT VARCHAR(50), 
	@p_DPSECDADDR VARCHAR(50),	
	@p_DPADDRLINE1 VARCHAR(50), 
	@p_DPADDRLINE2 VARCHAR(50), 
	@p_DPZIP VARCHAR(5),
	@p_DPZIPEXT VARCHAR(10),
	@p_DPCITY VARCHAR(40),
	@p_DPSTATE VARCHAR(5), 
	@p_DPCOUNTRY VARCHAR(20),
	@p_FOREIGNADDRESS CHAR(1),
	@p_COPIES INT,	
	@p_PAGECOUNT INT,
	@p_SHEETCOUNT INT,
	@p_WEIGHT DECIMAL(5,2),
	@p_SCANLINE VARCHAR(60)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSCORR (
				STRSDOCID,
				CREATEDATETIME,
				DOCUMENTTYPE,
				DOCUMENTTITLE,
				DOCUMENTCATEGORY,
				ACCOUNTNUMBER,
				CUSTOMERNAME,
				DOCUMENTDATE,
				CHANNEL,
				RESEND, 
				REPRINT,
				STRSAFPID,
				STRSPPIDARCHIVE,
				BATCHDATE,
				STRSSPOOLID,
				STRSBATCHID,
				STRSJOBID
				)       
			VALUES (
				@p_STRSDOCID, 
				SYSDATETIME(), 
				@p_DOCUMENTTYPE,
				@p_DOCUMENTTITLE,
				@p_DOCUMENTCATEGORY,
				@p_ACCOUNTNUMBER,
				@p_CUSTOMERNAME, 
				@p_DOCUMENTDATE,
				@p_CHANNEL, 
				@p_RESEND, 
				@p_REPRINT,
				'not initialized',
				'not initialized',
				'not initialized',
				@p_STRSSPOOLID,
				'not initialized',	
				@p_STRSJOBID
				) 

			INSERT INTO TAB_STRSPOSTALADRS (
				STRSADRSID,
				MAILTYPE,
				SORTCODE,
				DPCUSTOMERNAME,
				DPATT,
				DPSECDADDR,
				DPADDRLINE1, 
				DPADDRLINE2,
				DPZIP,
				DPZIPEXT,
				DPCITY,
				DPSTATE, 
				DPCOUNTRY,
				FOREIGNADDRESS,
				COPIES,
				PAGECOUNT,
				SHEETCOUNT,
				WEIGHT,
				SCANLINE,
				STRSDOCID,
				STRSCONCATADDRESS,
				STRSENVELOPEID,
				STRSSSORTFILEID,
				STRSBATCHDATE
				)       
			VALUES (
				@p_STRSADRSID,  
				@p_MAILTYPE, 
				@p_SORTCODE,
				@p_DPCUSTOMERNAME, 	
				@p_DPATT,
				@p_DPSECDADDR,
				@p_DPADDRLINE1, 
				@p_DPADDRLINE2, 
				@p_DPZIP,
				@p_DPZIPEXT,
				@p_DPCITY,
				@p_DPSTATE, 
				@p_DPCOUNTRY,
				@p_FOREIGNADDRESS,
				@p_COPIES,	
				@p_PAGECOUNT,
				@p_SHEETCOUNT,
				@p_WEIGHT,
				@p_SCANLINE,
				@p_STRSDOCID,
				CONCAT(UPPER(@p_DPCUSTOMERNAME), UPPER(@p_DPATT), UPPER(@p_DPSECDADDR), UPPER(@p_DPADDRLINE1), UPPER(@p_DPADDRLINE2), UPPER(@p_DPZIP), UPPER(@p_DPZIPEXT), UPPER(@p_DPCITY), UPPER(@p_DPSTATE), UPPER(@p_DPCOUNTRY)),
				'not initialized',
				'not initialized',
				'not initialized'
				) 
		END 		
END
GO

GRANT EXECUTE ON SP_INSERT_CORRESPONDENCE_DETAILS TO StrsSolutionDB
GO
DROP PROCEDURE SP_INSERT_COCM_DETAILS
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
-- Modifed date: 2016 04 11
-- Description:	Insert COCM Details
-- =============================================
CREATE PROCEDURE SP_INSERT_COCM_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSDOCID VARCHAR(30),  
	@p_DOCUMENTTYPE VARCHAR(20),
	@p_DOCUMENTCATEGORY VARCHAR(30),
	@p_ACCOUNTNUMBER VARCHAR(15),
	@p_CUSTOMERNAME VARCHAR(50), 
	@p_CUSTOMEREMAIL VARCHAR(200),
	@p_PREMADDRESS VARCHAR(500), 
	@p_COCMDATE VARCHAR(10),
	@p_GUID VARCHAR(40),
	@p_COKEY VARCHAR(40),
	@p_CHANNEL VARCHAR(25), 
	@p_ARCHIVECOMPLETE CHAR(1), 
	@p_STRSSPOOLID VARCHAR(20),  
	@p_STRSJOBID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSCOCM (
				STRSDOCID,  
				CREATEDATETIME,
				DOCUMENTTYPE,
				DOCUMENTCATEGORY,
				ACCOUNTNUMBER,
				CUSTOMERNAME, 
				CUSTOMEREMAIL,
				PREMADDRESS, 
				COCMDATE,
				GUID,
				COKEY,
				CHANNEL, 
				ARCHIVECOMPLETE, 
				STRSSPOOLID,  
				STRSBATCHID, 
				STRSJOBID
				)       
			VALUES (
				@p_STRSDOCID, 
				SYSDATETIME(), 
				@p_DOCUMENTTYPE,
				@p_DOCUMENTCATEGORY,
				@p_ACCOUNTNUMBER,
				@p_CUSTOMERNAME, 
				@p_CUSTOMEREMAIL,
				@p_PREMADDRESS, 
				@p_COCMDATE, 
				@p_GUID,
				@p_COKEY,
				@p_CHANNEL,
				@p_ARCHIVECOMPLETE,	
				@p_STRSSPOOLID,
				'not initialized',	
				@p_STRSJOBID
				) 
		END 		
END
GO

GRANT EXECUTE ON SP_INSERT_COCM_DETAILS TO StrsSolutionDB
GO
DROP PROCEDURE SP_INSERT_NOTIFICATION
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
-- Author:		don orazulume
-- Create date: 2016 02 18
-- Description:	insert notifications
-- =============================================
CREATE PROCEDURE SP_INSERT_NOTIFICATION
	-- Add the parameters for the stored procedure here
	@p_STRNOTIFICATIONID VARCHAR(20),
	@p_NOTIFICATIONTYPE VARCHAR(20),
	@p_NOTIFICATIONCLASS VARCHAR(10),
	@p_STRSJOBID INT,
	@p_BATCHDATE VARCHAR(8),
	@p_PROJECTNAME VARCHAR(40),
	@p_FUNCTIONCLASS VARCHAR(5),
	@p_FUNCTIONCNAME VARCHAR(50),
	@p_NOTIFICATION VARCHAR(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

    -- Insert statements for procedure here
	INSERT INTO TAB_STRSNOTIFICATIONS (
				STRNOTIFICATIONID,
				CREATEDATETIME,		-- dynamic
				NOTIFICATIONTYPE,
				NOTIFICATIONCLASS, 
				STRSJOBID,
				BATCHDATE,
				PROJECTNAME,
				FUNCTIONCLASS,
				FUNCTIONCNAME,
				NOTIFICATION
				)       
			VALUES (
				@p_STRNOTIFICATIONID,
				SYSDATETIME(),   	-- dynamic
				@p_NOTIFICATIONTYPE,
				@p_NOTIFICATIONCLASS,   
				@p_STRSJOBID,
				@p_BATCHDATE,
				@p_PROJECTNAME,
				@p_FUNCTIONCLASS,
				@p_FUNCTIONCNAME,
				@p_NOTIFICATION
				)  
END
GO

GRANT EXECUTE ON SP_INSERT_NOTIFICATION TO StrsSolutionDB
GO
DROP PROCEDURE SP_INSERT_EBILL_DETAILS
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
-- Modifed date: 2016 03 14
-- Description:	Insert EBILL Details
-- =============================================
CREATE PROCEDURE SP_INSERT_EBILL_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSDOCID VARCHAR(50), 
	@p_BILLTYPE VARCHAR(20),
	@p_EMAILADDRESS VARCHAR(250),
	@p_SEGMENT INT, 
	@p_HTMLFILE VARCHAR(100), 
	@p_IMAGEFILE VARCHAR(100), 
	@p_CSVFILE	VARCHAR(100), 
	@p_INVOICELLINK VARCHAR(100),
	@p_COKEY VARCHAR(50),	
	@p_STRSSPOOLID VARCHAR(20),
	@p_STRSJOBID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSEBILL (
				STRSDOCID,
				CREATEDATETIME,
				BILLTYPE,
				EMAILADDRESS,
				SEGMENT,
				HTMLFILE,
				IMAGEFILE,
				CSVFILE,
				INVOICELLINK,
				COKEY,
				STRSSPOOLID,
				STRSBATCHID,
				STRSJOBID
		   )       
			VALUES (
				@p_STRSDOCID, 
				SYSDATETIME(), 
				@p_BILLTYPE,
				@p_EMAILADDRESS,
				@p_SEGMENT, 
				@p_HTMLFILE, 
				@p_IMAGEFILE, 
				@p_CSVFILE,	
				@p_INVOICELLINK,
				@p_COKEY,
				@p_STRSSPOOLID,
				'not initialized',
				@p_STRSJOBID
				) 
		END
END
GO

GRANT EXECUTE ON SP_INSERT_EBILL_DETAILS TO StrsSolutionDB
GO
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
END
GO

GRANT EXECUTE ON SP_INSERT_POSTALOPT_DETAILS TO StrsSolutionDB
GO
DROP PROCEDURE SP_INSERT_PRESORTFILE_DETAILS
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
-- Description:	Insert PResortFile table with postal optimization file Details
-- =============================================
CREATE PROCEDURE SP_INSERT_PRESORTFILE_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSSSORTFILEID VARCHAR(30),
	@p_SORTCODE VARCHAR(10),
	@p_FILENAME VARCHAR(80),
	@p_RECORDCOUNTSENT INT,
	@p_PROCESSCOMPLETE INT,
	@p_STRSBATCHID VARCHAR(20),
	@p_STRSJOBID INT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- INTerfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSPRESORTFILE
           (
			   STRSSSORTFILEID,
			   SORTCODE,
			   FILENAME,
			   RECORDCOUNTSENT,
			   SENTDATETIME,
			   PROCESSCOMPLETE,
			   STRSBATCHID,
			   STRSJOBID
		   )
			VALUES
           (
			   @p_STRSSSORTFILEID,
			   @p_SORTCODE,
			   @p_FILENAME,
			   @p_RECORDCOUNTSENT,
			   SYSDATETIME(),
			   @p_PROCESSCOMPLETE,
			   @p_STRSBATCHID,
			   @p_STRSJOBID
		   )
  		END
		
		BEGIN
			UPDATE TAB_STRSPOSTALADRS
			SET STRSSSORTFILEID = tab.STRSSSORTFILEID	
			FROM (
				SELECT STRSSSORTFILEID
				FROM TAB_STRSPRESORTFILE
				WHERE STRSBATCHID = @p_STRSBATCHID
				) tab
			WHERE STRSENVELOPEID IN (
				SELECT STRSENVELOPEID
				FROM VW_ENVELOPE_DETAIL
				WHERE INV_BATCHID = @p_STRSBATCHID
					AND SORTCODE = @p_SORTCODE
			)
		END
		
		BEGIN
			UPDATE TAB_STRSPOSTALADRS
			SET STRSSSORTFILEID = tab.STRSSSORTFILEID	
			FROM (
				SELECT STRSSSORTFILEID
				FROM TAB_STRSPRESORTFILE
				WHERE STRSBATCHID = @p_STRSBATCHID
				) tab
			WHERE STRSENVELOPEID IN (
				SELECT STRSENVELOPEID
				FROM VW_ENVELOPE_DETAIL
				WHERE CORR_BATCHID = @p_STRSBATCHID
					AND SORTCODE = @p_SORTCODE
			)
		END
END
GO

GRANT EXECUTE ON SP_INSERT_PRESORTFILE_DETAILS TO StrsSolutionDB
GO