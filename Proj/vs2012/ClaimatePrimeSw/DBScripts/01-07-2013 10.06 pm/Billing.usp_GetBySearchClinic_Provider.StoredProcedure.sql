USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetBySearchClinic_Provider]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetBySearchClinic_Provider]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetBySearchClinic_Provider]
	@StartBy VARCHAR(1) = NULL
	, @ClinicID int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT
		(LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		
		, [Billing].[Provider].[ProviderID]
		
	FROM
		[Billing].[Provider]   	
	WHERE 
	[Billing].[Provider].[LastName]	
	LIKE 
		@StartBy + '%'
	AND
		[Billing].[Provider].[ClinicID] = @ClinicID
	AND
		[Billing].[Provider].[IsActive] = 1
	ORDER BY
		1 ASC;
	
	-- EXEC [Billing].[usp_GetBySearch_Clinic] @UserID = 101 , @StartBy='A'
END
GO
