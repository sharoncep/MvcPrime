USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetIDAutoComplete_Credential]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetIDAutoComplete_Credential]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetIDAutoComplete_Credential] 
	@CredentialCode	NVARCHAR(17)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] TINYINT NOT NULL IDENTITY (1, 1)
		, [CredentialID] TINYINT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Billing].[Credential].[CredentialID]
	FROM
		[Billing].[Credential]
	WHERE
		@CredentialCode = [Billing].[Credential].[CredentialCode]
	AND
		[Billing].[Credential].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Billing].[usp_GetIDAutoComplete_Credential] 'D.O.'
	
END
GO
