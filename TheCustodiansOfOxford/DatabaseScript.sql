USE master;
GO

DROP DATABASE IF EXISTS Custodians;
GO

CREATE DATABASE Custodians;
GO

USE Custodians;
GO

-- ==================== TABLES
CREATE TABLE [dbo].[AspNetUsers] (
    [Id]                   NVARCHAR (128) NOT NULL,
    [Email]                NVARCHAR (256) NULL,
    [EmailConfirmed]       BIT            NOT NULL,
    [PasswordHash]         NVARCHAR (MAX) NULL,
    [SecurityStamp]        NVARCHAR (MAX) NULL,
    [PhoneNumber]          NVARCHAR (MAX) NULL,
    [PhoneNumberConfirmed] BIT            NOT NULL,
    [TwoFactorEnabled]     BIT            NOT NULL,
    [LockoutEndDateUtc]    DATETIME       NULL,
    [LockoutEnabled]       BIT            NOT NULL,
    [AccessFailedCount]    INT            NOT NULL,
    [UserName]             NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [dbo].[AspNetUsers]([UserName] ASC);



CREATE TABLE [dbo].[__MigrationHistory] (
    [MigrationId]    NVARCHAR (150)  NOT NULL,
    [ContextKey]     NVARCHAR (300)  NOT NULL,
    [Model]          VARBINARY (MAX) NOT NULL,
    [ProductVersion] NVARCHAR (32)   NOT NULL,
    CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED ([MigrationId] ASC, [ContextKey] ASC)
);

CREATE TABLE [dbo].[AspNetRoles] (
    [Id]   NVARCHAR (128) NOT NULL,
    [Name] NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex]
    ON [dbo].[AspNetRoles]([Name] ASC);



CREATE TABLE [dbo].[AspNetUserClaims] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [UserId]     NVARCHAR (128) NOT NULL,
    [ClaimType]  NVARCHAR (MAX) NULL,
    [ClaimValue] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_UserId]
    ON [dbo].[AspNetUserClaims]([UserId] ASC);

CREATE TABLE [dbo].[AspNetUserLogins] (
    [LoginProvider] NVARCHAR (128) NOT NULL,
    [ProviderKey]   NVARCHAR (128) NOT NULL,
    [UserId]        NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC, [UserId] ASC),
    CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_UserId]
    ON [dbo].[AspNetUserLogins]([UserId] ASC);

