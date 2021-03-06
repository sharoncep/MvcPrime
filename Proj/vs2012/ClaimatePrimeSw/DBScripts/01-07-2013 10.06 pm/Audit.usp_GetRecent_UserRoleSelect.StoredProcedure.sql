USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_GetRecent_UserRoleSelect]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_GetRecent_UserRoleSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Audit].[usp_GetRecent_UserRoleSelect]
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @RoleID TINYINT;

    SELECT TOP 1
		@RoleID = [Audit].[UserRoleSelect].[RoleID]
	FROM
		[Audit].[UserRoleSelect]
	WHERE
		[Audit].[UserRoleSelect].[UserID] = @UserID
	ORDER BY
		[Audit].[UserRoleSelect].[AuditOn]
	DESC;
	
	IF @RoleID IS NULL
	BEGIN
		SELECT @RoleID = 0;
	END
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] TINYINT NOT NULL IDENTITY (1, 1)
		, [ROLE_ID] TINYINT NOT NULL
	);
	
	INSERT INTO
		@TBL_ANS
	SELECT
		@RoleID;
		
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Audit].[usp_GetRecent_UserRoleSelect] 1
END
GO
