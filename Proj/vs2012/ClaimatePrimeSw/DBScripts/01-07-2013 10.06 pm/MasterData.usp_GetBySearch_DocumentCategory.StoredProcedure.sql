USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_DocumentCategory]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetBySearch_DocumentCategory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [MasterData].[usp_GetBySearch_DocumentCategory]	
	@OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT
		[MasterData].[DocumentCategory].[DocumentCategoryID]
		, ROW_NUMBER() OVER (
			ORDER BY						
				CASE WHEN @OrderByField = 'DocumentCategoryCode' AND @OrderByDirection = 'A' THEN [MasterData].[DocumentCategory].[DocumentCategoryCode] END ASC,
				CASE WHEN @orderByField = 'DocumentCategoryCode' AND @orderByDirection = 'D' THEN [MasterData].[DocumentCategory].[DocumentCategoryCode] END DESC,
				
				CASE WHEN @OrderByField = 'DocumentCategoryName' AND @OrderByDirection = 'A' THEN [MasterData].[DocumentCategory].[DocumentCategoryName] END ASC,
				CASE WHEN @orderByField = 'DocumentCategoryName' AND @orderByDirection = 'D' THEN [MasterData].[DocumentCategory].[DocumentCategoryName] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [MasterData].[DocumentCategory].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [MasterData].[DocumentCategory].[LastModifiedOn] END DESC			
			) AS ROW_NUM
	FROM
		[MasterData].[DocumentCategory]
	WHERE
		[MasterData].[DocumentCategory].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[DocumentCategory].[IsActive] ELSE @IsActive END;
		
	DECLARE @TBL_RES TABLE
	(
		[DocumentCategoryID] INT NOT NULL 
		, [DocumentCategoryCode] NVARCHAR(2) NOT NULL
		, [DocumentCategoryName] NVARCHAR(150) NOT NULL 
		, [IsActive] BIT NOT NULL 
	);

	INSERT INTO
		@TBL_RES
	SELECT		
		[DocumentCategory].[DocumentCategoryID]
		, [DocumentCategory].[DocumentCategoryCode]
		, [DocumentCategory].[DocumentCategoryName]
		, [DocumentCategory].[IsActive]
	FROM
		[DocumentCategory] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [DocumentCategory].[DocumentCategoryID]
	ORDER BY
		[ID]
	ASC;
	
	
	SELECT * FROM @TBL_RES;

	-- EXEC [MasterData].[usp_GetBySearch_DocumentCategory]
	-- EXEC [MasterData].[usp_GetBySearch_DocumentCategory] @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
