USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetDashboardSummaryNIT_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetDashboardSummaryNIT_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetDashboardSummaryNIT_PatientVisit]
	@UserID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- BIGINTerfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY (1, 1) NOT NULL
		, [BLOCKED] BIGINT NOT NULL
		, [NIT] BIGINT NOT NULL
		, [TOTAL] BIGINT NOT NULL
	);
	
	DECLARE @BLOCKED BIGINT;
	DECLARE @NIT BIGINT;
	DECLARE @TOTAL BIGINT;
	
	--
	
	SELECT 
		@BLOCKED = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
	(
			[Patient].[PatientVisit].[IsActive] = 0
		OR
			[Patient].[Patient].[IsActive] = 0
	);	
	
	--
	
	SELECT 
		@NIT = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
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
		
	--	
	
	SELECT 
		@TOTAL = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
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
	
	--
			
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		@BLOCKED
		, @NIT
		, @TOTAL
	);
	
	SELECT * FROM @TBL_ANS ORDER BY [ID] ASC;		
	
	-- EXEC [Patient].[usp_GetDashboardSummaryNIT_PatientVisit] 101
END
GO
