USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_Update_WebCulture]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_Update_WebCulture]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to INSERT the WebCulture details into the table after rollback.
 
CREATE PROCEDURE [Audit].[usp_Update_WebCulture]
	@KeyName NVARCHAR(12)
	, @IsActive BIT
	, @WebCultureID BIGINT OUTPUT	
AS
BEGIN

BEGIN TRY
	SET NOCOUNT ON;
	UPDATE 
		[Audit].[WebCulture] 
	SET 
		[Audit].[WebCulture].[IsActive] = @IsActive 
	WHERE 
		[Audit].[WebCulture].[KeyName] = @KeyName
		
	SELECT @WebCultureID = 1;
	
	END TRY
	
	BEGIN CATCH
	-- ERROR CATCHING - STARTS
	BEGIN TRY			
		EXEC [Audit].[usp_Insert_ErrorLog];			
		SELECT @WebCultureID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
	END TRY
	BEGIN CATCH
		RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
	END CATCH
	-- ERROR CATCHING - ENDS
	END CATCH
			
	END
GO
