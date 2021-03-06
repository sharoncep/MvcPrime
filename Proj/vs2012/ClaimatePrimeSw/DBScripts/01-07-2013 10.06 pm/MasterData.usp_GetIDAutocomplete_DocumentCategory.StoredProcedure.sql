USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetIDAutocomplete_DocumentCategory]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetIDAutocomplete_DocumentCategory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetIDAutocomplete_DocumentCategory] 
	@DocumentCategoryCode	nvarchar(5)
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[MasterData].[DocumentCategory].[DocumentCategoryID]
		,[MasterData].[DocumentCategory].[DocumentCategoryCode]
		,[MasterData].[DocumentCategory].[IsInPatientRelated]
	FROM
		[MasterData].[DocumentCategory]
	WHERE
		@DocumentCategoryCode = [MasterData].[DocumentCategory].[DocumentCategoryCode]
	AND
		[MasterData].[DocumentCategory].[IsActive]=1

	-- EXEC [MasterData].[usp_GetIDAutocomplete_DocumentCategory] '01', NULL
	-- EXEC [MasterData].[usp_GetIDAutocomplete_DocumentCategory] 1, 1
	-- EXEC [MasterData].[usp_GetIDAutocomplete_DocumentCategory] 1, 0
END
GO
