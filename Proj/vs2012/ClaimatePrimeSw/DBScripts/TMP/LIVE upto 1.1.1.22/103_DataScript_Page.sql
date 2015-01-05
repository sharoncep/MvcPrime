UPDATE [Audit].[WebCulture] SET [IsActive] = 1 WHERE [KeyName] = 'ar';
----

UPDATE [Excel].[ReportType] SET [ReportTypeName] = 'CLINIC REPORT' WHERE [ReportTypeCode] = '01';
UPDATE [Excel].[ReportType] SET [ReportTypeName] = 'PROVIDER REPORT' WHERE [ReportTypeCode] = '02';
UPDATE [Excel].[ReportType] SET [ReportTypeName] = 'PATIENT REPORT' WHERE [ReportTypeCode] = '03';
UPDATE [Excel].[ReportType] SET [ReportTypeName] = 'AGENT REPORT' WHERE [ReportTypeCode] = '04';
---
DELETE FROM [AccessPrivilege].[PageRole] WHERE [PageID] IN (SELECT [PageID] FROM [AccessPrivilege].[Page] WHERE [ControllerName] = 'RptClinicAllSum');
DELETE FROM [AccessPrivilege].[Page] WHERE [ControllerName] = 'RptClinicAllSum';

DELETE FROM [AccessPrivilege].[PageRole] WHERE [PageID] IN (SELECT [PageID] FROM [AccessPrivilege].[Page] WHERE [ControllerName] = 'RptClinicAll');
DELETE FROM [AccessPrivilege].[Page] WHERE [ControllerName] = 'RptClinicAll';
---
SET IDENTITY_INSERT [AccessPrivilege].[Page] ON;

