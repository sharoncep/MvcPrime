USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Update_Specialty]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Update_Specialty]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Specialty in the database.
	 
CREATE PROCEDURE [Billing].[usp_Update_Specialty]
	@SpecialtyCode NVARCHAR(15)
	, @SpecialtyName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @SpecialtyID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @SpecialtyID_PREV BIGINT;
		SELECT @SpecialtyID_PREV = [Billing].[ufn_IsExists_Specialty] (@SpecialtyCode, @SpecialtyName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Billing].[Specialty].[SpecialtyID] FROM [Billing].[Specialty] WHERE [Billing].[Specialty].[SpecialtyID] = @SpecialtyID AND [Billing].[Specialty].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@SpecialtyID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Billing].[Specialty].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Billing].[Specialty].[LastModifiedOn]
			FROM 
				[Billing].[Specialty] WITH (NOLOCK)
			WHERE
				[Billing].[Specialty].[SpecialtyID] = @SpecialtyID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Billing].[SpecialtyHistory]
					(
						[SpecialtyID]
						, [SpecialtyCode]
						, [SpecialtyName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Billing].[Specialty].[SpecialtyID]
					, [Billing].[Specialty].[SpecialtyCode]
					, [Billing].[Specialty].[SpecialtyName]
					, [Billing].[Specialty].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Billing].[Specialty].[IsActive]
				FROM 
					[Billing].[Specialty]
				WHERE
					[Billing].[Specialty].[SpecialtyID] = @SpecialtyID;
				
				UPDATE 
					[Billing].[Specialty]
				SET
					[Billing].[Specialty].[SpecialtyCode] = @SpecialtyCode
					, [Billing].[Specialty].[SpecialtyName] = @SpecialtyName
					, [Billing].[Specialty].[Comment] = @Comment
					, [Billing].[Specialty].[LastModifiedBy] = @CurrentModificationBy
					, [Billing].[Specialty].[LastModifiedOn] = @CurrentModificationOn
					, [Billing].[Specialty].[IsActive] = @IsActive
				WHERE
					[Billing].[Specialty].[SpecialtyID] = @SpecialtyID;				
			END
			ELSE
			BEGIN
				SELECT @SpecialtyID = -2;
			END
		END
		ELSE IF @SpecialtyID_PREV <> @SpecialtyID
		BEGIN			
			SELECT @SpecialtyID = -1;			
		END
		-- ELSE
		-- BEGIN
		--	 SELECT @CurrentModificationOn = @LastModifiedOn;
		-- END
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY			
			EXEC [Audit].[usp_Insert_ErrorLog];			
			SELECT @SpecialtyID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
