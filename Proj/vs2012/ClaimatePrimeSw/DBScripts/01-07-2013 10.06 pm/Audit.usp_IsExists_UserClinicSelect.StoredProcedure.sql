USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_IsExists_UserClinicSelect]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_IsExists_UserClinicSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Audit].[usp_IsExists_UserClinicSelect]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 1;
END
GO
