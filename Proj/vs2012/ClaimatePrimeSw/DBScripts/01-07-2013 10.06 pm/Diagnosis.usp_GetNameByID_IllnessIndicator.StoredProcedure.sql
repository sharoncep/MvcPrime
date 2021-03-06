USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetNameByID_IllnessIndicator]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetNameByID_IllnessIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Diagnosis].[usp_GetNameByID_IllnessIndicator] 
	@IllnessIndicatorID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [NAME_CODE] NVARCHAR(500) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		([Diagnosis].[IllnessIndicator].[IllnessIndicatorName] + ' [' +[Diagnosis].[IllnessIndicator].[IllnessIndicatorCode] + ']') AS [NAME_CODE]
	FROM
		[Diagnosis].[IllnessIndicator]
	WHERE
		@IllnessIndicatorID = [Diagnosis].[IllnessIndicator].[IllnessIndicatorID]
	AND
		[Diagnosis].[IllnessIndicator].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[IllnessIndicator].[IsActive] ELSE @IsActive END;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Diagnosis].[usp_GetNameByID_IllnessIndicator] 8, NULL
	
END
GO
