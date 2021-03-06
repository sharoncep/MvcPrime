USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_TransactionSetPurposeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_TransactionSetPurposeCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_TransactionSetPurposeCode] 
	@TransactionSetPurposeCodeID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[TransactionSetPurposeCode].*
	FROM
		[Transaction].[TransactionSetPurposeCode]
	WHERE
		[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID] = @TransactionSetPurposeCodeID
	AND
		[Transaction].[TransactionSetPurposeCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[TransactionSetPurposeCode].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_TransactionSetPurposeCode] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_TransactionSetPurposeCode] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_TransactionSetPurposeCode] 1, 0
END
GO
