USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetByAZ_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetByAZ_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetByAZ_PatientVisit] 
	 @ClinicID INT
	, @SearchName NVARCHAR(350) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @PatientID BIGINT = NULL
	, @IsActive	BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SELECT @SearchName = '';
	END
	
	DECLARE @PatientVisitID BIGINT;
	BEGIN TRY
		SELECT @PatientVisitID = CAST (@SearchName AS BIGINT);
	END TRY
	BEGIN CATCH
		SELECT @PatientVisitID = 0;
	END CATCH
	
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
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[PatientID]=[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientID] = CASE WHEN @PatientID IS NULL THEN [PatientVisit].[PatientID] ELSE @PatientID END
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '') ))) ) LIKE '%' + @SearchName + '%' 
		OR
			[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
		)
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientVisit].[IsActive] ELSE @IsActive END
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END
	ORDER BY
		[Patient].[PatientVisit].[LastModifiedBy]
	DESC;
		
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
	
	-- EXEC [Patient].[usp_GetByAZ_PatientVisit] @ClinicID= 2
	-- EXEC [Patient].[usp_GetByAZ_PatientVisit] @ClinicID= 2, @SearchName='RAT', @PatientID = NULL
END
GO
