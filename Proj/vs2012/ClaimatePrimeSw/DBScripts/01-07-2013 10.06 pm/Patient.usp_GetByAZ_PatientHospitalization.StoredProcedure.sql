USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetByAZ_PatientHospitalization]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetByAZ_PatientHospitalization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetByAZ_PatientHospitalization] 
	 @ClinicTypeID INT
	 ,@ClinicID INT
	 , @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @IsActive	BIT = NULL
	,@ChartNumber nvarchar(350) = NULL
	, @PatientID BIGINT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    IF @ChartNumber IS NULL
    BEGIN
		SELECT @ChartNumber = '';
	END
		IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = CAST('1900-01-01' AS DATE);
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = DATEADD(MONTH, 1, GETDATE());
	END
    
    DECLARE @TBL_ALL TABLE
    (
		[ChartNumber] [nvarchar](350) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
    INSERT INTO
		@TBL_ALL
	
	SELECT
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))
	FROM
		[Patient].[PatientHospitalization]
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientHospitalization].[PatientID]
	INNER JOIN
		[Billing].[Clinic]
	ON 
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]	
	INNER JOIN
		[Billing].[FacilityDone]
	ON 
		[Billing].[FacilityDone].[FacilityDoneID] = [Patient].[PatientHospitalization].[FacilityDoneHospitalID]
	WHERE
		[Billing].[FacilityDone].[FacilityTypeID] = @ClinicTypeID	
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
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END;
				
	DECLARE @AZ_TMP VARCHAR(26);
	SELECT @AZ_TMP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE @AZ_LOOP INT;
	SELECT 	@AZ_LOOP = 1;
	DECLARE @AZ_CNT INT;
	SELECT @AZ_CNT = LEN(@AZ_TMP);
	DECLARE @AZ_CHR VARCHAR(1);
	SELECT @AZ_CHR = '';
	
	WHILE @AZ_LOOP <= @AZ_CNT
	BEGIN
		SELECT @AZ_CHR = SUBSTRING(@AZ_TMP, @AZ_LOOP, 1);
		
		INSERT INTO
			@TBL_AZ
		SELECT
			@AZ_CHR	AS [AZ]
			, COUNT(*) AS [AZ_COUNT]
		FROM
			@TBL_ALL
		WHERE
			[ChartNumber] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- EXEC [Patient].[usp_GetByAZ_PatientHospitalization]  @ClinicTypeID= 2
END
GO
