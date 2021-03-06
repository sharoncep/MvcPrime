USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_TransactionSetPurposeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_TransactionSetPurposeCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_TransactionSetPurposeCode]
	@TransactionSetPurposeCodeCode NVARCHAR(2)
	, @TransactionSetPurposeCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @TransactionSetPurposeCodeID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @TransactionSetPurposeCodeID = [Transaction].[ufn_IsExists_TransactionSetPurposeCode] (@TransactionSetPurposeCodeCode, @TransactionSetPurposeCodeName, @Comment, 0);
END
GO
