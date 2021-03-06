USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByClinicID_UserClinic]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByClinicID_UserClinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Created by sai for displaying manager name in Clinic setup - edit


CREATE PROCEDURE [User].[usp_GetByClinicID_UserClinic]
	@ClinicID	int
   
	
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
 DECLARE @USER_TMP TABLE
	(
		[USER_ID] INT NOT NULL
	);
	
	INSERT INTO
		@USER_TMP
	SELECT 
		[User].[UserRole].[UserID]
	FROM 
		[User].[UserRole]
	WHERE
		[User].[UserRole].[RoleID] = 2
	AND
		[User].[UserRole].[IsActive] = 1;
	
	DELETE FROM
		@USER_TMP
	WHERE
		[USER_ID] IN
		(
			SELECT 
				[User].[UserRole].[UserID]
			FROM 
				[User].[UserRole]
			WHERE
				[User].[UserRole].[RoleID] < 2
			AND
				[User].[UserRole].[IsActive] = 1
		)
	OR
		[USER_ID] IN
		(
			SELECT 
				[User].[User].[UserID]
			FROM 
				[User].[User]
			WHERE
				[User].[User].[ManagerID] IS NOT NULL
			AND
				[User].[User].[IsActive] = 1
		);   
   
    
   SELECT (
		[User].[User].[LastName] +[User].[User].[FirstName] + ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
		, [User].[User].[UserID] , [User].[UserClinic].[UserClinicID]
			
	FROM
		 [User].[UserClinic]
		 
		 INNER JOIN
		 
		 [User].[User] 
		 
		 ON
		 
		 [User].[UserClinic].[UserID] = [User].[User].[UserID]
		 
		
		 
	  WHERE
	 
	 [User].[UserClinic].[ClinicID] = @ClinicID
	 
	AND
			[User].[User].[UserID] IN
			(
				SELECT 
					[USER_ID]
				FROM 
					@USER_TMP
			)
	 
	
	
	-- EXEC [User].[usp_GetByClinicID_UserClinic] @ClinicID = 2
END
GO
