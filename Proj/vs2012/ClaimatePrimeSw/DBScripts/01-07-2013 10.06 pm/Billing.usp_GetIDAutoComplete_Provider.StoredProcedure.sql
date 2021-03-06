USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetIDAutoComplete_Provider]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetIDAutoComplete_Provider]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetIDAutoComplete_Provider] 
	@ProviderCode	nvarchar(9)
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [PROVIDER_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Billing].[Provider].[ProviderID]
	FROM
		[Billing].[Provider]
	WHERE
		@ProviderCode = [Billing].[Provider].[ProviderCode]
	AND
		[Billing].[Provider].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Billing].[usp_GetByPkId_Provider] 1, NULL
	-- EXEC [Billing].[usp_GetByPkId_Provider] 1, 1
	-- EXEC [Billing].[usp_GetByPkId_Provider] 1, 0
END
GO
