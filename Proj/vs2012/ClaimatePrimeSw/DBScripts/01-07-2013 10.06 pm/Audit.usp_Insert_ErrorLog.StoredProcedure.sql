USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_Insert_ErrorLog]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_Insert_ErrorLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to INSERT the errorLog details into the table before rollback.
 
CREATE PROCEDURE [Audit].[usp_Insert_ErrorLog]
AS
BEGIN
	SET NOCOUNT ON;

	-- http://msdn.microsoft.com/en-us/library/ms179296.aspx
	INSERT INTO 
		[Audit].[ErrorLog]
		(
			[ErrorNumber]
			, [ErrorMessage]
			, [ErrorSeverity]
			, [ErrorState]
			, [ErrorLine]
			, [ErrorProcedure]
			, [CreatedOn]
		)
	SELECT 
		error_NUMBER() AS ErrorNumber
		, error_MESSAGE() AS ErrorMessage
		, error_SEVERITY() AS ErrorSeverity
		, error_STATE() AS ErrorState
		, error_LINE() AS ErrorLine
		, error_PROCEDURE() AS ErrorProcedure
		, GETDATE() AS CreatedOn;
END
GO
