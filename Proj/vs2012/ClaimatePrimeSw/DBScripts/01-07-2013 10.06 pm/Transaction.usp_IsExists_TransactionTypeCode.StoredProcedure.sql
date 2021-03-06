USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_TransactionTypeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_TransactionTypeCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_TransactionTypeCode]
	@TransactionTypeCodeCode NVARCHAR(2)
	, @TransactionTypeCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @TransactionTypeCodeID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @TransactionTypeCodeID = [Transaction].[ufn_IsExists_TransactionTypeCode] (@TransactionTypeCodeCode, @TransactionTypeCodeName, @Comment, 0);
END
GO
