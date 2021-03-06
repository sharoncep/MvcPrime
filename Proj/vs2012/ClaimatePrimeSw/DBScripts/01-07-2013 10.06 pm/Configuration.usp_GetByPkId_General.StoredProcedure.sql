USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_GetByPkId_General]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_GetByPkId_General]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Configuration].[usp_GetByPkId_General] 
	@GeneralID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Configuration].[General].*
	FROM
		[Configuration].[General]
	WHERE
		[Configuration].[General].[GeneralID] = @GeneralID
	AND
		[Configuration].[General].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Configuration].[General].[IsActive] ELSE @IsActive END;

	-- EXEC [Configuration].[usp_GetByPkId_General] 1, NULL
	-- EXEC [Configuration].[usp_GetByPkId_General] 1, 1
	-- EXEC [Configuration].[usp_GetByPkId_General] 1, 0
END
GO
