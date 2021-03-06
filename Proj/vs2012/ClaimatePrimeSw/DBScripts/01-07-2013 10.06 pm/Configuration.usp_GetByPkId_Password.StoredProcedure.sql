USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_GetByPkId_Password]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_GetByPkId_Password]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Configuration].[usp_GetByPkId_Password] 
	@PasswordID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Configuration].[Password].*
	FROM
		[Configuration].[Password]
	WHERE
		[Configuration].[Password].[PasswordID] = @PasswordID
	AND
		[Configuration].[Password].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Configuration].[Password].[IsActive] ELSE @IsActive END;

	-- EXEC [Configuration].[usp_GetByPkId_Password] 1, NULL
	-- EXEC [Configuration].[usp_GetByPkId_Password] 1, 1
	-- EXEC [Configuration].[usp_GetByPkId_Password] 1, 0
END
GO
