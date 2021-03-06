USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetNameByID_SecurityInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetNameByID_SecurityInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [Transaction].[usp_GetNameByID_SecurityInformationQualifier] 
	@SecurityInformationQualifierID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID]
		,[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierName]+ ' [' + [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierCode] + ']' AS [NAME_CODE]	
	FROM
		[Transaction].[SecurityInformationQualifier]
	WHERE
		@SecurityInformationQualifierID = [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID]
	AND
		[Transaction].[SecurityInformationQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[SecurityInformationQualifier].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetNameByID_SecurityInformationQualifier] 1, NULL
	-- EXEC [Transaction].[usp_GetNameByID_SecurityInformationQualifier] 1, 1
	-- EXEC [Transaction].[usp_GetNameByID_SecurityInformationQualifier] 1, 0
END
GO
