USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_CommunicationNumberQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_CommunicationNumberQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_CommunicationNumberQualifier]
	@CommunicationNumberQualifierCode NVARCHAR(2)
	, @CommunicationNumberQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CommunicationNumberQualifierID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @CommunicationNumberQualifierID = [Transaction].[ufn_IsExists_CommunicationNumberQualifier] (@CommunicationNumberQualifierCode, @CommunicationNumberQualifierName, @Comment, 0);
END
GO
