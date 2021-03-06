USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByClinicID_IPA]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByClinicID_IPA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetByClinicID_IPA]
	@ClinicID	BIGINT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT
		[Billing].[IPA].*
	FROM
		[Billing].[IPA]
	INNER JOIN
		[Billing].[Clinic]
	ON
		[Billing].[IPA].[IPAID] = [Billing].[Clinic].[IPAID]
	WHERE
		 [Billing].[Clinic].[ClinicID] = @ClinicID
	
	-- EXEC [Billing].[usp_GetByClinicID_IPA] @ClinicID = 2
END
GO