CREATE TABLE [dbo].[AspNetUserRoles] (
    [UserId] NVARCHAR (128) NOT NULL,
    [RoleId] NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC),
    CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_UserId]
    ON [dbo].[AspNetUserRoles]([UserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RoleId]
    ON [dbo].[AspNetUserRoles]([RoleId] ASC);

/*=========================================================*/

CREATE TABLE tblCompMem (
	compMemId			INT	NOT NULL PRIMARY KEY IDENTITY,
	compMemName			VARCHAR(30) NOT NULL,
	compMemPhoneNumber	INT	NOT NULL,
	compMemEmail		VARCHAR(30)	NOT NULL,
	compMemHours		INT	DEFAULT(0),
	payRate				INT	NOT NULL	DEFAULT(0),
	isWorking			bit	NOT NULL,
	isAdmin				bit	NOT NULL,
	isActive			bit	NOT NULL
);


CREATE TABLE tblUserService (
	userServiceId	INT	NOT NULL PRIMARY KEY IDENTITY,
	userID	INT NOT NULL,
	serviceID INT NOT NULL,
	dateOfService INT	NOT NULL,
	timeofService	INT NOT NULL,
	startDate	INT,
	endDate	INT,
	startTime	INT,
	endTime	INT,
	description	VARCHAR(150)	NOT NULL,
	rating	INT	NOT NULL,
	numNeeded	INT	NOT NULL	DEFAULT(0),
	cancelDate	INT
);

CREATE TABLE subService(
	serviceID		INT		NOT NULL PRIMARY KEY IDENTITY,
	serName			VARCHAR(50)	NOT NULL,
	serType			VARCHAR(50) NOT NULL,
	serImage		VARCHAR(250) NOT NULL,
	serDescription	VARCHAR(1000)	NOT NULL,
	serWeeklyCost	FLOAT	NOT NULL	DEFAULT(0.0),
);
INSERT INTO subService (serName, serType, serImage, serDescription, serWeeklyCost) VALUES
	('Trash Pickup', 'cleaning', 'pictures/trash_can.jpg', 'Pick up trash weekly', 5.0),
	('Weekly Cleaning', 'cleaning', 'pictures/kitchen.jpg', 'Basic cleaning service on a regular weekly schedule', 15.0)




CREATE TABLE tblServiceWorker (
	compMemId		INT NOT NULL FOREIGN KEY REFERENCES tblCompMem(compMemId),
	userServiceId	INT NOT NULL FOREIGN KEY REFERENCES tblUserService(userServiceId)
);

CREATE TABLE [dbo].[tblUser] (
    [userID]      INT     NOT NULL IDENTITY,
	[AspNetUserId] NVARCHAR (128) NOT NULL FOREIGN KEY REFERENCES AspNetUsers(id), 
    [userFirstName] VARCHAR (80) NOT NULL,
    [userLastName]	VARCHAR (80) NOT NULL,
    [userStreet]    VARCHAR (100) NOT NULL,
    [userCity]		VARCHAR (100) NOT NULL,
    [userState]		VARCHAR (100) NOT NULL,
	[userZip]		VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([userID] ASC)
);

CREATE TABLE tblService(
	serviceID		INT		NOT NULL PRIMARY KEY IDENTITY,
	serName			VARCHAR(50)	NOT NULL,
	serType			VARCHAR(50) NOT NULL,
	serImage		VARCHAR(250) NOT NULL,
	serDescription	VARCHAR(1000)	NOT NULL,
	serBaseCost		FLOAT	NOT NULL	DEFAULT(0.0),
	serDelay		INT	DEFAULT(12),					--hours?
	minLenOfService	INT	NOT NULL DEFAULT(30),			--minutes
	maxLenOfService	INT	NOT NULL DEFAULT(90)
);

CREATE TABLE tblDates( 
	dateID		INT				NOT NULL PRIMARY KEY IDENTITY,
	serDate		VARCHAR(10)		NOT NULL,
	serviceName VARCHAR(50)		NOT NULL,
	serTime		VARCHAR(10)		NOT NULL,
	Email       VARCHAR(256)	NOT NULL,
);

/*================= Data ===========================*/
INSERT INTO tblService (serName, serType, serImage, serDescription, serBaseCost, minLenOfService, maxLenOfService) VALUES
	('Bathroom', 'cleaning', 'pictures/bathroom.jpg', 'Sanitize sink, countertops, & any items on them; Clean mirrors, leave streak free; Wipe down chrome sink handles, toilet paper holder, and towel rack; Clean toilet, inside, top, and base; Tidy and straighten where necessary; Clean shower/bath walls/ceiling, floor, door, etc.; Spot check accessible baseboards and outlets covers; Remove any garbage; Spot check front cabinets; Door frames, door knobs, door trim, and hand prints; Spot check interior glass if accessible; Floors vacuumed and hand moped', 0.99, 15, 60),
	('Bedroom', 'cleaning', 'pictures/bedroom.jpg', 'Wet wipe all surfaces (desks, tables, shelving, window sills, headboards, etc.); Spot check accessible light fixtures and lamp bases; Dry dust any TV or computer equipment; Spot check accessible baseboards and outlet covers; Tidy where necessary; Make bed if sheets are left out, straighten bed if not; Check corners for cobwebs; Vacuum and/or mop floors; Spot check ceiling fan, if accessible; Spot check interior glass, if accessible; Remove any garbage', 0.99, 10, 30),
	('Deep bedroom', 'cleaning', 'pictures/bedroom.jpg', 'Accessible heating registers wiped down; Doors and trim around doors and windows cleaned; Walls cleaned; Vacuum bed or couches; Full baseboard clean; Window tracks cleaned; Blinds cleaned (dry dusted or wet wiped); Items removed from shelving areas and wiped down', 0.99, 10, 30),
	('Office space', 'cleaning', 'pictures/office_space.jpg', 'Wet wipe all surfaces (desks, tables, shelving, window sills, headboards, etc.); Spot check accessible light fixtures and lamp bases; Dry dust any TV or computer equipment; Spot check accessible baseboards and outlet covers; Tidy where necessary; Make bed if sheets are left out, straighten bed if not; Check corners for cobwebs; Vacuum and/or mop floors; Spot check ceiling fan, if accessible; Spot check interior glass, if accessible; Remove any garbage', 0.99, 10, 30),
	('Deep office space', 'cleaning', 'pictures/office_space.jpg', 'Accessible heating registers wiped down; Doors and trim around doors and windows cleaned; Walls cleaned; Vacuum bed or couches; Full baseboard clean; Window tracks cleaned; Blinds cleaned (dry dusted or wet wiped); Items removed from shelving areas and wiped down', 0.99, 10, 30),
	('Kitchen', 'cleaning', 'pictures/kitchen.jpg', 'Counters, backsplash, sink, and stove top all thoroughly wiped down. Items moved as needed.; All countertop appliances wiped down (coffee maker, toaster, blender, etc.); Spot check fronts of all cabinets (especially around the handles); Polish all large appliances (oven/stove, fridge/freezer, microwave, and dishwasher); Clean inside microwave; Window sills dusted; Interior glass spot checked (exterior on glass doors as well); Spot check accessible baseboards & outlet covers; Remove any garbage & wipe trash can down', 0.99, 30, 90),
	('Deep kitchen', 'cleaning', 'pictures/kitchen.jpg', 'Accessible heating registers wiped down; Doors & trim around doors & windows cleaned; Walls cleaned; Full Baseboard clean; Blinds cleaned (dry dusted or wet wiped); Fronts or tops of cabinets cleaned (top to bottom); Clean insides of any large appliances (fridge, freezer, oven)', 0.99, 30, 90),
	('Living room', 'cleaning', 'pictures/living_room.jpg', 'Wet wipe all surfaces (desks, tables, chairs, shelving, window sills, light fixtures, etc.); Spot check accessible light fixtures & lamp bases; Dry dust any TV or computer equipment; Spot check accessible baseboards & outlet covers; Tidy where necessary (fold blankets, straighten toys, etc.); Check corners for cobwebs; Vacuum and/or mop floors; Spot check ceiling fans, if accessible; Spot check interior glass, if accessible; Get under & around any plants & plant debris', 0.99, 10, 30),
	('Deep living room', 'cleaning', 'pictures/living_room.jpg', 'Accessible heating registers wiped down; Doors & trim around doors & windows cleaned; Walls cleaned; Vacuum couches; Full baseboard clean; Window tracks cleaned; Blinds cleaned (dry dusted or wet wiped); Items removed from shelving area & wiped down', 0.99, 10, 30),
	('Stairway/hallway', 'cleaning', 'pictures/stairway_hallway.jpg', 'Wet wipe all surfaces (tables, shelving, window sills, etc.); Spot check accessible light fixtures & lamp bases; Sanitize any railings/banisters; Dry dust artwork & picture frames; Vacuum and/or mop floors; Spot check accessible baseboards & outlet covers', 0.99, 10, 20),
	('Deep stairway/hallway', 'cleaning', 'pictures/stairway_hallway.jpg', 'Accessible heating registers wiped down; Doors & trim around doors & windows cleaned; Walls cleaned; Full baseboard clean', 0.99, 10, 20),
	('Limbo pole', 'party', 'pictures/limbo_pole.jpeg', 'Description', 0.99, 1440, 1440),
	('Bocce ball', 'party', 'pictures/bocce_ball.jpg', 'Description', 0.99, 1440, 1440),
	('LED corn hole', 'party', 'pictures/led_corn_hole.jpg', 'Description', 0.99, 1440, 1440),
	('Giant wood connect 4', 'party', 'pictures/giant_wood_connect_4.jpg', 'Description', 0.99, 1440, 1440),
	('Horse shoe', 'party', 'pictures/horse_shoe.jpg', 'Description', 0.99, 1440, 1440),
	('Ladder ball', 'party', 'pictures/ladder_ball.jpg', 'Description', 0.99, 1440, 1440),
	('Croquet', 'party', 'pictures/croquet.jpg', 'Description', 0.99, 1440, 1440),
	('Badminton', 'party', 'pictures/badminton.jpeg', 'Description', 0.99, 1440, 1440),
	('Giant beer pong', 'party', 'pictures/giant_beer_pong.jpg', 'Description', 0.99, 1440, 1440),
	('Giant jenga', 'party', 'pictures/giant_jenga.jpg', 'Description', 0.99, 1440, 1440),
	('Giant lite brite', 'party', 'pictures/giant_lite_brite.jpg', 'Description', 0.99, 1440, 1440),
	('Giant plinko', 'party', 'pictures/giant_plinko.jpg', 'Description', 0.99, 1440, 1440),
	('Pitch burst', 'party', 'pictures/pitch_burst.jpg', 'Description', 0.99, 1440, 1440),
	('Tug-of-war', 'party', 'pictures/tug_of_war.jpg', 'Description', 0.99, 1440, 1440),
	('Sack races', 'party', 'pictures/sack_races.jpg', 'Description', 0.99, 1440, 1440),
	('Zorb balls', 'party', 'pictures/zorb_balls.jpg', 'Description', 0.99, 1440, 1440),
	('Sumo suits', 'party', 'pictures/sumo_suits.jpg', 'Description', 0.99, 1440, 1440),
	('Foam machine', 'party', 'pictures/foam_machine.jpg', 'Description', 0.99, 1440, 1440),
	('Disco ball', 'party', 'pictures/disco_ball.jpeg', 'Description', 0.99, 1440, 1440),
	('Bubble machine', 'party', 'pictures/bubble_machine.jpg', 'Description', 0.99, 1440, 1440),
	('Fog machine', 'party', 'pictures/fog_machine.jpg', 'Description', 0.99, 1440, 1440),
	('Laser lights', 'party', 'pictures/laser_lights.jpg', 'Description', 0.99, 1440, 1440),
	('Cannonball air blaster', 'party', 'pictures/cannonball_air_blaster.jpg', 'Description', 0.99, 1440, 1440),
	('Goodwill pickup', 'other', 'pictures/goodwill_pickup.jpg', 'Pick up bags or furniture for delivery to Goodwill', 0.99, 10, 20),
	('Snow removal', 'other', 'pictures/snow_removal.jpg', 'During the colder months, we offer snow removal on sidewalks, driveways, and front areas. We have pet safe salt, and regular salt to be offered.', 0.99, 30, 60),
	('Car detailing', 'other', 'pictures/car_detailing.jpg', 'We are able to detail the inside and/or outside of your car.', 0.99, 1440, 1440),
	('Plant care', 'other', 'pictures/plant_care.jpg', 'We are able to take care of indoor or outdoor plants weekly, monthly, or yearly.. ', 0.99, 1440, 1440),
	('Pressure washing', 'other', 'pictures/pressure_washing.jpg', 'We are able to provide pressure washing on the outdoor patio, driveway, sidewalk, or side of your home.', 0.99, 1440, 1440),
	('Magnetic sweep', 'other', 'pictures/magnetic_sweep.jpg.jpg', 'Description', 0.99, 30, 60),
	('Yard waste clean', 'other', 'pictures/yard_waste_clean.jpeg', 'Description', 0.99, 30, 60),
	('House monitoring', 'other', 'pictures/house_monitoring.jpg', 'Description', 0.99, 30, 60)

	-- Stored Procedures
	GO

	CREATE PROCEDURE GetServicesRow
	AS
	BEGIN
	SELECT * FROM tblService
	END
	GO
