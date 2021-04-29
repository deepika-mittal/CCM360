USE [StrsSolutionDb]
GO

/****** Object:  StoredProcedure [dbo].[SP_UPDATE_AFP_ID]    Script Date: 10/19/2020 8:19:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SP_UPDATE_AFP_ID]
     -- Add the parameters for the stored procedure here
     @p_STRSDOCID VARCHAR(35), 
     @p_STRSAFPID VARCHAR(100),
     @p_SORTCODE VARCHAR(10)
AS
BEGIN
     -- SET NOCOUNT ON added to prevent extra result sets from
     -- interfering with SELECT statements.
     SET NOCOUNT ON

		declare @l_counter as int --defect 939

		IF @p_SORTCODE IN ('COR_DUPLX', 'COR_REGUR','COR_REG2R', 'COR_RESND', 'COR_OVWG', 'COR_DUPRE', 'COR_DUPRE2', 'COR_HPP', 'COR_DIVERT', 'COR_POSTC' , 'COR_REOVWG', 'COR_HPP2', 'COR_ARCH') ---enhancement 4871 added COR_HPP2  -- enhancement 10144 added COR_ARCHIVE_ONLY 
		--- Added sort code COR_REG2R for enahncement 18252
		--- changed sort code COR_ARCHIVE_ONLY to COR_ARCH for defect 14367
	

			BEGIN                
				UPDATE TAB_STRSCORR SET STRSAFPID = @p_STRSAFPID 
				WHERE STRSDOCID = @p_STRSDOCID
			END
		ELSE IF  @p_SORTCODE IN ('INV_RSDIV', 'INV_EBILL', 'INV_COLIV', 'INV_RSREG', 'INV_OVWG', 'INV_RSOVWG', 'INV_SHOFF', 'INV_SHODIV', 'INV_SHOVWG', 'INV_CMREG','INV_RESND')--defect 12398 added sortcode INV_RESND
            IF LEN(@p_STRSDOCID) > 20
				BEGIN                
					UPDATE TAB_STRSCORR SET STRSAFPID = @p_STRSAFPID 
					WHERE STRSDOCID = @p_STRSDOCID
				END
			ELSE
update_invafpid: --defect 939
				select @l_counter = 1 + @l_counter; --defect 939
				BEGIN
					UPDATE TAB_STRSINV SET STRSAFPID = @p_STRSAFPID 
					WHERE STRSDOCID = @p_STRSDOCID
				END  
				if @@ROWCOUNT = 0 and @l_counter <= 2 --defect 939
					goto update_invafpid
					 
		
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


