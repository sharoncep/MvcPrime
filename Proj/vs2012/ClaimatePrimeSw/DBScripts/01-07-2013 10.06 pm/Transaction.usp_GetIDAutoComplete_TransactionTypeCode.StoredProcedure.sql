USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetIDAutoComplete_TransactionTypeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetIDAutoComplete_TransactionTypeCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetIDAutoComplete_TransactionTypeCode] 
	@TransactionTypeCodeCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [TransactionTypeCode_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Transaction].[TransactionTypeCode].[TransactionTypeCodeID]
	FROM
		[Transaction].[TransactionTypeCode]
	WHERE
		@TransactionTypeCodeCode = [Transaction].[TransactionTypeCode].[TransactionTypeCodeCode]
	AND
		[Transaction].[TransactionTypeCode].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Transaction].[usp_GetIDAutoComplete_TransactionTypeCode] 1, NULL
	-- EXEC [Transaction].[usp_GetIDAutoComplete_TransactionTypeCode] 1, 1
	-- EXEC [Transaction].[usp_GetIDAutoComplete_TransactionTypeCode] 1, 0
END
GO
