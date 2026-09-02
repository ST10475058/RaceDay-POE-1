/* ============================================================
   RaceDay - Database Creation Script
   System : RaceDay Event Management System
   Author : SIYETHEMBA XULU
   Target : Microsoft SQL Server (SSMS)
   Notes  : Run on a clean SQL Server instance. Creates the
            RaceDayDB database, all tables with keys and
            constraints, then seeds sample data.
   ============================================================ */

--IF DB_ID('RaceDayDB') IS NOT NULL
--BEGIN
--    ALTER DATABASE RaceDayDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--    DROP DATABASE RaceDayDB;
--END
--GO

--CREATE DATABASE RaceDayDB;
--GO

--USE RaceDayDB;
--GO

/* ------------------------------------------------------------
   1. Organisers
   ------------------------------------------------------------ */
--CREATE TABLE Organisers (
--    OrganiserID     INT IDENTITY(1,1) PRIMARY KEY,
--    FullName        NVARCHAR(100)   NOT NULL,
--    Email           NVARCHAR(150)   NOT NULL UNIQUE,
--    PasswordHash    NVARCHAR(255)   NOT NULL,
--    PhoneNumber     NVARCHAR(20)    NULL,
--    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE()
--);
--GO

--/* ------------------------------------------------------------
--   2. Participants
--   ------------------------------------------------------------ */
--CREATE TABLE Participants (
--    ParticipantID   INT IDENTITY(1,1) PRIMARY KEY,
--    FullName        NVARCHAR(100)   NOT NULL,
--    Email           NVARCHAR(150)   NOT NULL UNIQUE,
--    PasswordHash    NVARCHAR(255)   NOT NULL,
--    DateOfBirth     DATE            NULL,
--    PhoneNumber     NVARCHAR(20)    NULL,
--    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE()
--);
--GO

--/* ------------------------------------------------------------
--   3. Events
--   ------------------------------------------------------------ */
--CREATE TABLE Events (
--    EventID         INT IDENTITY(1,1) PRIMARY KEY,
--    OrganiserID     INT             NOT NULL,
--    EventName       NVARCHAR(150)   NOT NULL,
--    EventType       NVARCHAR(50)    NOT NULL,   -- Running / Walking / Cycling
--    EventDate       DATETIME        NOT NULL,
--    Location        NVARCHAR(150)   NOT NULL,
--    Description     NVARCHAR(1000)  NULL,
--    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE(),
--    CONSTRAINT FK_Events_Organisers FOREIGN KEY (OrganiserID)
--        REFERENCES Organisers (OrganiserID),
--    CONSTRAINT CK_Events_EventType CHECK (EventType IN ('Running', 'Walking', 'Cycling'))
--);
--GO

--CREATE INDEX IX_Events_OrganiserID ON Events (OrganiserID);
--GO

--/* ------------------------------------------------------------
--   4. Categories
--   ------------------------------------------------------------ */
--CREATE TABLE Categories (
--    CategoryID      INT IDENTITY(1,1) PRIMARY KEY,
--    EventID         INT             NOT NULL,
--    CategoryName    NVARCHAR(100)   NOT NULL,
--    Distance        DECIMAL(6,2)    NOT NULL,   -- km
--    MaxParticipants INT             NOT NULL DEFAULT 100,
--    Price           DECIMAL(8,2)    NOT NULL DEFAULT 0,
--    CONSTRAINT FK_Categories_Events FOREIGN KEY (EventID)
--        REFERENCES Events (EventID),
--    CONSTRAINT CK_Categories_Distance CHECK (Distance > 0),
--    CONSTRAINT CK_Categories_MaxParticipants CHECK (MaxParticipants > 0)
--);
--GO

--CREATE INDEX IX_Categories_EventID ON Categories (EventID);
--GO

--/* ------------------------------------------------------------
--   5. Enrolments (resolves the Participants <-> Categories
--      many-to-many relationship)
--   ------------------------------------------------------------ */
--CREATE TABLE Enrolments (
--    EnrolmentID     INT IDENTITY(1,1) PRIMARY KEY,
--    ParticipantID   INT             NOT NULL,
--    CategoryID      INT             NOT NULL,
--    EnrolmentDate   DATETIME        NOT NULL DEFAULT GETDATE(),
--    Status          NVARCHAR(20)    NOT NULL DEFAULT 'Confirmed',   -- Confirmed / Cancelled
--    CONSTRAINT FK_Enrolments_Participants FOREIGN KEY (ParticipantID)
--        REFERENCES Participants (ParticipantID),
--    CONSTRAINT FK_Enrolments_Categories FOREIGN KEY (CategoryID)
--        REFERENCES Categories (CategoryID),
--    CONSTRAINT UQ_Enrolments_Participant_Category UNIQUE (ParticipantID, CategoryID),
--    CONSTRAINT CK_Enrolments_Status CHECK (Status IN ('Confirmed', 'Cancelled'))
--);
--GO

--CREATE INDEX IX_Enrolments_ParticipantID ON Enrolments (ParticipantID);
--CREATE INDEX IX_Enrolments_CategoryID ON Enrolments (CategoryID);
--GO

