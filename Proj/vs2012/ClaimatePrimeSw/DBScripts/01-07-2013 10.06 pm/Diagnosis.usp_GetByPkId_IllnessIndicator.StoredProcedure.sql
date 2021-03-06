USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetByPkId_IllnessIndicator]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetByPkId_IllnessIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Diagnosis].[usp_GetByPkId_IllnessIndicator] 
	@IllnessIndicatorID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Diagnosis].[IllnessIndicator].*
	FROM
		[Diagnosis].[IllnessIndicator]
	WHERE
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = @IllnessIndicatorID
	AND
		[Diagnosis].[IllnessIndicator].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[IllnessIndicator].[IsActive] ELSE @IsActive END;

	-- EXEC [Diagnosis].[usp_GetByPkId_IllnessIndicator] 1, NULL
	-- EXEC [Diagnosis].[usp_GetByPkId_IllnessIndicator] 1, 1
	-- EXEC [Diagnosis].[usp_GetByPkId_IllnessIndicator] 1, 0
END
GO
