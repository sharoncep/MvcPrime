USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetIDAutoComplete_CurrencyCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetIDAutoComplete_CurrencyCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetIDAutoComplete_CurrencyCode] 
	@CurrencyCodeCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CurrencyCode_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Transaction].[CurrencyCode].[CurrencyCodeID]
	FROM
		[Transaction].[CurrencyCode]
	WHERE
		@CurrencyCodeCode = [Transaction].[CurrencyCode].[CurrencyCodeCode]
	AND
		[Transaction].[CurrencyCode].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Transaction].[usp_GetIDAutoComplete_CurrencyCode] '85'
	
END
GO
