CREATE TABLE [Pandemic].[Contact] (
  [RowId] [int] IDENTITY,
  [ContextId] [int] NOT NULL,
  [ContactGuid] [uniqueidentifier] NOT NULL,
  [ContactPersonId] [int] NULL,
  [PersonDescription] [varchar](max) NULL,
  [DOB] [datetime] NULL,
  [GenderId] [int] NULL,
  [FirstName] [varchar](32) NULL,
  [LastName] [varchar](32) NULL,
  [EmailAddress] [varchar](64) NULL,
  [GSM] [varchar](20) NULL,
  [BostedKommune] [varchar](32) NULL,
  [ExposureType] [varchar](max) NULL,
  [FirstExposure] [datetime] NULL,
  [LastExposure] [datetime] NULL,
  [TrackingResponsible] [varchar](64) NULL,
  [IndexPersonId] [int] NOT NULL,
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_Contact_CreatedBy] DEFAULT (user_id()),
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_Contact_CreatedAt] DEFAULT (getdate()),
  [StateId] [int] NOT NULL CONSTRAINT [DF_Contact_StateId] DEFAULT (1),
  [CaseTrackedBy] [int] NULL,
  [DeletedAt] [datetime] NULL,
  [DeletedBy] [int] NULL,
  [RowStamp] [timestamp],
  [ExposureCodes] [varchar](32) NULL,
  PRIMARY KEY CLUSTERED ([ContactGuid])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_Pandemic_Contact]
  ON [Pandemic].[Contact] ([ContextId], [IndexPersonId], [ContactPersonId])
  WHERE ([ContactPersonId] IS NOT NULL)
  ON [PRIMARY]
GO

CREATE INDEX [I_Pandemic_Contact_IndexPersonId]
  ON [Pandemic].[Contact] ([IndexPersonId])
  ON [PRIMARY]
GO

ALTER TABLE [Pandemic].[Contact]
  ADD CONSTRAINT [FK_Pandemic_Contact_CaseTrackedBy] FOREIGN KEY ([CaseTrackedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [Pandemic].[Contact]
  ADD CONSTRAINT [FK_Pandemic_Contact_ContactPersonId] FOREIGN KEY ([ContactPersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [Pandemic].[Contact]
  ADD CONSTRAINT [FK_Pandemic_Contact_ContextId] FOREIGN KEY ([ContextId]) REFERENCES [Pandemic].[Context] ([ContextId])
GO

ALTER TABLE [Pandemic].[Contact]
  ADD CONSTRAINT [FK_Pandemic_Contact_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [Pandemic].[Contact]
  ADD CONSTRAINT [FK_Pandemic_Contact_DeletedBy] FOREIGN KEY ([DeletedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [Pandemic].[Contact]
  ADD CONSTRAINT [FK_Pandemic_Contact_IndexPersonId] FOREIGN KEY ([IndexPersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [Pandemic].[Contact]
  ADD CONSTRAINT [FK_Pandemic_Contact_StateId] FOREIGN KEY ([StateId]) REFERENCES [Pandemic].[MetaContactState] ([StateId])
GO