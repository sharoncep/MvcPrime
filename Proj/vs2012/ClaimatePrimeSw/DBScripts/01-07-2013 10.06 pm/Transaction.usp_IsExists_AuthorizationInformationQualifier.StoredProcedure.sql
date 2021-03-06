USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_AuthorizationInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_AuthorizationInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_AuthorizationInformationQualifier]
	@AuthorizationInformationQualifierCode NVARCHAR(2)
	, @AuthorizationInformationQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @AuthorizationInformationQualifierID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @AuthorizationInformationQualifierID = [Transaction].[ufn_IsExists_AuthorizationInformationQualifier] (@AuthorizationInformationQualifierCode, @AuthorizationInformationQualifierName, @Comment, 0);
END
GO
