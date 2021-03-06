USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_EntityTypeQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_EntityTypeQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_EntityTypeQualifier]
	@EntityTypeQualifierCode NVARCHAR(1)
	, @EntityTypeQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @EntityTypeQualifierID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @EntityTypeQualifierID = [Transaction].[ufn_IsExists_EntityTypeQualifier] (@EntityTypeQualifierCode, @EntityTypeQualifierName, @Comment, 0);
END
GO
