USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetNameByID_IPA]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetNameByID_IPA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetNameByID_IPA] 
	@IPAID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[Billing].[IPA].[IPAID]
		,[Billing].[IPA].[IPAName]+ ' [' + [Billing].[IPA].[IPACode] + ']' AS [NAME_CODE]	
	FROM
		[Billing].[IPA]
	WHERE
		@IPAID = [Billing].[IPA].[IPAID]
	AND
		[Billing].[IPA].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[IPA].[IsActive] ELSE @IsActive END;

	-- EXEC [Billing].[usp_GetNameByID_IPA] 1, NULL
	-- EXEC [Billing].[usp_GetNameByID_IPA] 1, 1
	-- EXEC [Billing].[usp_GetNameByID_IPA] 1, 0
END
GO
