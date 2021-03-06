USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetByPkId_DocumentCategory]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetByPkId_DocumentCategory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetByPkId_DocumentCategory] 
	@DocumentCategoryID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[MasterData].[DocumentCategory].*
	FROM
		[MasterData].[DocumentCategory]
	WHERE
		[MasterData].[DocumentCategory].[DocumentCategoryID] = @DocumentCategoryID
	AND
		[MasterData].[DocumentCategory].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[DocumentCategory].[IsActive] ELSE @IsActive END;

	-- EXEC [MasterData].[usp_GetByPkId_DocumentCategory] 1, NULL
	-- EXEC [MasterData].[usp_GetByPkId_DocumentCategory] 1, 1
	-- EXEC [MasterData].[usp_GetByPkId_DocumentCategory] 1, 0
END
GO