--/* ------------------------------------------------------------
--   6. Results
--   ------------------------------------------------------------ */
--CREATE TABLE Results (
--    ResultID                INT IDENTITY(1,1) PRIMARY KEY,
--    EnrolmentID             INT             NOT NULL UNIQUE,
--    RecordedByOrganiserID   INT             NOT NULL,
--    FinishTime              TIME            NOT NULL,
--    Position                INT             NULL,
--    RecordedAt              DATETIME        NOT NULL DEFAULT GETDATE(),
--    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentID)
--        REFERENCES Enrolments (EnrolmentID),
--    CONSTRAINT FK_Results_Organisers FOREIGN KEY (RecordedByOrganiserID)
--        REFERENCES Organisers (OrganiserID),
--    CONSTRAINT CK_Results_Position CHECK (Position IS NULL OR Position > 0)
--);
--GO

--CREATE INDEX IX_Results_RecordedByOrganiserID ON Results (RecordedByOrganiserID);
--GO

--/* ============================================================
--   Sample data
   --============================================================ */

 --Organisers (2)
--INSERT INTO Organisers (FullName, Email, PasswordHash, PhoneNumber) VALUES
--('Sipho Ndlovu', 'sipho.ndlovu@raceday.co.za', 'HASHED_PWD_1', '0821234567'),
--('Anke van der Merwe', 'anke.vdm@raceday.co.za', 'HASHED_PWD_2', '0837654321');

------ Participants (2)
--INSERT INTO Participants (FullName, Email, PasswordHash, DateOfBirth, PhoneNumber) VALUES
--('Thabo Mokoena', 'thabo.mokoena@example.com', 'HASHED_PWD_3', '1994-03-12', '0731122334'),
--('Lindiwe Zulu', 'lindiwe.zulu@example.com', 'HASHED_PWD_4', '1998-07-25', '0729988776');

---- Events (3)
--INSERT INTO Events (OrganiserID, EventName, EventType, EventDate, Location, Description) VALUES
--(1, 'Vryheid Community Fun Run', 'Running', '2026-10-10 07:00:00', 'Vryheid, KwaZulu-Natal', 'Annual community fun run supporting local schools.'),
--(1, 'Vryheid Cycle Challenge', 'Cycling', '2026-11-14 06:30:00', 'Vryheid, KwaZulu-Natal', 'Road cycling event over three route distances.'),
--(2, 'Durban Beachfront Park Walk', 'Walking', '2026-09-20 08:00:00', 'Durban, KwaZulu-Natal', 'Family-friendly walk along the Durban beachfront.');

---- Categories (2 or more per event)
--INSERT INTO Categories (EventID, CategoryName, Distance, MaxParticipants, Price) VALUES
--(1, '5km Fun Run', 5.00, 200, 80.00),
--(1, '10km Race', 10.00, 150, 120.00),
--(2, '40km Road Ride', 40.00, 100, 200.00),
--(2, '80km Road Ride', 80.00, 80, 250.00),
--(3, '3km Family Walk', 3.00, 300, 0.00);

---- Enrolments (sample)
--INSERT INTO Enrolments (ParticipantID, CategoryID, Status) VALUES
--(1, 1, 'Confirmed'),
--(1, 3, 'Confirmed'),
--(2, 2, 'Confirmed'),
--(2, 5, 'Confirmed');

---- Results (sample, captured by an organiser)
--INSERT INTO Results (EnrolmentID, RecordedByOrganiserID, FinishTime, Position) VALUES
--(1, 1, '00:28:14', 12),
--(3, 1, '00:52:03', 5);
--GO

--/* ============================================================
--   Verification Queries (run these to test your database)
--   ============================================================ */

---- Check all tables exist
--SELECT TABLE_NAME 
--FROM INFORMATION_SCHEMA.TABLES 
--WHERE TABLE_TYPE = 'BASE TABLE'
--ORDER BY TABLE_NAME;
--GO

-- View all Organisers
--SELECT * FROM Organisers;
--GO

---- View all Participants
--SELECT * FROM Participants;
--GO

---- View all Events with Organiser names
--SELECT 
--    e.EventID,
--    e.EventName,
--    e.EventType,
--    e.EventDate,
--    e.Location,
--    o.FullName AS OrganiserName
--FROM Events e
--INNER JOIN Organisers o ON e.OrganiserID = o.OrganiserID;
--GO

-- View all Categories with Event names
--SELECT 
--    c.CategoryID,
--    c.CategoryName,
--    c.Distance,
--    c.MaxParticipants,
--    c.Price,
--    e.EventName
--FROM Categories c
--INNER JOIN Events e ON c.EventID = e.EventID;
--GO

---- View all Enrolments with Participant and Category details
--SELECT 
--    en.EnrolmentID,
--    p.FullName AS ParticipantName,
--    c.CategoryName,
--    c.Distance,
--    c.Price,
--    en.EnrolmentDate,
--    en.Status
--FROM Enrolments en
--INNER JOIN Participants p ON en.ParticipantID = p.ParticipantID
--INNER JOIN Categories c ON en.CategoryID = c.CategoryID;
--GO

---- View all Results with Participant, Category, and Organiser details
--SELECT 
--    r.ResultID,
--    p.FullName AS ParticipantName,
--    c.CategoryName,
--    c.Distance,
--    r.FinishTime,
--    r.Position,
--    o.FullName AS RecordedByOrganiser,
--    r.RecordedAt
--FROM Results r
--INNER JOIN Enrolments en ON r.EnrolmentID = en.EnrolmentID
--INNER JOIN Participants p ON en.ParticipantID = p.ParticipantID
--INNER JOIN Categories c ON en.CategoryID = c.CategoryID
--INNER JOIN Organisers o ON r.RecordedByOrganiserID = o.OrganiserID
--ORDER BY r.Position;
--GO