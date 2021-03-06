USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientHospitalization]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetBySearch_PatientHospitalization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetBySearch_PatientHospitalization]
     @ClinicTypeID	TINYINT
    , @ClinicID	INT  
	, @ChartNumber NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @PatientID BIGINT = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
	
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @ChartNumber IS NULL
	BEGIN
		SET @ChartNumber = '';
	END
	IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = CAST('1900-01-01' AS DATE);
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = DATEADD(MONTH, 1, GETDATE());
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
		[Patient].[PatientHospitalization].[PatientHospitalizationID]
		, ROW_NUMBER() OVER (
			ORDER BY
			
			CASE WHEN @OrderByField = 'Name ' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END DESC,						
						
				CASE WHEN @OrderByField = 'ChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'ChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'FacilityDoneName' AND @OrderByDirection = 'A' THEN [Billing].[FacilityDone].[FacilityDoneName] END ASC,
				CASE WHEN @orderByField = 'FacilityDoneName' AND @orderByDirection = 'D' THEN [Billing].[FacilityDone].[FacilityDoneName] END DESC,
				
				CASE WHEN @OrderByField = 'AdmittedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientHospitalization].[AdmittedOn] END ASC,
				CASE WHEN @orderByField = 'AdmittedOn' AND @orderByDirection = 'D' THEN [Patient].[PatientHospitalization].[AdmittedOn] END DESC,				
				
				CASE WHEN @OrderByField = 'DischargedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientHospitalization].[DischargedOn] END ASC,
				CASE WHEN @orderByField = 'DischargedOn' AND @orderByDirection = 'D' THEN [Patient].[PatientHospitalization].[DischargedOn] END DESC,

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientHospitalization].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientHospitalization].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[PatientHospitalization]
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientHospitalization].[PatientID]
	INNER JOIN
		[Billing].[FacilityDone]
	ON 
		[Billing].[FacilityDone].[FacilityDoneID] = [Patient].[PatientHospitalization].[FacilityDoneHospitalID]
		
INNER JOIN
		[Billing].[Clinic]
	ON 
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	WHERE
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @ChartNumber + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] ))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE '%' + @ChartNumber + '%' 
		)
    AND
		[Patient].[PatientHospitalization].[AdmittedOn] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[Patient].[PatientID] = CASE WHEN @PatientID IS NULL THEN [Patient].[Patient].[PatientID] ELSE @PatientID END
	AND
		[Billing].[FacilityDone].[FacilityTypeID] = @ClinicTypeID
	AND
		[Billing].[Clinic].[ClinicID] = @ClinicID	
	AND
		[Patient].[PatientHospitalization].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientHospitalization].[IsActive] ELSE @IsActive END
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END
	AND
		[Billing].[FacilityDone].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[FacilityDone].[IsActive] ELSE @IsActive END;
	
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Patient].[PatientHospitalization].[PatientHospitalizationID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		, [Patient].[PatientHospitalization].[AdmittedOn]
		, [Patient].[PatientHospitalization].[DischargedOn]
		, [Billing].[FacilityDone].[FacilityDoneName]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[PatientHospitalization].[IsActive]
	FROM
		[Patient].[PatientHospitalization] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] =[Patient].[PatientHospitalization].[PatientHospitalizationID]
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientHospitalization].[PatientID]
	INNER JOIN
		[Billing].[FacilityDone]
	ON 
		[Billing].[FacilityDone].[FacilityDoneID] = [Patient].[PatientHospitalization].[FacilityDoneHospitalID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	-- EXEC [Patient].[usp_GetBySearch_PatientHospitalization] @ClinicTypeID = 2
	-- EXEC [Patient].[usp_GetBySearch_PatientHospitalization] @ClinicTypeID = 2, @ChartNumber  = NULL, @StartBy = NULL, @PatientID = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
