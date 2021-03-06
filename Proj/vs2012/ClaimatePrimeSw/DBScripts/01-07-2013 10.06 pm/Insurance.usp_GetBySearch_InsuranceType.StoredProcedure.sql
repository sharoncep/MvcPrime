USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetBySearch_InsuranceType]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetBySearch_InsuranceType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Insurance].[usp_GetBySearch_InsuranceType]	
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
		[Insurance].[InsuranceType].[InsuranceTypeID]
		, ROW_NUMBER() OVER (
			ORDER BY						
				CASE WHEN @OrderByField = 'InsuranceTypeCode' AND @OrderByDirection = 'A' THEN [Insurance].[InsuranceType].[InsuranceTypeCode] END ASC,
				CASE WHEN @orderByField = 'InsuranceTypeCode' AND @orderByDirection = 'D' THEN [Insurance].[InsuranceType].[InsuranceTypeCode] END DESC,
				
				CASE WHEN @OrderByField = 'InsuranceTypeName' AND @OrderByDirection = 'A' THEN [Insurance].[InsuranceType].[InsuranceTypeName] END ASC,
				CASE WHEN @orderByField = 'InsuranceTypeName' AND @orderByDirection = 'D' THEN [Insurance].[InsuranceType].[InsuranceTypeName] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Insurance].[InsuranceType].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Insurance].[InsuranceType].[LastModifiedOn] END DESC			
			) AS ROW_NUM
	FROM
		[Insurance].[InsuranceType]
	WHERE
		[Insurance].[InsuranceType].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Insurance].[InsuranceType].[IsActive] ELSE @IsActive END;
		
	DECLARE @TBL_RES TABLE
	(
		[InsuranceTypeID] INT NOT NULL 
		, [InsuranceTypeCode] NVARCHAR(2) NOT NULL
		, [InsuranceTypeName] NVARCHAR(150) NOT NULL 
		, [IsActive] BIT NOT NULL 
	);

	INSERT INTO
		@TBL_RES
	SELECT		
		[InsuranceType].[InsuranceTypeID]
		, [InsuranceType].[InsuranceTypeCode]
		, [InsuranceType].[InsuranceTypeName]
		, [InsuranceType].[IsActive]
	FROM
		[InsuranceType] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [InsuranceType].[InsuranceTypeID]
	ORDER BY
		[ID]
	ASC;
	
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Insurance].[usp_GetBySearch_InsuranceType]
	-- EXEC [Insurance].[usp_GetBySearch_InsuranceType] @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
