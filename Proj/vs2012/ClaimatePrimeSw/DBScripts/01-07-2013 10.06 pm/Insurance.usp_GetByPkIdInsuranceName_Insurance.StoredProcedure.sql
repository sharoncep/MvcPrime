USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetByPkIdInsuranceName_Insurance]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetByPkIdInsuranceName_Insurance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Insurance].[usp_GetByPkIdInsuranceName_Insurance] 
	@InsuranceID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[InsuranceName] NVARCHAR(150) NOT NULL 
		, [InsuranceCode] NVARCHAR(9) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Insurance].[Insurance].[InsuranceName],[Insurance].[Insurance].[InsuranceCode]
	FROM
		[Insurance].[Insurance]
	WHERE
		@InsuranceID = [Insurance].[Insurance].[InsuranceID]
	AND
		[Insurance].[Insurance].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Insurance].[Insurance].[IsActive] ELSE @IsActive END;
		
	SELECT * FROM @TBL_RES;
	
	-- EXEC [Insurance].[usp_GetByPkIdInsuranceName_Insurance] 1, NULL
	-- EXEC [Insurance].[usp_GetByPkIdInsuranceName_Insurance] 1, 1
	-- EXEC [Insurance].[usp_GetByPkIdInsuranceName_Insurance] 1, 0
END
GO
