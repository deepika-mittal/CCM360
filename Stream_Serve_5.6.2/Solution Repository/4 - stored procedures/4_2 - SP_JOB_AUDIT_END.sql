
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