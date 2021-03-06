USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetByPkId_Relationship]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetByPkId_Relationship]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Insurance].[usp_GetByPkId_Relationship] 
	@RelationshipID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Insurance].[Relationship].*
	FROM
		[Insurance].[Relationship]
	WHERE
		[Insurance].[Relationship].[RelationshipID] = @RelationshipID
	AND
		[Insurance].[Relationship].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Insurance].[Relationship].[IsActive] ELSE @IsActive END;

	-- EXEC [Insurance].[usp_GetByPkId_Relationship] 1, NULL
	-- EXEC [Insurance].[usp_GetByPkId_Relationship] 1, 1
	-- EXEC [Insurance].[usp_GetByPkId_Relationship] 1, 0
END
GO
