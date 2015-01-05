USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseSummaryNIT_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetAgentWiseSummaryNIT_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetAgentWiseSummaryNIT_PatientVisit]
	@UserID INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @TBL_ANS TABLE 
	(
		[ID] BIGINT IDENTITY (1, 1) NOT NULL
		, [NIT] BIGINT NOT NULL
		, [BLOCKED] BIGINT NOT NULL
		, [TOTAL] BIGINT NOT NULL

	);
	
	DECLARE @NIT BIGINT;
	DECLARE @Blocked BIGINT;
	DECLARE @TOTAL BIGINT;
	
	
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
-------------
	SELECT 
		@Blocked = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
	(
			[Patient].[PatientVisit].[IsActive] = 0
		OR
			[Patient].[Patient].[IsActive] = 0
	);
	
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;	
	
	--
				
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		 @NIT
		, @Blocked
		, @TOTAL
	)
	
	SELECT * FROM @TBL_ANS;		
	
	-- EXEC [Patient].[usp_GetAgentWiseSummaryNIT_PatientVisit] @UserID=116
END
GO
