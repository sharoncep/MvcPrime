USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetByAZDashVisits_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetByAZDashVisits_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetByAZDashVisits_PatientVisit]
	@UserID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE @StatusIDs NVARCHAR(100);
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	
	IF @Desc = 'Visits'
	BEGIN
		SELECT @StatusIDS = '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Created'
	BEGIN
		SELECT @StatusIDS = '10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Hold'
	BEGIN
		SELECT @StatusIDS = '6, 7';
	END
	
	IF @Desc = 'Ready To Send'
	BEGIN
		SELECT @StatusIDS = '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Sent'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Accepted'
	BEGIN
		SELECT @StatusIDS = '29, 30';
	END
	
	IF @Desc = 'Rejected'
	BEGIN
		SELECT @StatusIDS = '26, 27';
	END
	
	IF @Desc = 'Resubmit'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @DayCount = 'SEVEN'
	BEGIN
		SELECT @FromDiff = 1;
		SELECT @ToDiff = 7;
	END
	
	IF @DayCount = 'THIRTY'
	BEGIN
		SELECT @FromDiff = 8;
		SELECT @ToDiff = 30;
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
    
    
			
	IF @Desc = 'Resubmit' 
	BEGIN
		 IF @DayCount = 'ONE'
		 BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
		
		ELSE IF @DayCount = 'THIRTYPLUS'
		 BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
		
		ELSE IF @DayCount = 'TOTAL'
		 BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
		
		ELSE 
		 BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
	END
---------
	ELSE
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
			
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		
		ELSE IF @DayCount <> 'ALL'
		BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
--------------
	IF @Desc = 'Visits' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@TBL_ALL
		SELECT 
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] > 0
		AND 
			[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Accepted' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@TBL_ALL
		SELECT 
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
		AND 
			[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@TBL_ALL
		SELECT 
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
		AND
			[Patient].[PatientVisit].[IsActive] = 0
		OR
			[Patient].[Patient].[IsActive] = 0;
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@TBL_ALL
		SELECT 
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (3, 5, 8, 12, 14, 18, 20, 24, 27)
		AND
			[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
	END
	
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
	-- EXEC [Patient].[usp_GetByAZDashVisits_PatientVisit]  @UserID = 101,  @Desc = 'Visits', @DayCount = 'TOTAL'
END
GO
