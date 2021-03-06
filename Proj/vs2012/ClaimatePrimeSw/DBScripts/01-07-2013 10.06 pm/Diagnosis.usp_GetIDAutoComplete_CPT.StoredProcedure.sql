USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetIDAutoComplete_CPT]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetIDAutoComplete_CPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Diagnosis].[usp_GetIDAutoComplete_CPT] 
	@CPTCode	NVARCHAR(9)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] TINYINT NOT NULL IDENTITY (1, 1)
		, [CPTID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Diagnosis].[CPT].[CPTID]
	FROM
		[Diagnosis].[CPT]
	WHERE
		@CPTCode = [Diagnosis].[CPT].[CPTCode]
	AND
		[Diagnosis].[CPT].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Diagnosis].[usp_GetIDAutoComplete_CPT] '00100'
	
END
GO
