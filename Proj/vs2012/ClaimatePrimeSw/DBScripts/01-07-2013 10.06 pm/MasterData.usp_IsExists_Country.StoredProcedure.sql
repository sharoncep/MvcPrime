USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_IsExists_Country]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_IsExists_Country]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [MasterData].[usp_IsExists_Country]
	@CountryCode NVARCHAR(3)
	, @CountryName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CountryID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @CountryID = [MasterData].[ufn_IsExists_Country] (@CountryCode, @CountryName, @Comment, 0);
END
GO
