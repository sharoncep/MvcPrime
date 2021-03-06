USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_CurrencyCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_CurrencyCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_CurrencyCode]
	@CurrencyCodeCode NVARCHAR(3)
	, @CurrencyCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrencyCodeID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @CurrencyCodeID = [Transaction].[ufn_IsExists_CurrencyCode] (@CurrencyCodeCode, @CurrencyCodeName, @Comment, 0);
END
GO
