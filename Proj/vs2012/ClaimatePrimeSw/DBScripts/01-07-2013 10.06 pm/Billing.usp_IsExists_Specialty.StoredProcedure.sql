USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_IsExists_Specialty]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_IsExists_Specialty]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Billing].[usp_IsExists_Specialty]
	@SpecialtyCode NVARCHAR(15)
	, @SpecialtyName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @SpecialtyID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @SpecialtyID = [Billing].[ufn_IsExists_Specialty] (@SpecialtyCode, @SpecialtyName, @Comment, 0);
END
GO
