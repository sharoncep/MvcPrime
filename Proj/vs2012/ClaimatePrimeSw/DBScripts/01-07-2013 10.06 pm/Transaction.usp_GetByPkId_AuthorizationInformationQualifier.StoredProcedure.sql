USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_AuthorizationInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_AuthorizationInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_AuthorizationInformationQualifier] 
	@AuthorizationInformationQualifierID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[AuthorizationInformationQualifier].*
	FROM
		[Transaction].[AuthorizationInformationQualifier]
	WHERE
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID] = @AuthorizationInformationQualifierID
	AND
		[Transaction].[AuthorizationInformationQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[AuthorizationInformationQualifier].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_AuthorizationInformationQualifier] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_AuthorizationInformationQualifier] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_AuthorizationInformationQualifier] 1, 0
END
GO
