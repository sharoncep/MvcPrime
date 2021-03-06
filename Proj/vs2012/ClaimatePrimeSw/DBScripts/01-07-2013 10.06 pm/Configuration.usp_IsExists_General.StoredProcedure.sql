USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_IsExists_General]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_IsExists_General]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Configuration].[usp_IsExists_General]
	@UserAccEmailSubject NVARCHAR(100)
	, @SearchRecordPerPage TINYINT
	, @UploadMaxSizeInMB TINYINT
	, @PageLockIdleTimeInMin TINYINT
	, @SessionOutFromPageLockInMin TINYINT
	, @BACompleteFromDOSInDay TINYINT
	, @QACompleteFromDOSInDay TINYINT
	, @EDIFileSentFromDOSInDay TINYINT
	, @ClaimDoneFromDOSInDay TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @GeneralID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @GeneralID = [Configuration].[ufn_IsExists_General] (@UserAccEmailSubject, @SearchRecordPerPage, @UploadMaxSizeInMB, @PageLockIdleTimeInMin, @SessionOutFromPageLockInMin, @BACompleteFromDOSInDay, @QACompleteFromDOSInDay, @EDIFileSentFromDOSInDay, @ClaimDoneFromDOSInDay, @Comment, 0);
END
GO
