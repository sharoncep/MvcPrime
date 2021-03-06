USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetByPkIdRelationshipName_Relationship]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetByPkIdRelationshipName_Relationship]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Insurance].[usp_GetByPkIdRelationshipName_Relationship] 
	@RelationshipID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[RelationshipName] NVARCHAR(150) NOT NULL 
		, [RelationshipCode] NVARCHAR(2) NOT NULL
	);

	INSERT INTO
		@TBL_RES
		
	SELECT
		[Insurance].[Relationship].[RelationshipName],[Insurance].[Relationship].[RelationshipCode]
	FROM
		[Insurance].[Relationship]
	WHERE
		@RelationshipID = [Insurance].[Relationship].[RelationshipID]
	AND
		[Insurance].[Relationship].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Insurance].[Relationship].[IsActive] ELSE @IsActive END;
		
	SELECT * FROM @TBL_RES;
	
	-- EXEC [Insurance].[usp_GetByPkIdRelationshipName_Relationship] 1, NULL
	-- EXEC [Insurance].[usp_GetByPkIdRelationshipName_Relationship] 1, 1
	-- EXEC [Insurance].[usp_GetByPkIdRelationshipName_Relationship] 1, 0
END
GO
