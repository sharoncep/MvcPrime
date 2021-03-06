USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetByPkId_CPT]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetByPkId_CPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Diagnosis].[usp_GetByPkId_CPT] 
	@CPTID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Diagnosis].[CPT].*
	FROM
		[Diagnosis].[CPT]
	WHERE
		[Diagnosis].[CPT].[CPTID] = @CPTID
	AND
		[Diagnosis].[CPT].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[CPT].[IsActive] ELSE @IsActive END;

	-- EXEC [Diagnosis].[usp_GetByPkId_CPT] 1, NULL
	-- EXEC [Diagnosis].[usp_GetByPkId_CPT] 1, 1
	-- EXEC [Diagnosis].[usp_GetByPkId_CPT] 1, 0
END
GO
