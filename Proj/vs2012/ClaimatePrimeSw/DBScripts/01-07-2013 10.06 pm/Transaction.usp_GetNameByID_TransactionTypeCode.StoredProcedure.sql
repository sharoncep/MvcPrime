USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetNameByID_TransactionTypeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetNameByID_TransactionTypeCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [Transaction].[usp_GetNameByID_TransactionTypeCode] 
	@TransactionTypeCodeID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[Transaction].[TransactionTypeCode].[TransactionTypeCodeID]
		,[Transaction].[TransactionTypeCode].[TransactionTypeCodeName]+ ' [' + [Transaction].[TransactionTypeCode].[TransactionTypeCodeCode] + ']' AS [NAME_CODE]	
	FROM
		[Transaction].[TransactionTypeCode]
	WHERE
		@TransactionTypeCodeID = [Transaction].[TransactionTypeCode].[TransactionTypeCodeID]
	AND
		[Transaction].[TransactionTypeCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[TransactionTypeCode].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetNameByID_TransactionTypeCode] 1, NULL
	-- EXEC [Transaction].[usp_GetNameByID_TransactionTypeCode] 1, 1
	-- EXEC [Transaction].[usp_GetNameByID_TransactionTypeCode] 1, 0
END
GO
