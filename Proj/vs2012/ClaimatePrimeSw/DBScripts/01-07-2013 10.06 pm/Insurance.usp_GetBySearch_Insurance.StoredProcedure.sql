USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetBySearch_Insurance]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetBySearch_Insurance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Insurance].[usp_GetBySearch_Insurance]
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
		[Insurance].[Insurance].[InsuranceID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'InsuranceName' AND @OrderByDirection = 'A' THEN [Insurance].[Insurance].[InsuranceName] END ASC,
				CASE WHEN @orderByField = 'InsuranceName' AND @orderByDirection = 'D' THEN [Insurance].[Insurance].[InsuranceName] END DESC,
				
				CASE WHEN @OrderByField = 'InsuranceCode' AND @OrderByDirection = 'A' THEN [Insurance].[Insurance].[InsuranceCode] END ASC,
				CASE WHEN @orderByField = 'InsuranceCode' AND @orderByDirection = 'D' THEN [Insurance].[Insurance].[InsuranceCode] END DESC,
				
				CASE WHEN @OrderByField = 'EDIReceiver' AND @OrderByDirection = 'A' THEN (EDIReceiver.EDIReceiverName +' [' + EDIReceiver.EDIReceiverCode + ']' ) END ASC,
				CASE WHEN @orderByField = 'EDIReceiver' AND @orderByDirection = 'D' THEN (EDIReceiver.EDIReceiverName +' [' + EDIReceiver.EDIReceiverCode + ']' ) END DESC,
				
				CASE WHEN @OrderByField = 'PayerID' AND @OrderByDirection = 'A' THEN [Insurance].[Insurance].[PayerID] END ASC,
				CASE WHEN @orderByField = 'PayerID' AND @orderByDirection = 'D' THEN [Insurance].[Insurance].[PayerID] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Insurance].[Insurance].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Insurance].[Insurance].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Insurance].[Insurance]
		
		INNER JOIN
		
		[Insurance].[InsuranceType]
		
		ON
		
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
		
		INNER JOIN
		
		[EDI].[EDIReceiver]
		
		ON
		
		[EDI].[EDIReceiver].[EDIReceiverID] = [Insurance].[Insurance].[EDIReceiverID]
		
		
		
	WHERE
		[Insurance].[Insurance].[InsuranceName] LIKE @StartBy + '%' 
	AND
	(
		[Insurance].[Insurance].[InsuranceName] LIKE '%' + @SearchName + '%' 
	OR
		[Insurance].[Insurance].[InsuranceCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Insurance].[Insurance].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Insurance].[Insurance].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Insurance].[InsuranceID], [Insurance].[InsuranceName], [Insurance].[InsuranceCode],[Insurance].[PayerID],(EDIReceiver.EDIReceiverName +' [' + EDIReceiver.EDIReceiverCode + ']' )as EDIReceiver ,[Insurance].[IsActive]
	FROM
		[Insurance] WITH (NOLOCK)
		
		INNER JOIN
		
		[Insurance].[InsuranceType]
		
		ON
		
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
		
		INNER JOIN
		
		[EDI].[EDIReceiver]
		
		ON
		
		[EDI].[EDIReceiver].[EDIReceiverID] = [Insurance].[Insurance].[EDIReceiverID]
		
	INNER JOIN
	
		@SEARCH_TMP
	ON
		[PK_ID] = [Insurance].[InsuranceID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Insurance].[usp_GetBySearch_Insurance] @SearchName  = '45'
	-- EXEC [Insurance].[usp_GetBySearch_Insurance] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
