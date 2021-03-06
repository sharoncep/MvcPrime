USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_TransactionTypeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_TransactionTypeCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_TransactionTypeCode] 
	@TransactionTypeCodeID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[TransactionTypeCode].*
	FROM
		[Transaction].[TransactionTypeCode]
	WHERE
		[Transaction].[TransactionTypeCode].[TransactionTypeCodeID] = @TransactionTypeCodeID
	AND
		[Transaction].[TransactionTypeCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[TransactionTypeCode].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_TransactionTypeCode] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_TransactionTypeCode] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_TransactionTypeCode] 1, 0
END
GO
