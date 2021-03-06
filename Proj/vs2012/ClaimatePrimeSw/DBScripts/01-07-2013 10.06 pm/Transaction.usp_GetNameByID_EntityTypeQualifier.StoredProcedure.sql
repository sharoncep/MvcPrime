USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetNameByID_EntityTypeQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetNameByID_EntityTypeQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Transaction].[usp_GetNameByID_EntityTypeQualifier] 
	@EntityTypeQualifierID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID]
		,[Transaction].[EntityTypeQualifier].[EntityTypeQualifierName]+ ' [' + [Transaction].[EntityTypeQualifier].[EntityTypeQualifierCode] + ']' AS [NAME_CODE]	
	FROM
		[Transaction].[EntityTypeQualifier]
	WHERE
		@EntityTypeQualifierID = [Transaction].[EntityTypeQualifier].[EntityTypeQualifierID]
	AND
		[Transaction].[EntityTypeQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[EntityTypeQualifier].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetNameByID_EntityTypeQualifier] 1, NULL
	-- EXEC [Transaction].[usp_GetNameByID_EntityTypeQualifier] 1, 1
	-- EXEC [Transaction].[usp_GetNameByID_EntityTypeQualifier] 1, 0
END
GO
