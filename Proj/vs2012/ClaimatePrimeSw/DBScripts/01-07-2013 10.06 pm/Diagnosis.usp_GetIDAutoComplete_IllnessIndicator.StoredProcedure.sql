USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetIDAutoComplete_IllnessIndicator]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetIDAutoComplete_IllnessIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Diagnosis].[usp_GetIDAutoComplete_IllnessIndicator] 
	@IllnessIndicatorCode	NVARCHAR(2)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorID], [Diagnosis].[IllnessIndicator].[IllnessIndicatorCode]
	FROM
		[Diagnosis].[IllnessIndicator]
	WHERE
		@IllnessIndicatorCode = [Diagnosis].[IllnessIndicator].[IllnessIndicatorCode]
	AND
		[Diagnosis].[IllnessIndicator].[IsActive] = 1;

	-- EXEC [Diagnosis].[usp_GetIDAutoComplete_IllnessIndicator] '00'
	-- EXEC [Diagnosis].[usp_GetIDAutoComplete_IllnessIndicator] 1, 1
	-- EXEC [Diagnosis].[usp_GetIDAutoComplete_IllnessIndicator] 1, 0
END
GO
