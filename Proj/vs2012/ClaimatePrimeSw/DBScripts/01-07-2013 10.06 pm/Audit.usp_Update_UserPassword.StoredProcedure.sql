USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_Update_UserPassword]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_Update_UserPassword]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to INSERT the UserPassworddetails into the table after rollback.
 
CREATE PROCEDURE [Audit].[usp_Update_UserPassword]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 1;
END
GO
