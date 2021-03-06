USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_IsExists_InsuranceType]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_IsExists_InsuranceType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Insurance].[usp_IsExists_InsuranceType]
	@InsuranceTypeCode NVARCHAR(2)
	, @InsuranceTypeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @InsuranceTypeID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @InsuranceTypeID = [Insurance].[ufn_IsExists_InsuranceType] (@InsuranceTypeCode, @InsuranceTypeName, @Comment, 0);
END
GO
