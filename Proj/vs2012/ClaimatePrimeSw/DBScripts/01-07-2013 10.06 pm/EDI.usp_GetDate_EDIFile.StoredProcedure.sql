USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetDate_EDIFile]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetDate_EDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetDate_EDIFile]
	@ClinicID	INT
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
		ISNULL(MAX([EDI].[EDIFile].[CreatedOn]), GETDATE()) AS [DOS_FROM]
		, GETDATE() AS [DOS_TO]
	FROM
		[EDI].[EDIFile]
	
	WHERE
		[EDI].[EDIFile].[EDIFileID] IN
		(
			SELECT
				[Claim].[ClaimProcessEDIFile].[EDIFileID]
			FROM
				[Claim].[ClaimProcessEDIFile]
			INNER JOIN
				[Claim].[ClaimProcess]
			ON
				[Claim].[ClaimProcess].[ClaimProcessID] = [Claim].[ClaimProcessEDIFile].[ClaimProcessID]
			INNER JOIN
				[Patient].[PatientVisit]
			ON
				[Patient].[PatientVisit].[PatientVisitID] = [Claim].[ClaimProcess].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[Patient].[ClinicID] = @ClinicID
		)
	AND
		[EDI].[EDIFile].[IsActive] = 1;	
		
		
		
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
		
	-- EXEC [EDI].[usp_GetDate_EDIFile] @ClinicID = 2, @ClaimStatusID = 1
END
GO
