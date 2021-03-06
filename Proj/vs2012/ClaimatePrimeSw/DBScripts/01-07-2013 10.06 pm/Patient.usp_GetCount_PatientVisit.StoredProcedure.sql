USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetCount_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetCount_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetCount_PatientVisit]
	@ClinicID int
	, @StatusIDs NVARCHAR(100)
	, @AssignedTo INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CLAIM_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT
		COUNT ([Patient].[PatientVisit].[PatientVisitID]) AS [CLAIM_COUNT]
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]	
	WHERE
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
	AND
		(
			[Patient].[PatientVisit].[AssignedTo] = @AssignedTo 
		OR
			@AssignedTo IS NULL
		)
	
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT * FROM @TBL_ANS;
		
	-- EXEC [Patient].[usp_GetCount_PatientVisit] @ClinicID = 1, @StatusIDs = '1, 2'	-- UNASSIGNED
	-- EXEC [Patient].[usp_GetCount_PatientVisit] @ClinicID = 1, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25'	-- CREATED
	-- EXEC [Patient].[usp_GetCount_PatientVisit] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
	-- EXEC [Patient].[usp_GetCount_PatientVisit] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
END
GO
