USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetIDAutoComplete_AuthorizationInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetIDAutoComplete_AuthorizationInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetIDAutoComplete_AuthorizationInformationQualifier] 
	@AuthorizationInformationQualifierCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [AuthorizationInformationQualifier_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID]
	FROM
		[Transaction].[AuthorizationInformationQualifier]
	WHERE
		@AuthorizationInformationQualifierCode = [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode]
	AND
		[Transaction].[AuthorizationInformationQualifier].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Transaction].[usp_GetByPkId_AuthorizationInformationQualifier] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_AuthorizationInformationQualifier] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_AuthorizationInformationQualifier] 1, 0
END
GO
