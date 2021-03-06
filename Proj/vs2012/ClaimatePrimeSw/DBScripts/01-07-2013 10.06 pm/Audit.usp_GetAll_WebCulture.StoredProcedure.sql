USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_GetAll_WebCulture]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_GetAll_WebCulture]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Audit].[usp_GetAll_WebCulture]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		[Audit].[WebCulture].*
	FROM
		[Audit].[WebCulture]
	WHERE
		[Audit].[WebCulture].[IsActive] = 1
	ORDER BY
		[Audit].[WebCulture].[EnglishName]
	ASC;
END
GO
