USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetIsPatVisitDoc_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetIsPatVisitDoc_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Billing].[usp_GetIsPatVisitDoc_Clinic] 
	@ClinicID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Billing].[Clinic].[ClinicID]
		,ISNULL( [Billing].[Clinic].[IsPatVisitDocManadatory], 0) AS [IsAttachmentMandatory]
	FROM
		[Billing].[Clinic]
	WHERE
		[Billing].[Clinic].[ClinicID] = @ClinicID;
			
	-- EXEC [Billing].[usp_GetIsPatVisitDoc_Clinic]  @ClinicID = 2
	
END
GO
