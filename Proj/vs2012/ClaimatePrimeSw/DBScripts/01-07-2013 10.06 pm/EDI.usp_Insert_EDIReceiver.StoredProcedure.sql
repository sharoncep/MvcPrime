USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_Insert_EDIReceiver]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_Insert_EDIReceiver]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [EDI].[usp_Insert_EDIReceiver]
	@EDIReceiverCode NVARCHAR(25)
	, @EDIReceiverName NVARCHAR(25)
	, @AuthorizationInformationQualifierID TINYINT
	, @AuthorizationInformation NVARCHAR(10) = NULL
	, @SecurityInformationQualifierID TINYINT
	, @SecurityInformation NVARCHAR(10) = NULL
	, @SecurityInformationQualifierUserName NVARCHAR(25) = NULL
	, @SecurityInformationQualifierPassword NVARCHAR(25) = NULL
	, @LastInterchangeControlNumber BIGINT
	, @SenderInterchangeIDQualifierID TINYINT
	, @SenderInterchangeID NVARCHAR(15)
	, @ReceiverInterchangeIDQualifierID TINYINT
	, @ReceiverInterchangeID NVARCHAR(15)
	, @TransactionSetPurposeCodeID TINYINT
	, @TransactionTypeCodeID TINYINT
	, @IsGroupPractice BIT
	, @ClaimMediaID TINYINT
	, @ApplicationSenderCode NVARCHAR(25)
	, @ApplicationReceiverCode NVARCHAR(25)
	, @InterchangeUsageIndicatorID TINYINT
	, @FunctionalIdentifierCode NVARCHAR(2)
	, @SubmitterEntityIdentifierCodeID TINYINT
	, @ReceiverEntityIdentifierCodeID TINYINT
	, @BillingProviderEntityIdentifierCodeID TINYINT
	, @SubscriberEntityIdentifierCodeID TINYINT
	, @PayerEntityIdentifierCodeID TINYINT
	, @EntityTypeQualifierID TINYINT
	, @CurrencyCodeID TINYINT
	, @PayerResponsibilitySequenceNumberCodeID TINYINT
	, @EmailCommunicationNumberQualifierID TINYINT
	, @FaxCommunicationNumberQualifierID TINYINT
	, @PhoneCommunicationNumberQualifierID TINYINT
	, @PatientEntityTypeQualifierID TINYINT
	, @ProviderEntityTypeQualifierID TINYINT
	, @InsuranceEntityTypeQualifierID TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @EDIReceiverID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @EDIReceiverID = [EDI].[ufn_IsExists_EDIReceiver] (@EDIReceiverCode, @EDIReceiverName, @AuthorizationInformationQualifierID, @AuthorizationInformation, @SecurityInformationQualifierID, @SecurityInformation, @SecurityInformationQualifierUserName, @SecurityInformationQualifierPassword, @LastInterchangeControlNumber, @SenderInterchangeIDQualifierID, @SenderInterchangeID, @ReceiverInterchangeIDQualifierID, @ReceiverInterchangeID, @TransactionSetPurposeCodeID, @TransactionTypeCodeID, @IsGroupPractice, @ClaimMediaID, @ApplicationSenderCode, @ApplicationReceiverCode, @InterchangeUsageIndicatorID, @FunctionalIdentifierCode, @SubmitterEntityIdentifierCodeID, @ReceiverEntityIdentifierCodeID, @BillingProviderEntityIdentifierCodeID, @SubscriberEntityIdentifierCodeID, @PayerEntityIdentifierCodeID, @EntityTypeQualifierID, @CurrencyCodeID, @PayerResponsibilitySequenceNumberCodeID, @EmailCommunicationNumberQualifierID, @FaxCommunicationNumberQualifierID, @PhoneCommunicationNumberQualifierID, @PatientEntityTypeQualifierID, @ProviderEntityTypeQualifierID, @InsuranceEntityTypeQualifierID, @Comment, 0);
		
		IF @EDIReceiverID = 0
		BEGIN
			INSERT INTO [EDI].[EDIReceiver]
			(
				[EDIReceiverCode]
				, [EDIReceiverName]
				, [AuthorizationInformationQualifierID]
				, [AuthorizationInformation]
				, [SecurityInformationQualifierID]
				, [SecurityInformation]
				, [SecurityInformationQualifierUserName]
				, [SecurityInformationQualifierPassword]
				, [LastInterchangeControlNumber]
				, [SenderInterchangeIDQualifierID]
				, [SenderInterchangeID]
				, [ReceiverInterchangeIDQualifierID]
				, [ReceiverInterchangeID]
				, [TransactionSetPurposeCodeID]
				, [TransactionTypeCodeID]
				, [IsGroupPractice]
				, [ClaimMediaID]
				, [ApplicationSenderCode]
				, [ApplicationReceiverCode]
				, [InterchangeUsageIndicatorID]
				, [FunctionalIdentifierCode]
				, [SubmitterEntityIdentifierCodeID]
				, [ReceiverEntityIdentifierCodeID]
				, [BillingProviderEntityIdentifierCodeID]
				, [SubscriberEntityIdentifierCodeID]
				, [PayerEntityIdentifierCodeID]
				, [EntityTypeQualifierID]
				, [CurrencyCodeID]
				, [PayerResponsibilitySequenceNumberCodeID]
				, [EmailCommunicationNumberQualifierID]
				, [FaxCommunicationNumberQualifierID]
				, [PhoneCommunicationNumberQualifierID]
				, [PatientEntityTypeQualifierID]
				, [ProviderEntityTypeQualifierID]
				, [InsuranceEntityTypeQualifierID]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@EDIReceiverCode
				, @EDIReceiverName
				, @AuthorizationInformationQualifierID
				, @AuthorizationInformation
				, @SecurityInformationQualifierID
				, @SecurityInformation
				, @SecurityInformationQualifierUserName
				, @SecurityInformationQualifierPassword
				, @LastInterchangeControlNumber
				, @SenderInterchangeIDQualifierID
				, @SenderInterchangeID
				, @ReceiverInterchangeIDQualifierID
				, @ReceiverInterchangeID
				, @TransactionSetPurposeCodeID
				, @TransactionTypeCodeID
				, @IsGroupPractice
				, @ClaimMediaID
				, @ApplicationSenderCode
				, @ApplicationReceiverCode
				, @InterchangeUsageIndicatorID
				, @FunctionalIdentifierCode
				, @SubmitterEntityIdentifierCodeID
				, @ReceiverEntityIdentifierCodeID
				, @BillingProviderEntityIdentifierCodeID
				, @SubscriberEntityIdentifierCodeID
				, @PayerEntityIdentifierCodeID
				, @EntityTypeQualifierID
				, @CurrencyCodeID
				, @PayerResponsibilitySequenceNumberCodeID
				, @EmailCommunicationNumberQualifierID
				, @FaxCommunicationNumberQualifierID
				, @PhoneCommunicationNumberQualifierID
				, @PatientEntityTypeQualifierID
				, @ProviderEntityTypeQualifierID
				, @InsuranceEntityTypeQualifierID
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @EDIReceiverID = MAX([EDI].[EDIReceiver].[EDIReceiverID]) FROM [EDI].[EDIReceiver];
		END
		ELSE
		BEGIN			
			SELECT @EDIReceiverID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @EDIReceiverID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
