USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByPkId_IPA]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByPkId_IPA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetByPkId_IPA] 
	@IPAID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Billing].[IPA].*
	FROM
		[Billing].[IPA]
	WHERE
		[Billing].[IPA].[IPAID] = @IPAID
	AND
		[Billing].[IPA].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[IPA].[IsActive] ELSE @IsActive END;

	-- EXEC [Billing].[usp_GetByPkId_IPA] 1, NULL
	-- EXEC [Billing].[usp_GetByPkId_IPA] 1, 1
	-- EXEC [Billing].[usp_GetByPkId_IPA] 1, 0
END
GO
