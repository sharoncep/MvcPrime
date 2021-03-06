USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetByPkId_Modifier]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetByPkId_Modifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Diagnosis].[usp_GetByPkId_Modifier] 
	@ModifierID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Diagnosis].[Modifier].*
	FROM
		[Diagnosis].[Modifier]
	WHERE
		[Diagnosis].[Modifier].[ModifierID] = @ModifierID
	AND
		[Diagnosis].[Modifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[Modifier].[IsActive] ELSE @IsActive END;

	-- EXEC [Diagnosis].[usp_GetByPkId_Modifier] 1, NULL
	-- EXEC [Diagnosis].[usp_GetByPkId_Modifier] 1, 1
	-- EXEC [Diagnosis].[usp_GetByPkId_Modifier] 1, 0
END
GO
