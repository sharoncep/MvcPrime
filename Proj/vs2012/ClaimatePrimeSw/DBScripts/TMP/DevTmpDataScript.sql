UPDATE [EDI].[EDIReceiver] SET [InterchangeUsageIndicatorID] = 1 ;

UPDATE [Patient].[PatientVisit] SET [IsActive] = 0 WHERE [Patient].[PatientVisit].[PatientVisitID] = 23734;

--UPDATE 	[User].[User] SET [IsActive] = 0 WHERE [UserID] BETWEEN 6 AND 100;

UPDATE [User].[User] SET [Password] = [UserName];

SET IDENTITY_INSERT [User].[User] ON;
--SHARON
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(101, 'DevWa3', 'DevWa3', 'claimatedevwa3@in.arivameddata.com', 'SHARON','JOSEPH', 'WA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(129, 'DevCm3', 'DevCm3', 'claimatedevcm3@in.arivameddata.com', 'SHARON','JOSEPH', 'CM', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(130, 'DevEa3', 'DevEa3', 'claimatedevea3@in.arivameddata.com', 'SHARON','JOSEPH', 'EA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(131, 'DevQa3', 'DevQa3', 'claimatedevqa3@in.arivameddata.com', 'SHARON','JOSEPH', 'QA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(132, 'DevBa3', 'DevBa3', 'claimatedevba3@in.arivameddata.com', 'SHARON','JOSEPH', 'BA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
--	SAI
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(102, 'DevWa4', 'DevWa4', 'claimatedevwa4@in.arivameddata.com', 'SAILEKSHMY','N G', 'WA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(133, 'DevCm4', 'waSharon', 'claimatedevcm4@in.arivameddata.com', 'SAILEKSHMY','N G', 'CM', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(134, 'DevEa4', 'waSharon', 'claimatedevea4@in.arivameddata.com', 'SAILEKSHMY','N G', 'EA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(135, 'DevQa4', 'waSharon', 'claimatedevqa4@in.arivameddata.com', 'SAILEKSHMY','N G', 'QA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(136, 'DevBa4', 'waSharon', 'claimatedevba4@in.arivameddata.com', 'SAILEKSHMY','N G', 'BA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
--	RATHEESH
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(103, 'DevWa2', 'waRatheesh', 'claimatedevwa2@in.arivameddata.com ', 'RATHEESH','RAVEENDRAN', 'WA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(137, 'DevCm2', 'waSharon', 'claimatedevcm2@in.arivameddata.com', 'RATHEESH','RAVEENDRAN', 'CM', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(138, 'DevEa2', 'waSharon', 'claimatedevea2@in.arivameddata.com', 'RATHEESH','RAVEENDRAN', 'EA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(139, 'DevQa2', 'waSharon', 'claimatedevqa2@in.arivameddata.com', 'RATHEESH','RAVEENDRAN', 'QA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(140, 'DevBa2', 'waSharon', 'claimatedevba2@in.arivameddata.com', 'RATHEESH','RAVEENDRAN', 'BA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
--	
--	X
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(141, 'DevWa5', 'waRatheesh', 'claimatedevwa5@in.arivameddata.com ', 'SOFT','TEST 5', 'WA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(142, 'DevCm5', 'waSharon', 'claimatedevcm5@in.arivameddata.com', 'SOFT','TEST 5', 'CM', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(143, 'DevEa5', 'waSharon', 'claimatedevea5@in.arivameddata.com', 'SOFT','TEST 5', 'EA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(144, 'DevQa5', 'waSharon', 'claimatedevqa5@in.arivameddata.com', 'SOFT','TEST 5', 'QA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(145, 'DevBa5', 'waSharon', 'claimatedevba5@in.arivameddata.com', 'SOFT','TEST 5', 'BA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
--	
--	Y
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(146, 'DevWa6', 'waRatheesh', 'claimatedevwa6@in.arivameddata.com', 'SOFT','TEST 6', 'WA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(147, 'DevCm6', 'waSharon', 'claimatedevcm6@in.arivameddata.com', 'SOFT','TEST 6', 'CM', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(148, 'DevEa6', 'waSharon', 'claimatedevea6@in.arivameddata.com', 'SOFT','TEST 6', 'EA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(149, 'DevQa6', 'waSharon', 'claimatedevqa6@in.arivameddata.com', 'SOFT','TEST 6', 'QA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(150, 'DevBa6', 'waSharon', 'claimatedevba6@in.arivameddata.com', 'SOFT','TEST 6', 'BA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
--SOFT TEST

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(151, 'DevWa1', 'c770cdc42a45c21f931450e9f3eef3d50ad72ab9', 'claimatedevwa1@in.arivameddata.com', 'Solaisamy', 'Selvaraj', 'DBA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));	-- d#B%a
	
--

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(104, 'waHimesh', 'waHimesh', 'himesh@arivameddata.com', 'Himesh','Administrator', 'WA', '(944)643-2544', 0, 0, 0, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(105, 'waSunil', 'waSunil', 'sunil2692@yahoo.com', 'Sunil','Administrator', 'WA', '(944)643-2544', 0, 0, 0, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(106, 'waTmp5', 'waTmp5', 'softtest_tmp5@in.arivameddata.com', 'Tmp5','Tmp5', 'WA', '(944)643-2544', 1, 0, 0, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(108, 'ManagerTest', 'ManagerTest', 'managertest@in.arivameddata.com', 'Test','Manager', 'CM', '(944)643-2544', 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(109, 'BATest', 'BATest', 'batest@in.arivameddata.com', 'Test','BA', 'BA', '(944)643-2544', 108, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(110, 'EATest', 'EATest', 'qatest@in.arivameddata.com', 'Test','QA', 'QA', '(944)643-2544', 108, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(111, 'QATest', 'QATest', 'eatest@in.arivameddata.com', 'Test','EA', 'EA', '(944)643-2544', 108, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
--AMALA
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(107, 'TestWa1', 'TestWa1', 'claimatetestwa1@in.arivameddata.com', 'AMALA','TRESA', 'WA', '(944)643-2544', 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(112, 'TestCm1', 'TestCm1', 'claimatetestcm1@in.arivameddata.com', 'AMALA','TRESA', 'CM', '(944)643-2544', 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(113, 'TestBa1', 'TestBa1', 'claimatetestba1@in.arivameddata.com', 'AMALA','TRESA', 'BA', '(944)643-2544', 108, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(114, 'TestEa1', 'TestEa1', 'claimatetestea1@in.arivameddata.com', 'AMALA','TRESA', 'EA', '(944)643-2544', 108, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(115, 'TestQa1', 'TestQa1', 'claimatetestqa1@in.arivameddata.com', 'AMALA','TRESA', 'QA', '(944)643-2544', 108, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
--
--RITU
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(116, 'TestWa2', 'TestWa2', 'claimatetestwa2@in.arivameddata.com', 'RITU','ACHUTHAN', 'WA', '(944)643-2544', 1, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(117, 'TestCm2', 'TestCm2', 'claimatetestcm2@in.arivameddata.com', 'RITU','ACHUTHAN', 'CM', '(944)643-2544', 1, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(118, 'TestBa2', 'TestBa2', 'claimatetestba2@in.arivameddata.com', 'RITU','ACHUTHAN', 'BA', '(944)643-2544', 117, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(119, 'TestEa2', 'TestEa2', 'claimatetestea2@in.arivameddata.com', 'RITU','ACHUTHAN', 'EA', '(944)643-2544', 117, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(120, 'TestQa2', 'TestQa2', 'claimatetestqa2@in.arivameddata.com', 'RITU','ACHUTHAN', 'QA', '(944)643-2544', 117, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
--
--VARUN
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(121, 'TestWa3', 'TestWa3', 'claimatetestwa3@in.arivameddata.com', 'VARUN','VENUGOPAL', 'WA', '(944)643-2544', 1, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(122, 'TestCm3', 'TestCm3', 'claimatetestcm3@in.arivameddata.com', 'VARUN','VENUGOPAL', 'CM', '(944)643-2544', 1, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(123, 'TestBa3', 'TestBa3', 'claimatetestba3@in.arivameddata.com', 'VARUN','VENUGOPAL', 'BA', '(944)643-2544', 122, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(124, 'TestEa3', 'TestEa3', 'claimatetestea3@in.arivameddata.com', 'VARUN','VENUGOPAL', 'EA', '(944)643-2544', 122, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(125, 'TestQa3', 'TestQa3', 'claimatetestqa3@in.arivameddata.com', 'VARUN','VENUGOPAL', 'QA', '(944)643-2544', 122, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
--
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(126, 'baTemp', 'baTemp', 'batemp@in.arivameddata.com', 'BA','Temp', 'BA', '(944)643-2544', 122, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [ManagerID], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(127, 'cmTemp', 'cmTemp', 'cmtemp@in.arivameddata.com', 'CM','Temp', 'CM', '(944)643-2544', 1, 1, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));
	
INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(128, 'waAhmed', 'waAhmed', 'ahmed.haroon@in.arivameddata.com', 'Ahmed','Haroon', 'WA', '(944)643-2544', 0, 0, 0, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(152, 'ChrisD', 'd81e8bf400183670f0247e82d5a09cf706d476d3', 'chrisd@trinityphysiciansllc.com', 'CHRIS', 'DIVIYANATHAN', NULL, '(727)457-7799', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));	-- 123qweAadmin

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(153, 'sufeel', 'sufeel', 'sufeel@arivameddata.com', 'Sufeel','Nishthar', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(154, 'manu', 'manu', 'manu@arivameddata.com', 'Manu','Madhavankutty', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [User].[User] ([UserID], [UserName], [Password], [Email], [LastName], [FirstName], [MiddleName],  [PhoneNumber], [AlertChangePassword], [IsBlocked], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])  
	VALUES(155, 'ashil', 'ashil', 'ashil.ajay@in.arivameddata.com', 'ASHIL','AJAY', 'WA', '(944)643-2544', 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [User].[User] OFF;

--[WebAdminSharon]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('101', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('101', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('101', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('101', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('101', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[maSharon]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('129', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('129', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('129', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('129', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[eaSharon]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('130', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('130', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('130', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[qaSharon]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('131', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('131', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[BASharon]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('132', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	

----
--[WebadminSai]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('102', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('102', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('102', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('102', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('102', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[maSai]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('133', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('133', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('133', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('133', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[eaSai]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('134', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('134', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('134', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[qaSai]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('135', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('135', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[BASai]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('136', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	

----

--[WebadminRatheesh]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('103', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('103', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('103', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('103', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('103', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[maRatheesh]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('137', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('137', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('137', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('137', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[eaRatheesh]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('138', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('138', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('138', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[qaRatheesh]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('139', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('139', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[BARatheesh]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('140', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	

----
--[WebadminX]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('141', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('141', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('141', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('141', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('141', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[maX]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('142', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('142', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('142', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('142', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[eaX]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('143', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('143', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('143', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[qaX]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('144', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('144', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[baX]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('145', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	

----
--[WebadminY]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('146', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('146', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('146', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('146', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('146', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[maY]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('147', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('147', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('147', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('147', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[eaY]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('148', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('148', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('148', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[qaY]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('149', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('149', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[baY]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('150', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[WebadminHimesh]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('104', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('104', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('104', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('104', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('104', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[WebadminSunil]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('105', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('105', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('105', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('105', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('105', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[WebadminSaju]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('106', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('106', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('106', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('106', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('106', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[WebadminAmala]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('107', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('107', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('107', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('107', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('107', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[ManagerTest]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('108', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('108', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('108', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('108', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[BATest]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('109', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[QATest]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('110', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('110', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('110', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
--[EATest]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('111', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('111', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[maAmala]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('112', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('112', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('112', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('112', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[BAAmala]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('113', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
--[QAAmala]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('114', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('114', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('114', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[QAAmala]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('115', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('115', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[WebadminLekshmy]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('116', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('116', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('116', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('116', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('116', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[ManagerLekshmy]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('117', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('117', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('117', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('117', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[BALekshmy]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('118', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[QALekshmy]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('119', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('119', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('119', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
--[EALekshmy]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('120', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('120', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[WebadminVarun]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('121', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('121', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('121', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('121', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('121', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[ManagerVarun]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('122', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('122', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('122', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('122', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[BAVarun]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('123', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[QAVarun]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('124', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('124', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('124', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
--[EAVarun]
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('125', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('125', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('126', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('127', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
--[WebAdminAhmed]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('128', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('128', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('128', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('128', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('128', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[WebAdminSolai]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('151', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('151', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('151', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('151', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('151', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[WebAdminChris]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('152', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('152', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('152', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('152', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('152', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
--[WebAdminSufeel]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('153', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('153', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('153', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('153', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('153', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );
	
--[WebAdminManu]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('154', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('154', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('154', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('154', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('154', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

--[WebAdminAshil]

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('155', '1', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('155', '2', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('155', '3', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('155', '4', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

INSERT INTO [User].[UserRole] ([UserID], [RoleID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
	VALUES ('155', '5', 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) );

----

--[User].[UserClinic]

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '101', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '102', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '103', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '104', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '105', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '106', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '107', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '109', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '110', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '111', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '113', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '114', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '115', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '116', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '118', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '119', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '120', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '121', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '123', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '124', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '125', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	
    
INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     VALUES ('126', 1, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime)) ;
    
INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '128', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '130', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '131', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '132', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '134', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '135', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '136', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '138', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '139', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '140', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '141', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '143', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '144', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '145', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '146', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '148', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '149', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];	

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '150', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];		

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '151', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];			

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '152', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];				

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '153', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];			

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '154', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];

INSERT INTO [User].[UserClinic] ([UserID], [ClinicID], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn])
     SELECT '155', [ClinicID], 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime) FROM [Billing].[Clinic];

UPDATE [User].[UserClinic]
SET [UserID] = 122 WHERE [ClinicID] = 1 AND [UserID] = 48;

UPDATE [User].[UserClinic]
SET [UserID] = 112 WHERE [ClinicID] = 2 AND [UserID] = 48;

UPDATE [User].[UserClinic]
SET [UserID] = 147 WHERE [ClinicID] = 3 AND [UserID] = 48;

UPDATE [User].[User] SET [LastName] = UPPER([LastName]), [FirstName] = UPPER([FirstName]), [MiddleName] = UPPER([MiddleName]);

UPDATE [Audit].[SyncStatus] SET [EndOn] = [StartOn] WHERE [EndOn] IS NULL;

--Sharon
--/Sharon
-- SENTHIL S R BEGIN
-- UPDATE [User].[User] SET [Password] = '40bd001563085fc35165329ea1ff5c5ecbdbbeef', [AlertChangePassword] = 0;	-- 123

-- SELECT [Claim].[ClaimProcessEDIFile].* FROM [Claim].[ClaimProcessEDIFile] WHERE [Claim].[ClaimProcessEDIFile].[ClaimProcessID] NOT IN (SELECT [Claim].[ClaimProcess].[ClaimProcessID] FROM [Claim].[ClaimProcess] WHERE [Claim].[ClaimProcess].[ClaimStatusID] = 23);
-- DELETE FROM [Claim].[ClaimProcessEDIFile] WHERE [Claim].[ClaimProcessEDIFile].[ClaimProcessID] NOT IN (SELECT [Claim].[ClaimProcess].[ClaimProcessID] FROM [Claim].[ClaimProcess] WHERE [Claim].[ClaimProcess].[ClaimStatusID] = 23);
-- http://stackoverflow.com/questions/11740000/check-for-file-exists-or-not-in-sql-server
-- CREATE FUNCTION dbo.fn_FileExists(@path varchar(512))
--RETURNS BIT
--AS
--BEGIN
--     DECLARE @result INT
--     EXEC master.dbo.xp_fileexist @path, @result OUTPUT
--     RETURN cast(@result as bit)
--END;
--GO
-- SENTHIL S R END

