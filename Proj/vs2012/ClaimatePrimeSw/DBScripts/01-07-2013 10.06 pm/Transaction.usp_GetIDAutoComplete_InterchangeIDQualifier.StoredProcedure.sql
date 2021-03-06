USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetIDAutoComplete_InterchangeIDQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetIDAutoComplete_InterchangeIDQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetIDAutoComplete_InterchangeIDQualifier] 
	@InterchangeIDQualifierCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [InterchangeIDQualifier_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierID]
	FROM
		[Transaction].[InterchangeIDQualifier]
	WHERE
		@InterchangeIDQualifierCode = [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode]
	AND
		[Transaction].[InterchangeIDQualifier].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Transaction].[usp_GetIDAutoComplete_InterchangeIDQualifier] 1, NULL
	-- EXEC [Transaction].[usp_GetIDAutoComplete_InterchangeIDQualifier] 1, 1
	-- EXEC [Transaction].[usp_GetIDAutoComplete_InterchangeIDQualifier] 1, 0
END
GO
