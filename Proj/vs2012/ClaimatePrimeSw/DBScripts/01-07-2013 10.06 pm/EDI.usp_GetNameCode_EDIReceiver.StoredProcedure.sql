USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetNameCode_EDIReceiver]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetNameCode_EDIReceiver]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetNameCode_EDIReceiver] 
	@ClinicID INT
	, @StatusIDs NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[EDI].[EDIReceiver].[EDIReceiverID]
		, [EDI].[EDIReceiver].[EDIReceiverName] + ' [' + [EDI].[EDIReceiver].[EDIReceiverCode] +']' AS [NAME_CODE]
		, (SELECT
		COUNT ([Patient].[PatientVisit].[PatientVisitID]) AS [EDIReceiver837Count]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		INNER JOIN
			[Billing].[Provider]
		ON
			[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
		INNER JOIN
			[Insurance].[Insurance]
		ON
			[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
		WHERE
			[Patient].[Patient].[ClinicID] = @ClinicID
		AND
			[Insurance].[Insurance].[EDIReceiverID] = [EDI].[EDIReceiver].[EDIReceiverID]
		AND
			[Patient].[PatientVisit].[ClaimStatusID] IN
			(
				SELECT 
					[Data] 
				FROM 
					[dbo].[ufn_StringSplit] (@StatusIDs, ',')
			)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1
		AND
			[Insurance].[Insurance].[IsActive] = 1) AS [ClaimCount]
	FROM
		[EDI].[EDIReceiver]
	WHERE
		[EDI].[EDIReceiver].[IsActive] = 1;
			
	-- EXEC [EDI].[usp_GetNameCode_EDIReceiver]  @ClinicID = 1 , @StatusIDs ='16,17,18,19,20'
	-- EXEC [EDI].[usp_GetNameCode_EDIReceiver] 
	-- EXEC [EDI].[usp_GetNameCode_EDIReceiver] 
END
GO
