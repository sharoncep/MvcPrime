USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_GetRecent_UserClinicSelect]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_GetRecent_UserClinicSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Audit].[usp_GetRecent_UserClinicSelect]
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @ClinicID INT;

    SELECT TOP 1
		@ClinicID = [Audit].[UserClinicSelect].[ClinicID]
	FROM
		[Audit].[UserClinicSelect]
	WHERE
		[Audit].[UserClinicSelect].[UserID] = @UserID
	ORDER BY
		[Audit].[UserClinicSelect].[AuditOn]
	DESC;
	
	IF @ClinicID IS NULL
	BEGIN
		SELECT @ClinicID = 0;
	END
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		,[CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@TBL_ANS
	SELECT
		@ClinicID;
		
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Audit].[usp_GetRecent_UserClinicSelect] 1
END
GO
