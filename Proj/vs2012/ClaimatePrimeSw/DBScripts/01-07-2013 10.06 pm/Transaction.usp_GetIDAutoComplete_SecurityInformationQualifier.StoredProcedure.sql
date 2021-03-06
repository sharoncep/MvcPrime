USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetIDAutoComplete_SecurityInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetIDAutoComplete_SecurityInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetIDAutoComplete_SecurityInformationQualifier] 
	@SecurityInformationQualifierCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [SecurityInformationQualifier_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID]
	FROM
		[Transaction].[SecurityInformationQualifier]
	WHERE
		@SecurityInformationQualifierCode = [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierCode]
	AND
		[Transaction].[SecurityInformationQualifier].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Transaction].[usp_GetIDAutoComplete_SecurityInformationQualifier] 1, NULL
	-- EXEC [Transaction].[usp_GetIDAutoComplete_SecurityInformationQualifier] 1, 1
	-- EXEC [Transaction].[usp_GetIDAutoComplete_SecurityInformationQualifier] 1, 0
END
GO
