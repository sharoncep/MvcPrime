USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetNameByID_AuthorizationInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetNameByID_AuthorizationInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [Transaction].[usp_GetNameByID_AuthorizationInformationQualifier] 
	@AuthorizationInformationQualifierID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID]
		,[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierName]+ ' [' + [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode] + ']' AS [NAME_CODE]	
	FROM
		[Transaction].[AuthorizationInformationQualifier]
	WHERE
		@AuthorizationInformationQualifierID = [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID]
	AND
		[Transaction].[AuthorizationInformationQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[AuthorizationInformationQualifier].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetNameByID_AuthorizationInformationQualifier] 1, NULL
	-- EXEC [Transaction].[usp_GetNameByID_AuthorizationInformationQualifier] 1, 1
	-- EXEC [Transaction].[usp_GetNameByID_AuthorizationInformationQualifier] 1, 0
END
GO