INSERT INTO [AccessPrivilege].[Page] ([PageID],[SessionName],[ControllerName],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(140, 'SelPatientID', 'RptAgentWise', 1,1,CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[Page] ([PageID],[SessionName],[ControllerName],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(141, 'SelClinicID', 'RptSumFCClinicWise', 1,1,CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [AccessPrivilege].[Page] ([PageID],[SessionName],[ControllerName],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(142, NULL, 'RptSumFCClinic', 1,1,CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [AccessPrivilege].[Page] ([PageID],[SessionName],[ControllerName],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(143, NULL, 'RptSumFCProviderWise', 1,1,CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [AccessPrivilege].[Page] ([PageID],[SessionName],[ControllerName],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(144, NULL, 'RptSumFCPatientWise', 1,1,CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
		
INSERT INTO [AccessPrivilege].[Page] ([PageID],[SessionName],[ControllerName],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(145, NULL, 'RptSumFCAgent', 1,1,CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
		
INSERT INTO [AccessPrivilege].[Page] ([PageID],[SessionName],[ControllerName],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(146, 'SelAgentID', 'RptSumFCAgentWise', 1,1,CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[Page] OFF;

--RptAgentWise_R
SET IDENTITY_INSERT [AccessPrivilege].[PageRole] ON;

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(731, '1', '140', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(732, '2', '140', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(733, '3', '140', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(734, '4', '140', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(735, '5', '140', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[PageRole] OFF;


--RptSumFCClinicWise_R
SET IDENTITY_INSERT [AccessPrivilege].[PageRole] ON;

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(736, '1', '141', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(737, '2', '141', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(738, '3', '141', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(739, '4', '141', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(740, '5', '141', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[PageRole] OFF;

--RptSumFCClinic
SET IDENTITY_INSERT [AccessPrivilege].[PageRole] ON;

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(741, '1', '142', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(742, '2', '142', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(743, '3', '142', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(744, '4', '142', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(745, '5', '142', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[PageRole] OFF;

--RptSumFCProviderWise
SET IDENTITY_INSERT [AccessPrivilege].[PageRole] ON;

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(746, '1', '143', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(747, '2', '143', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(748, '3', '143', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(749, '4', '143', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(750, '5', '143', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[PageRole] OFF;

--RptSumFCPatientWise_R
SET IDENTITY_INSERT [AccessPrivilege].[PageRole] ON;

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(751, '1', '144', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(752, '2', '144', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(753, '3', '144', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(754, '4', '144', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(755, '5', '144', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[PageRole] OFF;

--RptSumFCAgent_R
SET IDENTITY_INSERT [AccessPrivilege].[PageRole] ON;

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(756, '1', '145', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(757, '2', '145', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(758, '3', '145', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(759, '4', '145', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(760, '5', '145', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[PageRole] OFF;

--RptSumFCAgentWise_R
SET IDENTITY_INSERT [AccessPrivilege].[PageRole] ON;

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(761, '1', '146', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(762, '2', '146', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(763, '3', '146', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(764, '4', '146', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(765, '5', '146', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[PageRole] OFF;

---
UPDATE [AccessPrivilege].[Page] SET [SessionName] = 'SelProviderID' WHERE [ControllerName] = 'RptProviderWise';
UPDATE [AccessPrivilege].[Page] SET [SessionName] = 'SelPatientID' WHERE [ControllerName] = 'RptPatientWise';
UPDATE [AccessPrivilege].[Page] SET [SessionName] = 'SelAgentID' WHERE [ControllerName] = 'RptAgentWise';
UPDATE [AccessPrivilege].[Page] SET [SessionName] = 'SelProviderID' WHERE [ControllerName] = 'RptSumFCProviderWise';
UPDATE [AccessPrivilege].[Page] SET [SessionName] = 'SelPatientID' WHERE [ControllerName] = 'RptSumFCPatientWise';
UPDATE [AccessPrivilege].[Page] SET [SessionName] = 'SelAgentID' WHERE [ControllerName] = 'RptSumFCAgentWise';
UPDATE [AccessPrivilege].[Page] SET [ControllerName] = 'RptClinicWise' WHERE [ControllerName] = 'RptClinicSel';

-----
--DECLARE CUR_USER CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
--	SELECT 
--		[User].[User].[UserID]
--	FROM
--		[User].[User] WITH (NOLOCK);
		
--OPEN CUR_USER;
	
--DECLARE @USER_ID INT;
	
--FETCH NEXT FROM CUR_USER INTO @USER_ID;
--WHILE @@FETCH_STATUS = 0
--BEGIN
--	-- CLINIC
--	DECLARE CUR_CLINIC CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
--		SELECT 
--			[Billing].[Clinic].[ClinicID]
--		FROM
--			[Billing].[Clinic] WITH (NOLOCK);
			
--	OPEN CUR_CLINIC;
		
--	DECLARE @CLINIC_ID INT;
		
--	FETCH NEXT FROM CUR_CLINIC INTO @CLINIC_ID;
--	WHILE @@FETCH_STATUS = 0
--	BEGIN
--		IF NOT EXISTS(SELECT [UserClinicID] FROM [User].[UserClinic] WHERE [UserID] = @USER_ID AND [ClinicID] = @CLINIC_ID)
--		BEGIN
--			INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
--				VALUES (@USER_ID, @CLINIC_ID, 0, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime)) ;
--		END
		
--		FETCH NEXT FROM CUR_CLINIC INTO @CLINIC_ID;
--	END
		
--	CLOSE CUR_CLINIC;
--	DEALLOCATE CUR_CLINIC;
	
--	--ROLE
--	DECLARE CUR_ROLE CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
--		SELECT 
--			[AccessPrivilege].[Role].[RoleID]
--		FROM
--			[AccessPrivilege].[Role] WITH (NOLOCK)
--		WHERE
--			[RoleID] > 2;
			
--	OPEN CUR_ROLE;
		
--	DECLARE @ROLE_ID INT;
		
--	FETCH NEXT FROM CUR_ROLE INTO @ROLE_ID;
--	WHILE @@FETCH_STATUS = 0
--	BEGIN
--		IF NOT EXISTS(SELECT [UserRoleID] FROM [User].[UserRole] WHERE [UserID] = @USER_ID AND [RoleID] = @ROLE_ID)
--		BEGIN
--			INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
--				VALUES (@USER_ID, @ROLE_ID, 0, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
--		END
		
--		FETCH NEXT FROM CUR_ROLE INTO @ROLE_ID;
--	END
		
--	CLOSE CUR_ROLE;
--	DEALLOCATE CUR_ROLE;
--	---
--	FETCH NEXT FROM CUR_USER INTO @USER_ID;
--END
	
--CLOSE CUR_USER;
--DEALLOCATE CUR_USER;