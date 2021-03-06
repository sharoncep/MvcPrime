USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByID_FacilityDone]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByID_FacilityDone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetByID_FacilityDone] 
	@PatientVisitID BIGINT
AS
BEGIN
	SET NOCOUNT ON;	

	
	SELECT
		[Billing].[FacilityDone].*
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Billing].[FacilityDone]
	ON
		[Billing].[FacilityDone].[FacilityDoneID] = [Patient].[PatientVisit].[FacilityDoneID]
	WHERE
		[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID 
	AND
		[Patient].[PatientVisit].[IsActive]=1;
	
	-- EXEC [Billing].[usp_GetByID_FacilityDone]  7
	
END
GO
