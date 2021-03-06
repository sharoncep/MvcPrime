USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetNameByID_Provider]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetNameByID_Provider]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetNameByID_Provider] 
	@ProviderID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ProviderName] NVARCHAR(350) NOT NULL 
		, [ProviderCode] NVARCHAR(9) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		(LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [ProviderName], [Billing].[Provider].[ProviderCode]
	FROM
		[Billing].[Provider]
	WHERE
		@ProviderID = [Billing].[Provider].[ProviderID]
	AND
		[Billing].[Provider].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Provider].[IsActive] ELSE @IsActive END;

		SELECT * FROM @TBL_RES;

	-- EXEC [Billing].[usp_GetNameByID_Provider] 1, NULL
	-- EXEC [Billing].[usp_GetNameByID_Provider] 1, 1
	-- EXEC [Billing].[usp_GetNameByID_Provider] 1, 0
END
GO
