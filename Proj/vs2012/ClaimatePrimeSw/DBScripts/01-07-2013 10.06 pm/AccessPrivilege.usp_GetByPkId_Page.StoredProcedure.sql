USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_GetByPkId_Page]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_GetByPkId_Page]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [AccessPrivilege].[usp_GetByPkId_Page] 
	@PageID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[AccessPrivilege].[Page].*
	FROM
		[AccessPrivilege].[Page]
	WHERE
		[AccessPrivilege].[Page].[PageID] = @PageID
	AND
		[AccessPrivilege].[Page].[IsActive] = CASE WHEN @IsActive IS NULL THEN [AccessPrivilege].[Page].[IsActive] ELSE @IsActive END;

	-- EXEC [AccessPrivilege].[usp_GetByPkId_Page] 1, NULL
	-- EXEC [AccessPrivilege].[usp_GetByPkId_Page] 1, 1
	-- EXEC [AccessPrivilege].[usp_GetByPkId_Page] 1, 0
END
GO
