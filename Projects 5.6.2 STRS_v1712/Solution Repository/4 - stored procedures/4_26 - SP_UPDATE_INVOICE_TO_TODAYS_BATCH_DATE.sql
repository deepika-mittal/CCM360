


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