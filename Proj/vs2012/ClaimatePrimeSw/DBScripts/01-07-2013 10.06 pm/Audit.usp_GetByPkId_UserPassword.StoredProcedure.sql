USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_GetByPkId_UserPassword]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_GetByPkId_UserPassword]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Audit].[usp_GetByPkId_UserPassword] 
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 1;
END
GO
