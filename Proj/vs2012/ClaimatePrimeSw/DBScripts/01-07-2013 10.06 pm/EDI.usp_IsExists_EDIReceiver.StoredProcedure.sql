USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_IsExists_EDIReceiver]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_IsExists_EDIReceiver]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [EDI].[usp_IsExists_EDIReceiver]
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
	, @EDIReceiverID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @EDIReceiverID = [EDI].[ufn_IsExists_EDIReceiver] (@EDIReceiverCode, @EDIReceiverName, @AuthorizationInformationQualifierID, @AuthorizationInformation, @SecurityInformationQualifierID, @SecurityInformation, @SecurityInformationQualifierUserName, @SecurityInformationQualifierPassword, @LastInterchangeControlNumber, @SenderInterchangeIDQualifierID, @SenderInterchangeID, @ReceiverInterchangeIDQualifierID, @ReceiverInterchangeID, @TransactionSetPurposeCodeID, @TransactionTypeCodeID, @IsGroupPractice, @ClaimMediaID, @ApplicationSenderCode, @ApplicationReceiverCode, @InterchangeUsageIndicatorID, @FunctionalIdentifierCode, @SubmitterEntityIdentifierCodeID, @ReceiverEntityIdentifierCodeID, @BillingProviderEntityIdentifierCodeID, @SubscriberEntityIdentifierCodeID, @PayerEntityIdentifierCodeID, @EntityTypeQualifierID, @CurrencyCodeID, @PayerResponsibilitySequenceNumberCodeID, @EmailCommunicationNumberQualifierID, @FaxCommunicationNumberQualifierID, @PhoneCommunicationNumberQualifierID, @PatientEntityTypeQualifierID, @ProviderEntityTypeQualifierID, @InsuranceEntityTypeQualifierID, @Comment, 0);
END
GO
