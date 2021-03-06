USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_IsExists_Password]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_IsExists_Password]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Configuration].[usp_IsExists_Password]
	@MinLength TINYINT
	, @MaxLength TINYINT
	, @UpperCaseMinCount TINYINT
	, @NumberMinCount TINYINT
	, @SplCharCount TINYINT
	, @ExpiryDayMaxCount TINYINT
	, @TrialMaxCount TINYINT
	, @HistoryReuseStatus TINYINT
	, @PasswordID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @PasswordID = [Configuration].[ufn_IsExists_Password] (@MinLength, @MaxLength, @UpperCaseMinCount, @NumberMinCount, @SplCharCount, @ExpiryDayMaxCount, @TrialMaxCount, @HistoryReuseStatus, 0);
END
GO
