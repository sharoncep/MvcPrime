USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetIDAutoComplete_Insurance]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetIDAutoComplete_Insurance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Insurance].[usp_GetIDAutoComplete_Insurance] 
	@InsuranceCode	nvarchar(9)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [INSURANCE_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Insurance].[Insurance].[InsuranceID]
	FROM
		[Insurance].[Insurance]
	WHERE
		@InsuranceCode = [Insurance].[Insurance].[InsuranceCode]
	AND
		[Insurance].[Insurance].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Insurance].[usp_GetByPkId_Insurance] 1, NULL
	-- EXEC [Insurance].[usp_GetByPkId_Insurance] 1, 1
	-- EXEC [Insurance].[usp_GetByPkId_Insurance] 1, 0
END
GO
