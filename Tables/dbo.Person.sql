CREATE TABLE [dbo].[Person] (
  [PersonId] [int] IDENTITY,
  [DOB] [datetime] NOT NULL,
  [FstName] [varchar](30) NOT NULL,
  [MidName] [varchar](30) NULL,
  [LstName] [varchar](30) NOT NULL,
  [GenderId] [tinyint] NOT NULL,
  [NationalId] [varchar](16) NULL,
  [HPRNo] [int] NULL,
  [CAVE] [varchar](max) NULL,
  [FullName] AS (((isnull([FstName],'')+rtrim(' '+isnull([MidName],'')))+' ')+isnull([LstName],'')),
  [Initials] AS ((substring(isnull([FstName],'?'),(1),(1))+rtrim(substring(isnull([MidName],' '),(1),(1))))+substring(isnull([LstName],'?'),(1),(1))),
  [NatGenderId] AS ((2)-CONVERT([int],substring([NationalId],(9),(1)),(0))%(2)),
  [Signature] AS ((substring(isnull([FstName],'?'),(1),(2))+rtrim(substring(isnull([MidName],' '),(1),(1))))+substring(isnull([LstName],'??'),(1),(2))),
  [BestId] AS (isnull([NationalId],CONVERT([varchar],[DOB],(104)))),
  [ReverseName] AS (rtrim(((([LstName]+', ')+[FstName])+' ')+isnull([MidName],''))),
  [GSM] [varchar](20) NULL,
  [CreatedAt] [datetime] NULL CONSTRAINT [DF_Person_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_Person_CreatedBy] DEFAULT (user_id()),
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Person_guid] DEFAULT (newid()),
  [NB] [varchar](max) NULL,
  [Reservations] [varchar](max) NULL,
  [Allergies] [varchar](max) NULL,
  [DeceasedDate] [datetime] NULL,
  [DeceasedInd] [bit] NULL,
  [StreetAddress] [varchar](64) NULL,
  [PostalCode] [varchar](12) NULL,
  [City] [varchar](32) NULL,
  [KommuneNr] [varchar](8) NULL,
  [KommuneNavn] [varchar](32) NULL,
  [FylkeNr] [varchar](8) NULL,
  [FylkeNavn] [varchar](32) NULL,
  [TestCase] [bit] NOT NULL CONSTRAINT [DF_Person_TestCase] DEFAULT (0),
  [UserName] [varchar](32) NULL,
  [EmployeeNumber] [int] NULL,
  [EmailAddress] [varchar](64) NULL,
  [AddressLine1] [varchar](64) NULL,
  [AddressLine2] [varchar](64) NULL,
  [HomePostalCode] [varchar](8) NULL,
  [HomeCity] [varchar](32) NULL,
  [JobTitle] [varchar](32) NULL,
  [WorkDepartment] [varchar](32) NULL,
  [SupervisorEmployeeNumber] [int] NULL,
  [FMEnabled] [bit] NOT NULL CONSTRAINT [DF_Person_FMEnabled] DEFAULT (0),
  [FMLastUpdate] [datetime] NULL,
  [FMPatientId] [varchar](50) NULL,
  CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PersonId]),
  CONSTRAINT [IX_Person_DOB] UNIQUE ([DOB], [FstName], [LstName]),
  CONSTRAINT [C_NationalIdMatchesDOB] CHECK (datalength([NationalId])=(0) OR replace(CONVERT([varchar],[DOB],(4)),'.','')=substring([NationalId],(1),(6)) OR (CONVERT([int],replace(CONVERT([varchar],[DOB],(4)),'.',''))+(400000))=CONVERT([int],substring([NationalId],(1),(6))) OR (CONVERT([int],replace(CONVERT([varchar],[DOB],(4)),'.',''))+(4000))=CONVERT([int],substring([NationalId],(1),(6)))),
  CONSTRAINT [C_NationalIdMatchesGenderId] CHECK (CONVERT([int],substring([NationalId],(9),(1)))%(2)=[GenderId]%(2) OR datalength([NationalId])=(0)),
  CONSTRAINT [C_Person_DOB_First] CHECK ([DOB]>='1890-01-01'),
  CONSTRAINT [C_Person_DOB_Last] CHECK ([DOB]<getdate())
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_Person_EmployeeNumber]
  ON [dbo].[Person] ([EmployeeNumber])
  WHERE ([EmployeeNumber] IS NOT NULL)
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_Person_FMPatientId]
  ON [dbo].[Person] ([FMPatientId])
  WHERE ([FMPatientId] IS NOT NULL)
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_Person_HPRNo]
  ON [dbo].[Person] ([HPRNo])
  WHERE ([HPRNo] IS NOT NULL)
  ON [PRIMARY]
