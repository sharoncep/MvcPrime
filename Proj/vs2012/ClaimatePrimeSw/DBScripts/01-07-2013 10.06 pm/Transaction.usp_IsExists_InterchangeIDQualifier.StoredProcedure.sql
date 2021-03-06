USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_InterchangeIDQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_InterchangeIDQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_InterchangeIDQualifier]
	@InterchangeIDQualifierCode NVARCHAR(2)
	, @InterchangeIDQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @InterchangeIDQualifierID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @InterchangeIDQualifierID = [Transaction].[ufn_IsExists_InterchangeIDQualifier] (@InterchangeIDQualifierCode, @InterchangeIDQualifierName, @Comment, 0);
END
GO
