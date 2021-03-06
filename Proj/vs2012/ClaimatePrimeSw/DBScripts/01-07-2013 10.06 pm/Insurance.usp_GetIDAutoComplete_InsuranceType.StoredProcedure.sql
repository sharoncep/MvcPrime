USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetIDAutoComplete_InsuranceType]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetIDAutoComplete_InsuranceType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Insurance].[usp_GetIDAutoComplete_InsuranceType] 
	@InsuranceTypeCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [InsuranceType_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Insurance].[InsuranceType].[InsuranceTypeID]
	FROM
		[Insurance].[InsuranceType]
	WHERE
		@InsuranceTypeCode = [Insurance].[InsuranceType].[InsuranceTypeCode]
	AND
		[Insurance].[InsuranceType].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Insurance].[usp_GetByPkId_InsuranceType] 1, NULL
	-- EXEC [Insurance].[usp_GetByPkId_InsuranceType] 1, 1
	-- EXEC [Insurance].[usp_GetByPkId_InsuranceType] 1, 0
END
GO
