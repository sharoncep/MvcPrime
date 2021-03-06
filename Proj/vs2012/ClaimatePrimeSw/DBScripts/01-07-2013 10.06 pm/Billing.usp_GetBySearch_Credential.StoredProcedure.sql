USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_Credential]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetBySearch_Credential]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetBySearch_Credential]
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
		[Billing].[Credential].[CredentialID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'CredentialName' AND @OrderByDirection = 'A' THEN [Billing].[Credential].[CredentialName] END ASC,
				CASE WHEN @orderByField = 'CredentialName' AND @orderByDirection = 'D' THEN [Billing].[Credential].[CredentialName] END DESC,
				
				CASE WHEN @OrderByField = 'CredentialCode' AND @OrderByDirection = 'A' THEN [Billing].[Credential].[CredentialCode] END ASC,
				CASE WHEN @orderByField = 'CredentialCode' AND @orderByDirection = 'D' THEN [Billing].[Credential].[CredentialCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[Credential].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[Credential].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Billing].[Credential]
	WHERE
		[Billing].[Credential].[CredentialName] LIKE @StartBy + '%' 
	AND
	(
		[Billing].[Credential].[CredentialName] LIKE '%' + @SearchName + '%' 
	OR
		[Billing].[Credential].[CredentialCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Billing].[Credential].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Credential].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Credential].[CredentialID], [Credential].[CredentialCode], [Credential].[CredentialName], [Credential].[IsActive]
	FROM
		[Credential] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Credential].[CredentialID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Billing].[usp_GetBySearch_Credential] @SearchName  = '45'
	-- EXEC [Billing].[usp_GetBySearch_Credential] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
