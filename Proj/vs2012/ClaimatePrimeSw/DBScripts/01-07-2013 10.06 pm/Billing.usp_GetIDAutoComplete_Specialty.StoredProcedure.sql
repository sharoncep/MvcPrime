USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetIDAutoComplete_Specialty]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetIDAutoComplete_Specialty]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetIDAutoComplete_Specialty] 
	@SpecialtyCode	NVARCHAR(17)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] TINYINT NOT NULL IDENTITY (1, 1)
		, [SpecialtyID] TINYINT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Billing].[Specialty].[SpecialtyID]
	FROM
		[Billing].[Specialty]
	WHERE
		@SpecialtyCode = [Billing].[Specialty].[SpecialtyCode]
	AND
		[Billing].[Specialty].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Billing].[usp_GetIDAutoComplete_Specialty] '171100000X'
	
END
GO
