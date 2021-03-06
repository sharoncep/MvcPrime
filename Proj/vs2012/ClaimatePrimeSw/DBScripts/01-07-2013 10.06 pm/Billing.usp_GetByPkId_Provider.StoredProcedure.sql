USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByPkId_Provider]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByPkId_Provider]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetByPkId_Provider] 
	@ProviderID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Billing].[Provider].*
	FROM
		[Billing].[Provider]
	WHERE
		[Billing].[Provider].[ProviderID] = @ProviderID
	AND
		[Billing].[Provider].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Provider].[IsActive] ELSE @IsActive END;

	-- EXEC [Billing].[usp_GetByPkId_Provider] 1, NULL
	-- EXEC [Billing].[usp_GetByPkId_Provider] 1, 1
	-- EXEC [Billing].[usp_GetByPkId_Provider] 1, 0
END
GO
