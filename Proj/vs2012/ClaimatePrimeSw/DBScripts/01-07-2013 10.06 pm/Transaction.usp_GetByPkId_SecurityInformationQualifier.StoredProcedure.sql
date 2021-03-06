USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_SecurityInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_SecurityInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_SecurityInformationQualifier] 
	@SecurityInformationQualifierID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[SecurityInformationQualifier].*
	FROM
		[Transaction].[SecurityInformationQualifier]
	WHERE
		[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID] = @SecurityInformationQualifierID
	AND
		[Transaction].[SecurityInformationQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[SecurityInformationQualifier].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_SecurityInformationQualifier] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_SecurityInformationQualifier] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_SecurityInformationQualifier] 1, 0
END
GO
