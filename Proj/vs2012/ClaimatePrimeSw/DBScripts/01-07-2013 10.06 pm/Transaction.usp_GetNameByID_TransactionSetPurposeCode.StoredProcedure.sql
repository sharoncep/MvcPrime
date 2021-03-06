USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetNameByID_TransactionSetPurposeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetNameByID_TransactionSetPurposeCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [Transaction].[usp_GetNameByID_TransactionSetPurposeCode] 
	@TransactionSetPurposeCodeID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID]
		,[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeName]+ ' [' + [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeCode] + ']' AS [NAME_CODE]	
	FROM
		[Transaction].[TransactionSetPurposeCode]
	WHERE
		@TransactionSetPurposeCodeID = [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID]
	AND
		[Transaction].[TransactionSetPurposeCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[TransactionSetPurposeCode].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetNameByID_TransactionSetPurposeCode] 1, NULL
	-- EXEC [Transaction].[usp_GetNameByID_TransactionSetPurposeCode] 1, 1
	-- EXEC [Transaction].[usp_GetNameByID_TransactionSetPurposeCode] 1, 0
END
GO
