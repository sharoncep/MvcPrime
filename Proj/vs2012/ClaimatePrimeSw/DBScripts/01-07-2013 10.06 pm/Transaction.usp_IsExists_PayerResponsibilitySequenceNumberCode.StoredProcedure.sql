USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_PayerResponsibilitySequenceNumberCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_PayerResponsibilitySequenceNumberCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_PayerResponsibilitySequenceNumberCode]
	@PayerResponsibilitySequenceNumberCodeCode NVARCHAR(1)
	, @PayerResponsibilitySequenceNumberCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @PayerResponsibilitySequenceNumberCodeID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @PayerResponsibilitySequenceNumberCodeID = [Transaction].[ufn_IsExists_PayerResponsibilitySequenceNumberCode] (@PayerResponsibilitySequenceNumberCodeCode, @PayerResponsibilitySequenceNumberCodeName, @Comment, 0);
END
GO
