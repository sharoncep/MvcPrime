USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_SecurityInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_SecurityInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_SecurityInformationQualifier]
	@SecurityInformationQualifierCode NVARCHAR(2)
	, @SecurityInformationQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @SecurityInformationQualifierID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @SecurityInformationQualifierID = [Transaction].[ufn_IsExists_SecurityInformationQualifier] (@SecurityInformationQualifierCode, @SecurityInformationQualifierName, @Comment, 0);
END
GO
