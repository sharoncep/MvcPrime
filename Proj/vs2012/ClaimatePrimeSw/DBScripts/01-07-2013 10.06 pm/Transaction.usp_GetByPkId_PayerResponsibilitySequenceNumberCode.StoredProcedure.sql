USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_PayerResponsibilitySequenceNumberCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_PayerResponsibilitySequenceNumberCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_PayerResponsibilitySequenceNumberCode] 
	@PayerResponsibilitySequenceNumberCodeID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[PayerResponsibilitySequenceNumberCode].*
	FROM
		[Transaction].[PayerResponsibilitySequenceNumberCode]
	WHERE
		[Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID] = @PayerResponsibilitySequenceNumberCodeID
	AND
		[Transaction].[PayerResponsibilitySequenceNumberCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[PayerResponsibilitySequenceNumberCode].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_PayerResponsibilitySequenceNumberCode] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_PayerResponsibilitySequenceNumberCode] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_PayerResponsibilitySequenceNumberCode] 1, 0
END
GO
