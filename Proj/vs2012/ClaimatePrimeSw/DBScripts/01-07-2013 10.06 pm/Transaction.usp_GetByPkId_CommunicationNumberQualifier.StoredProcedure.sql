USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_CommunicationNumberQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_CommunicationNumberQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_CommunicationNumberQualifier] 
	@CommunicationNumberQualifierID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[CommunicationNumberQualifier].*
	FROM
		[Transaction].[CommunicationNumberQualifier]
	WHERE
		[Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierID] = @CommunicationNumberQualifierID
	AND
		[Transaction].[CommunicationNumberQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[CommunicationNumberQualifier].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_CommunicationNumberQualifier] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_CommunicationNumberQualifier] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_CommunicationNumberQualifier] 1, 0
END
GO
