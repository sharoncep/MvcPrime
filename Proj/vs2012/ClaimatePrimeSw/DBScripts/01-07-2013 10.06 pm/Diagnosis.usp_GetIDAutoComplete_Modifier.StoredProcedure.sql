USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetIDAutoComplete_Modifier]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetIDAutoComplete_Modifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Diagnosis].[usp_GetIDAutoComplete_Modifier] 
	@ModifierCode	NVARCHAR(9)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] TINYINT NOT NULL IDENTITY (1, 1)
		, [ModifierID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Diagnosis].[Modifier].[ModifierID]
	FROM
		[Diagnosis].[Modifier]
	WHERE
		@ModifierCode = [Diagnosis].[Modifier].[ModifierCode]
	AND
		[Diagnosis].[Modifier].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Diagnosis].[usp_GetIDAutoComplete_Modifier] '47'
	
END
GO
