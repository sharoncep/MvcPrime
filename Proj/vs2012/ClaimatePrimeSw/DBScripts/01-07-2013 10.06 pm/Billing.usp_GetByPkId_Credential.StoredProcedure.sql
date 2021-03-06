USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByPkId_Credential]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByPkId_Credential]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetByPkId_Credential] 
	@CredentialID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Billing].[Credential].*
	FROM
		[Billing].[Credential]
	WHERE
		[Billing].[Credential].[CredentialID] = @CredentialID
	AND
		[Billing].[Credential].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Credential].[IsActive] ELSE @IsActive END;

	-- EXEC [Billing].[usp_GetByPkId_Credential] 1, NULL
	-- EXEC [Billing].[usp_GetByPkId_Credential] 1, 1
	-- EXEC [Billing].[usp_GetByPkId_Credential] 1, 0
END
GO
