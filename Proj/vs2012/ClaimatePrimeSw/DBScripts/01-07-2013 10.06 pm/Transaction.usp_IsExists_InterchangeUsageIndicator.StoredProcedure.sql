USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_InterchangeUsageIndicator]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_InterchangeUsageIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_InterchangeUsageIndicator]
	@InterchangeUsageIndicatorCode NVARCHAR(1)
	, @InterchangeUsageIndicatorName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @InterchangeUsageIndicatorID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @InterchangeUsageIndicatorID = [Transaction].[ufn_IsExists_InterchangeUsageIndicator] (@InterchangeUsageIndicatorCode, @InterchangeUsageIndicatorName, @Comment, 0);
END
GO
