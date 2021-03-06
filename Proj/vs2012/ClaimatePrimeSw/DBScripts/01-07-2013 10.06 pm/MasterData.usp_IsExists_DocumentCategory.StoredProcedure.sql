USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_IsExists_DocumentCategory]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_IsExists_DocumentCategory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [MasterData].[usp_IsExists_DocumentCategory]
	@DocumentCategoryCode NVARCHAR(2)
	, @DocumentCategoryName NVARCHAR(150)
	, @IsInPatientRelated BIT
	, @Comment NVARCHAR(4000) = NULL
	, @DocumentCategoryID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @DocumentCategoryID = [MasterData].[ufn_IsExists_DocumentCategory] (@DocumentCategoryCode, @DocumentCategoryName, @IsInPatientRelated, @Comment, 0);
END
GO
