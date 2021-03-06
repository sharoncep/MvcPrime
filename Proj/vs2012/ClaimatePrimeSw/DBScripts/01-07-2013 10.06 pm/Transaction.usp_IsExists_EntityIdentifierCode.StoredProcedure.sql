USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_EntityIdentifierCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_EntityIdentifierCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_EntityIdentifierCode]
	@EntityIdentifierCodeCode NVARCHAR(2)
	, @EntityIdentifierCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @EntityIdentifierCodeID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @EntityIdentifierCodeID = [Transaction].[ufn_IsExists_EntityIdentifierCode] (@EntityIdentifierCodeCode, @EntityIdentifierCodeName, @Comment, 0);
END
GO
