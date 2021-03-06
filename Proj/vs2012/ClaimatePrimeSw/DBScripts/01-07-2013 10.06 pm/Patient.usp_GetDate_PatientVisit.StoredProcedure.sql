USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetDate_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetDate_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetDate_PatientVisit]
	@ClinicID int
	, @StatusIDs NVARCHAR(100)
	, @AssignedTo INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[DOS_FROM] DATE NOT NULL
		, [DOS_TO] DATE NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT
		ISNULL(MIN([Patient].[PatientVisit].[DOS]), GETDATE()) AS [DOS_FROM]
		, GETDATE() AS [DOS_TO]
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
			(
				@AssignedTo IS NULL 
			AND 
				[Patient].[PatientVisit].[AssignedTo] IS NULL
			)
		)
	
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	IF EXISTS (SELECT * FROM @TBL_ANS)
	BEGIN
		UPDATE
			@TBL_ANS
		SET
			[DOS_TO] = DATEADD(DAY, 3, [DOS_FROM]);
	END
	ELSE
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			DATEADD(DAY, -3, GETDATE()) AS [DOS_FROM]
			, GETDATE() AS [DOS_TO];
	END
		
	SELECT * FROM @TBL_ANS;
		
	-- EXEC [Patient].[usp_GetDate_PatientVisit] @ClinicID = 2, @StatusIDs = '1'
END
GO
