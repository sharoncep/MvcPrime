USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByPatientID_Provider]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByPatientID_Provider]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetByPatientID_Provider]
	@PatientID	BIGINT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT
		[Billing].[Provider].*
	FROM
		[Billing].[Provider]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	WHERE
		 [Patient].[Patient].[PatientID] = @PatientID
	
	-- EXEC [Billing].[usp_GetByPatientID_Provider] @PatientID = 4
END
GO
