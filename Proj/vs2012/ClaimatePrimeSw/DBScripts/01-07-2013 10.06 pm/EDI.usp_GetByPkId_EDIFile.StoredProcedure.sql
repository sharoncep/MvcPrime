USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetByPkId_EDIFile]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetByPkId_EDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [EDI].[usp_GetByPkId_EDIFile] 
	@EDIFileID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[EDI].[EDIFile].*
	FROM
		[EDI].[EDIFile]
	WHERE
		[EDI].[EDIFile].[EDIFileID] = @EDIFileID
	AND
		[EDI].[EDIFile].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[EDIFile].[IsActive] ELSE @IsActive END;

	-- EXEC [EDI].[usp_GetByPkId_EDIFile] 1, NULL
	-- EXEC [EDI].[usp_GetByPkId_EDIFile] 1, 1
	-- EXEC [EDI].[usp_GetByPkId_EDIFile] 1, 0
END
GO