GO

CREATE INDEX [I_Person_LstName]
  ON [dbo].[Person] ([LstName], [FstName])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_Person_NationalId]
  ON [dbo].[Person] ([NationalId])
  WHERE ([NationalId] IS NOT NULL)
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_Person_UserName]
  ON [dbo].[Person] ([UserName])
  WHERE ([UserName] IS NOT NULL)
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Person_UpdateDocuments] ON [dbo].[Person] 
AFTER UPDATE AS 
BEGIN      
  SET NOCOUNT ON;
  IF UPDATE(CAVE)
  BEGIN
    INSERT INTO dbo.PersonDocumentLog (PersonId, DocumentId, Content ) 
      SELECT i.PersonId, 50001, i.CAVE
        FROM deleted d
             JOIN inserted i ON i.PersonId = d.PersonId
       WHERE ISNULL(i.CAVE,'') <> ISNULL(d.CAVE,'');
  END;
  
  IF UPDATE(Reservations)
  BEGIN
    INSERT INTO dbo.PersonDocumentLog (PersonId, DocumentId, Content ) 
      SELECT i.PersonId, 50003, i.Reservations
        FROM deleted d
             JOIN inserted i ON i.PersonId = d.PersonId
       WHERE ISNULL(i.Reservations,'') <> ISNULL(d.Reservations,'');
  END;

  IF UPDATE(NB)
  BEGIN
    INSERT INTO dbo.PersonDocumentLog (PersonId, DocumentId, Content ) 
      SELECT i.PersonId, 50005, i.NB
        FROM deleted d
             JOIN inserted i ON i.PersonId = d.PersonId
       WHERE ISNULL(i.NB,'') <> ISNULL(d.NB,'');
  END;

 IF UPDATE(Allergies) 
  BEGIN
    INSERT INTO dbo.PersonDocumentLog (PersonId, DocumentId, Content ) 
      SELECT i.PersonId, 11036, i.Allergies
        FROM deleted d
             JOIN inserted i ON i.PersonId = d.PersonId
       WHERE ISNULL(i.Allergies,'') <> ISNULL(d.Allergies,'');
  END;

END;
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_Person_Update]
ON [dbo].[Person]
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	IF UPDATE(NationalId)
		OR UPDATE(FstName)
		OR UPDATE(MidName)
		OR UPDATE(LstName)
		OR UPDATE(DOB)
		OR UPDATE(GenderId)
		OR UPDATE(DeceasedDate)
		OR UPDATE(DeceasedInd)
		OR UPDATE(TestCase)
	BEGIN
		INSERT INTO dbo.PersonLog (PersonId, DOB, FstName, MidName, LstName, GenderId, NationalId, DeceasedDate, DeceasedInd, TestCase)
			SELECT d.PersonId, d.DOB, d.FstName, d.MidName, d.LstName, d.GenderId, d.NationalId, d.DeceasedDate, d.DeceasedInd, d.TestCase
			FROM deleted d
			JOIN inserted i ON i.PersonId = d.PersonId
			WHERE (ISNULL(i.NationalId, '') <> ISNULL(d.NationalId, ''))
			OR (i.FullName <> d.FullName)
			OR (i.DOB <> d.DOB)
			OR (i.GenderId <> d.GenderId)
			OR (i.DeceasedDate <> d.DeceasedDate)
			OR (ISNULL(i.DeceasedInd, 0) <> ISNULL(d.DeceasedInd, 0))
			OR (ISNULL(i.TestCase,0) <> ISNULL(d.TestCase,0));
	END;
END;
GO

GRANT SELECT ON [dbo].[Person] TO [FastTrak]
GO

GRANT SELECT ON [dbo].[Person] TO [LabImport]
GO

ALTER TABLE [dbo].[Person]
  ADD CONSTRAINT [FK_Person_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[Person]
  ADD CONSTRAINT [FK_Person_GenderId] FOREIGN KEY ([GenderId]) REFERENCES [dbo].[MetaGender] ([GenderId])
GO