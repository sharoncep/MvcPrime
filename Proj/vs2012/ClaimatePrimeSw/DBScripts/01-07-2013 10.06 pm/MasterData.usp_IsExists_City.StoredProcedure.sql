USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_IsExists_City]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_IsExists_City]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [MasterData].[usp_IsExists_City]
	@CityCode NVARCHAR(5)
	, @ZipCode NVARCHAR(10)
	, @CityName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CityID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @CityID = [MasterData].[ufn_IsExists_City] (@CityCode, @ZipCode, @CityName, @Comment, 0);
END
GO
