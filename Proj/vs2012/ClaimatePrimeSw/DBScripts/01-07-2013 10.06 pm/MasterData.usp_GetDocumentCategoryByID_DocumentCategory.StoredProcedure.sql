USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetDocumentCategoryByID_DocumentCategory]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetDocumentCategoryByID_DocumentCategory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetDocumentCategoryByID_DocumentCategory] 
	@DocumentCategoryID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[DocumentCategoryCode] NVARCHAR(2) NOT NULL 
		, [DocumentCategoryName] NVARCHAR(150) NOT NULL
	);

	INSERT INTO
		@TBL_RES
		
	SELECT
		[MasterData].[DocumentCategory].[DocumentCategoryCode],[MasterData].[DocumentCategory].[DocumentCategoryName]
	FROM
		[MasterData].[DocumentCategory]
	WHERE
		@DocumentCategoryID = [MasterData].[DocumentCategory].[DocumentCategoryID]
	AND
		[MasterData].[DocumentCategory].[IsActive]=1
		
	SELECT * FROM @TBL_RES;

	-- EXEC [MasterData].[usp_GetDocumentCategoryByID_DocumentCategory] 1, NULL
	-- EXEC [MasterData].[usp_GetDocumentCategoryByID_DocumentCategory] 1, 1
	-- EXEC [MasterData].[usp_GetDocumentCategoryByID_DocumentCategory] 1, 0
END
GO
