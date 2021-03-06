USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_IsExists_Credential]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_IsExists_Credential]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Billing].[usp_IsExists_Credential]
	@CredentialCode NVARCHAR(9)
	, @CredentialName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CredentialID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @CredentialID = [Billing].[ufn_IsExists_Credential] (@CredentialCode, @CredentialName, @Comment, 0);
END
GO
