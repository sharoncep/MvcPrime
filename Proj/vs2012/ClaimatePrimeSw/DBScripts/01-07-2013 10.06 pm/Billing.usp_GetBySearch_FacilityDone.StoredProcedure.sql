USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_FacilityDone]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetBySearch_FacilityDone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetBySearch_FacilityDone]
	@SearchName NVARCHAR(150) = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SET @SearchName = '';
	END
	
	IF @StartBy IS NULL
	BEGIN
		SET @StartBy = '';
	END
	
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
		[Billing].[FacilityDone].[FacilityDoneID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'FacilityDoneName' AND @OrderByDirection = 'A' THEN [Billing].[FacilityDone].[FacilityDoneName] END ASC,
				CASE WHEN @orderByField = 'FacilityDoneName' AND @orderByDirection = 'D' THEN [Billing].[FacilityDone].[FacilityDoneName] END DESC,
				
				CASE WHEN @OrderByField = 'FacilityDoneCode' AND @OrderByDirection = 'A' THEN [Billing].[FacilityDone].[FacilityDoneCode] END ASC,
				CASE WHEN @orderByField = 'FacilityDoneCode' AND @orderByDirection = 'D' THEN [Billing].[FacilityDone].[FacilityDoneCode] END DESC,
				
				CASE WHEN @OrderByField = 'NPI' AND @OrderByDirection = 'A' THEN [Billing].[FacilityDone].[NPI] END ASC,
				CASE WHEN @orderByField = 'NPI' AND @orderByDirection = 'D' THEN [Billing].[FacilityDone].[NPI] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[FacilityDone].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[FacilityDone].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Billing].[FacilityDone]
	WHERE
		[Billing].[FacilityDone].[FacilityDoneName] LIKE @StartBy + '%' 
	AND
	(
		[Billing].[FacilityDone].[FacilityDoneName] LIKE '%' + @SearchName + '%' 
	OR
		[Billing].[FacilityDone].[FacilityDoneCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Billing].[FacilityDone].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[FacilityDone].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[FacilityDone].[FacilityDoneID], [FacilityDone].[FacilityDoneCode], [FacilityDone].[FacilityDoneName],[FacilityDone].[NPI], [FacilityDone].[IsActive]
	FROM
		[FacilityDone] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [FacilityDone].[FacilityDoneID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Billing].[usp_GetBySearch_FacilityDone] @SearchName  = '45'
	-- EXEC [Billing].[usp_GetBySearch_FacilityDone] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
