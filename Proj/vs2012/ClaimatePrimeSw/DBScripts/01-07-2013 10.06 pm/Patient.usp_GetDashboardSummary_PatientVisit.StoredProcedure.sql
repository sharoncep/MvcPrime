USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetDashboardSummary_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetDashboardSummary_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetDashboardSummary_PatientVisit]
	@UserID BIGINT
AS
BEGIN
	-- SET NOCOUNT_BIG ON added to prevent extra result sets from
	-- BIGINTerfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY (1, 1) NOT NULL
		, [DESC] NVARCHAR(15) NOT NULL
		, [COUNT1] BIGINT NOT NULL
		, [COUNT7] BIGINT NOT NULL
		, [COUNT30] BIGINT NOT NULL
		, [COUNT31PLUS] BIGINT NOT NULL
		, [COUNTTOTAL] BIGINT NOT NULL
	);
	
	DECLARE @Data1 BIGINT;
	DECLARE @Data7 BIGINT;
	DECLARE @Data30 BIGINT;
	DECLARE @Data31Plus BIGINT;
	DECLARE @DataTotal BIGINT;	
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1 )
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;	
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Visits'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	--Created COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;	

	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Created'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
--Hold COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]	
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Hold'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	
--Ready to send COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]	
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Ready To Send'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);

--Sent COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Sent'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	--Accepted COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Accepted'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);


	--Rejected COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (26, 27)
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (26, 27)
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (26, 27)
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (26, 27)
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Rejected'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);

--Resubmitted COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] 
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] 
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND 
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] 
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] 
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND
		[Patient].[Patient].[ClinicID] IN (SELECT [User].[UserClinic].[ClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserID] = @UserID AND [User].[UserClinic].[IsActive] = 1)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Re-Submitted'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	SELECT * FROM @TBL_ANS ORDER BY [ID] ASC;		
	
	-- EXEC [Patient].[usp_GetDashboardSummary_PatientVisit] 101
END
GO
