USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_CurrencyCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_CurrencyCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_CurrencyCode] 
	@CurrencyCodeID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[CurrencyCode].*
	FROM
		[Transaction].[CurrencyCode]
	WHERE
		[Transaction].[CurrencyCode].[CurrencyCodeID] = @CurrencyCodeID
	AND
		[Transaction].[CurrencyCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[CurrencyCode].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_CurrencyCode] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_CurrencyCode] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_CurrencyCode] 1, 0
END
GO
