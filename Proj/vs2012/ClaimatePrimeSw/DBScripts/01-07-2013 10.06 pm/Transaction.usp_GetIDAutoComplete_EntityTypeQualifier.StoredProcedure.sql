USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetIDAutoComplete_EntityTypeQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetIDAutoComplete_EntityTypeQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Transaction].[usp_GetIDAutoComplete_EntityTypeQualifier] 
	@EntityTypeQualifierCode	NVARCHAR(2)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] TINYINT NOT NULL IDENTITY (1, 1)
		, [EntityTypeQualifierID] TINYINT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID]
	FROM
		[Transaction].[EntityTypeQualifier]
	WHERE
		@EntityTypeQualifierCode = [Transaction].[EntityTypeQualifier].[EntityTypeQualifierCode]
	AND
		[Transaction].[EntityTypeQualifier].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Transaction].[usp_GetIDAutoComplete_EntityTypeQualifier] '00'
	
END
GO
