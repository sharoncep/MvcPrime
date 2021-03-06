USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetByRelationshipName_Relationship]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetByRelationshipName_Relationship]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Insurance].[usp_GetByRelationshipName_Relationship] 
	@RelationshipCode	nvarchar(9)
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Insurance].[Relationship].*
	FROM
		[Insurance].[Relationship]
	WHERE
		@RelationshipCode = [Insurance].[Relationship].[RelationshipCode]
	AND
		[Insurance].[Relationship].[IsActive] = 1;

	-- EXEC [Insurance].[usp_GetByRelationshipName_Relationship] 1, NULL
	-- EXEC [Insurance].[usp_GetByRelationshipName_Relationship] 1, 1
	-- EXEC [Insurance].[usp_GetByRelationshipName_Relationship] 1, 0
END
GO
