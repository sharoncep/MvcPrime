USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetBySearchAd_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetBySearchAd_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetBySearchAd_Clinic]
     @UserID int
	,@SearchName NVARCHAR(150) = NULL
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
		[Billing].[Clinic].[ClinicID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'ClinicName' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[ClinicName] END ASC,
				CASE WHEN @orderByField = 'ClinicName' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[ClinicName] END DESC,
				
				CASE WHEN @OrderByField = 'ClinicCode' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[ClinicCode] END ASC,
				CASE WHEN @orderByField = 'ClinicCode' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[ClinicCode] END DESC,
				
				CASE WHEN @OrderByField = 'IPAName' AND @OrderByDirection = 'A' THEN [Billing].[IPA].[IPAName] END ASC,
				CASE WHEN @orderByField = 'IPAName' AND @orderByDirection = 'D' THEN [Billing].[IPA].[IPAName] END DESC,
				
				CASE WHEN @OrderByField = 'EntityTypeQualifierName' AND @OrderByDirection = 'A' THEN [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName] END ASC,
				CASE WHEN @orderByField = 'EntityTypeQualifierName' AND @orderByDirection = 'D' THEN [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[Clinic].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
			
			FROM
	   [User].[UserClinic] 
	  INNER JOIN 
		[Billing].[Clinic]
	   ON
		[Billing].[Clinic].[ClinicID]=[User].[UserClinic].[ClinicID] 
     INNER JOIN
	     [Billing].[IPA]
	ON
	    [Billing].[Clinic].[IPAID]= [Billing].[IPA].[IPAID]
INNER JOIN
	     [Transaction].[EntityTypeQualifier]
	ON
	    [Billing].[Clinic].EntityTypeQualifierID = [Transaction].[EntityTypeQualifier].[EntityTypeQualifierID]  
	WHERE
		[Billing].[Clinic].[ClinicName] LIKE @StartBy + '%' 
	AND
	(
		[Billing].[Clinic].[ClinicName] LIKE '%' + @SearchName + '%' 
	OR
		[Billing].[Clinic].[ClinicCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[User].[UserClinic].[UserID] = @UserID
	AND
		[Billing].[Clinic].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Clinic].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Clinic].[ClinicID], [Clinic].[ClinicCode], [Clinic].[ClinicName], [Billing].[IPA].[IPAName], [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName], [Clinic].[IsActive]
	FROM
		[Clinic] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Clinic].[ClinicID]
		
		 INNER JOIN 
		[User].[UserClinic]
	   ON
		[Billing].[Clinic].[ClinicID]=[User].[UserClinic].[ClinicID]
		
INNER JOIN
	     [Billing].[IPA]
	ON
	    [Billing].[Clinic].[IPAID]= [Billing].[IPA].[IPAID]
INNER JOIN
	     [Transaction].[EntityTypeQualifier]
	ON
	    [Billing].[Clinic].EntityTypeQualifierID = [Transaction].[EntityTypeQualifier].[EntityTypeQualifierID]
	WHERE
	
		[User].[UserClinic].[UserID] = @UserID
	AND
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	
END

-- EXEC [Billing].[usp_GetBySearchAd_Clinic] @UserID  = 1 ,  @StartBy='A'
	-- EXEC [Billing].[usp_GetBySearchAd_Clinic] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
GO
