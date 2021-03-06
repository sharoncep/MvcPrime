USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_IsExists_Relationship]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_IsExists_Relationship]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Insurance].[usp_IsExists_Relationship]
	@RelationshipCode NVARCHAR(2)
	, @RelationshipName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @RelationshipID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @RelationshipID = [Insurance].[ufn_IsExists_Relationship] (@RelationshipCode, @RelationshipName, @Comment, 0);
END
GO
