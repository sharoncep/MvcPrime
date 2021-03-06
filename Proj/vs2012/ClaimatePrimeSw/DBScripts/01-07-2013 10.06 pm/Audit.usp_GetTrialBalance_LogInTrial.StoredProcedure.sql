USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_GetTrialBalance_LogInTrial]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_GetTrialBalance_LogInTrial]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select a record from the table based on user name

CREATE PROCEDURE [Audit].[usp_GetTrialBalance_LogInTrial] 
	@Email NVARCHAR(128)
	, @TrialMaxCount TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [HAS_BALANCE] BIT NOT NULL
	);

	DECLARE @MAX_TRIAL_COUNT INT;
	SELECT @MAX_TRIAL_COUNT = @TrialMaxCount;
		
	DECLARE @TBL_TMP TABLE ([ID] BIGINT NOT NULL, [IsSuccess] BIT NOT NULL);

	INSERT INTO 
		@TBL_TMP 
	SELECT TOP (@MAX_TRIAL_COUNT) 
		[Audit].[LogInTrial].[LogInTrialID]
		, [Audit].[LogInTrial].[IsSuccess] 
	FROM 
		[Audit].[LogInTrial] 
	WHERE 
		[Audit].[LogInTrial].[TrialUserName] = @Email
	ORDER BY 
		[Audit].[LogInTrial].[LogInTrialID] 
	DESC;

	WHILE ((SELECT COUNT ([T].[ID]) FROM @TBL_TMP T) < @MAX_TRIAL_COUNT)
	BEGIN
		INSERT INTO 
			@TBL_TMP 
		SELECT
			0 AS [ID]
			, 1 AS [IsSuccess]
	END
		
	IF ((SELECT COUNT ([T].[ID]) FROM @TBL_TMP T WHERE [T].[IsSuccess] = 1) = 0)
	BEGIN
		INSERT INTO
			@TBL_RES
		SELECT CAST('0' AS BIT) AS [HAS_BALANCE];
	END
	ELSE
	BEGIN
		INSERT INTO
			@TBL_RES
		SELECT CAST('1' AS BIT) AS [HAS_BALANCE];
	END
	
	SELECT * FROM @TBL_RES;
	
	-- EXEC [Audit].[usp_GetTrialBalance_LogInTrial] 'sharon.joseph@in.arivameddata.com'	
END
GO
