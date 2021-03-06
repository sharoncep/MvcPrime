USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_EntityIdentifierCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_EntityIdentifierCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_EntityIdentifierCode] 
	@EntityIdentifierCodeID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[EntityIdentifierCode].*
	FROM
		[Transaction].[EntityIdentifierCode]
	WHERE
		[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeID] = @EntityIdentifierCodeID
	AND
		[Transaction].[EntityIdentifierCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[EntityIdentifierCode].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_EntityIdentifierCode] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_EntityIdentifierCode] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_EntityIdentifierCode] 1, 0
END
GO
