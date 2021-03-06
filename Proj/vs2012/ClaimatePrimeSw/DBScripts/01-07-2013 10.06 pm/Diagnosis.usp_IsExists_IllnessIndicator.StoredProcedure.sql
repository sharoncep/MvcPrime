USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_IsExists_IllnessIndicator]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_IsExists_IllnessIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Diagnosis].[usp_IsExists_IllnessIndicator]
	@IllnessIndicatorCode NVARCHAR(2)
	, @IllnessIndicatorName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IllnessIndicatorID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @IllnessIndicatorID = [Diagnosis].[ufn_IsExists_IllnessIndicator] (@IllnessIndicatorCode, @IllnessIndicatorName, @Comment, 0);
END
GO
