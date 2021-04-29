
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


















