USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_GetByField_Password]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_GetByField_Password]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Configuration].[usp_GetByField_Password] 
	@FieldName	VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[COLUMN_NAME] [NVARCHAR](150) NOT NULL
		, [COLUMN_VALUE] [INT] NOT NULL
	);
	
	INSERT INTO 
		@TBL_ANS 
		([COLUMN_NAME], [COLUMN_VALUE])
	VALUES 
		('MinLength', ISNULL((SELECT [MinLength] FROM [Configuration].[Password] WHERE [PasswordID] = 1 AND [IsActive] = 1), 0)),
		('MaxLength', ISNULL((SELECT [MaxLength] FROM [Configuration].[Password] WHERE [PasswordID] = 1 AND [IsActive] = 1), 0)),
		('UpperClaimMinCount', ISNULL((SELECT [UpperCaseMinCount] FROM [Configuration].[Password] WHERE [PasswordID] = 1 AND [IsActive] = 1), 0)),
		('NumberMinCount', ISNULL((SELECT [NumberMinCount] FROM [Configuration].[Password] WHERE [PasswordID] = 1 AND [IsActive] = 1), 0)),
		('SplCharCount', ISNULL((SELECT [SplCharCount] FROM [Configuration].[Password] WHERE [PasswordID] = 1 AND [IsActive] = 1), 0)),
		('ExpiryDayMaxCount', ISNULL((SELECT [ExpiryDayMaxCount] FROM [Configuration].[Password] WHERE [PasswordID] = 1 AND [IsActive] = 1), 0)),
		('TrialMaxCount', ISNULL((SELECT [TrialMaxCount] FROM [Configuration].[Password] WHERE [PasswordID] = 1 AND [IsActive] = 1), 0)),
		('HistoryReuseStatus', ISNULL((SELECT [HistoryReuseStatus] FROM [Configuration].[Password] WHERE [PasswordID] = 1 AND [IsActive] = 1), 0));
	
	SELECT
		[COLUMN_VALUE]
	FROM 
		@TBL_ANS
	WHERE
		[COLUMN_NAME] = @FieldName;

	--DECLARE @QRRY NVARCHAR(3999);
	--SELECT @QRRY = 'SELECT [' + @FieldName + '] FROM [Configuration].[Password]';
	--SELECT @QRRY;

	-- EXEC [Configuration].[usp_GetByField_Password] 'MaxLength'
	
END
GO
