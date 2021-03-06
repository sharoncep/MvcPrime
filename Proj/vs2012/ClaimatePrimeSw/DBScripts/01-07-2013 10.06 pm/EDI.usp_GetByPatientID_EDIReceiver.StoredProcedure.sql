USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetByPatientID_EDIReceiver]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetByPatientID_EDIReceiver]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetByPatientID_EDIReceiver]
	@PatientID	BIGINT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT
		[EDI].[EDIReceiver].*
	FROM
		[EDI].[EDIReceiver]
	INNER JOIN
		[Insurance].[Insurance]
	ON
		[Insurance].[Insurance].[EDIReceiverID]=[EDI].[EDIReceiver].[EDIReceiverID]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[InsuranceID] = [Insurance].[Insurance].[InsuranceID]
	WHERE
		 [Patient].[Patient].[PatientID] = @PatientID
	
	-- EXEC [EDI].[usp_GetByPatientID_EDIReceiver] @PatientID = 1
END
GO
