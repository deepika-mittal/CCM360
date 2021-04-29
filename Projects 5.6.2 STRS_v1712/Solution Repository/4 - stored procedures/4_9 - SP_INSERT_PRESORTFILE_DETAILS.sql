
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
GO