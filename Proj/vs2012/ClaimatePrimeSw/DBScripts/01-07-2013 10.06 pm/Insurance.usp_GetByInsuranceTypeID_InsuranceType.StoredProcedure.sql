USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetByInsuranceTypeID_InsuranceType]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetByInsuranceTypeID_InsuranceType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Insurance].[usp_GetByInsuranceTypeID_InsuranceType]
	@InsuranceID	BIGINT 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT
		[Insurance].[InsuranceType].[InsuranceTypeID] ,[Insurance].[InsuranceType].[InsuranceTypeName] + ' [' + [Insurance].[InsuranceType].[InsuranceTypeCode] + ']' as [NAME_CODE]
	FROM
		[Insurance].[InsuranceType]
	INNER JOIN
		[Insurance].[Insurance]
	ON
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
	WHERE
		 [Insurance].[Insurance].[InsuranceID] = @InsuranceID
	
	-- EXEC [Insurance].[usp_GetByInsuranceTypeID_InsuranceType] @InsuranceID = 1
END
GO
