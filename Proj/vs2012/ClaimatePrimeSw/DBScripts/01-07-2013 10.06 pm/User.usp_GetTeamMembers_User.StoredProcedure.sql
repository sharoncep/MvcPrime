USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetTeamMembers_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetTeamMembers_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User].[usp_GetTeamMembers_User]
	
	@ClinicID int
   	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
  

    
    SELECT distinct
    [AccessPrivilege].[Role].[RoleID],
	[AccessPrivilege].[Role].[RoleName],
	(LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) as Name,
	[User].[User].[Email]
	FROM
		[User].[User] 
	INNER JOIN
	
	[User].[UserRole]	
	
	ON
	[User].[UserRole].[UserID]=[User].[User].[UserID] 
		
	INNER JOIN 
		[AccessPrivilege].[Role]
	ON
		[User].[UserRole].[RoleID]=[AccessPrivilege].[Role].[RoleID]
	INNER JOIN
	
	[User].[UserClinic]	
	
	ON
	[User].[UserClinic].[UserID]=[User].[User].[UserID]
	
	WHERE
	
	 [User].[UserClinic].[ClinicID] = @ClinicID
	 
	 AND
	 
	 [AccessPrivilege].[Role].[RoleID] <> 1
	 

	
	ORDER BY
		1 ASC
	,2 asc;
		
	
		
	
	-- EXEC [User].[usp_GetTeamMembers_User] @ClinicID = 2 
END
GO
