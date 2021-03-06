USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_EntityTypeQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_EntityTypeQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_EntityTypeQualifier] 
	@EntityTypeQualifierID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[EntityTypeQualifier].*
	FROM
		[Transaction].[EntityTypeQualifier]
	WHERE
		[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID] = @EntityTypeQualifierID
	AND
		[Transaction].[EntityTypeQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[EntityTypeQualifier].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_EntityTypeQualifier] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_EntityTypeQualifier] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_EntityTypeQualifier] 1, 0
END
GO
