USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetIDAutoComplete_EntityIdentifierCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetIDAutoComplete_EntityIdentifierCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetIDAutoComplete_EntityIdentifierCode] 
	@EntityIdentifierCodeCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [EntityIdentifierCode_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeID]
	FROM
		[Transaction].[EntityIdentifierCode]
	WHERE
		@EntityIdentifierCodeCode = [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeCode]
	AND
		[Transaction].[EntityIdentifierCode].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Transaction].[usp_GetIDAutoComplete_EntityIdentifierCode] '01', NULL
	-- EXEC [Transaction].[usp_GetIDAutoComplete_EntityIdentifierCode] 1, 1
	-- EXEC [Transaction].[usp_GetIDAutoComplete_EntityIdentifierCode] 1, 0
END
GO
