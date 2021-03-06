USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetByPatientID_Insurance]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetByPatientID_Insurance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Insurance].[usp_GetByPatientID_Insurance]
	@PatientID	BIGINT 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT
		[Insurance].[Insurance].*
	FROM
		[Insurance].[Insurance]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	WHERE
		 [Patient].[Patient].[PatientID] = @PatientID
	
	-- EXEC [Insurance].[usp_GetByPatientID_Insurance] @PatientID = 4
END
GO
