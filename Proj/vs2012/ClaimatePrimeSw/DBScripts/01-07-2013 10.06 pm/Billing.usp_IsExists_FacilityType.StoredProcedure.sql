USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_IsExists_FacilityType]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_IsExists_FacilityType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Billing].[usp_IsExists_FacilityType]
	@FacilityTypeCode NVARCHAR(2)
	, @FacilityTypeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @FacilityTypeID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @FacilityTypeID = [Billing].[ufn_IsExists_FacilityType] (@FacilityTypeCode, @FacilityTypeName, @Comment, 0);
END
GO
