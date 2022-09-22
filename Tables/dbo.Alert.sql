CREATE TABLE [dbo].[Alert] (
  [AlertId] [int] IDENTITY,
  [PersonId] [int] NULL,
  [UserId] [int] NULL,
  [StudyId] [int] NULL,
  [AlertClass] [varchar](24) NOT NULL,
  [AlertFacet] [varchar](16) NOT NULL,
  [AlertLevel] [tinyint] NOT NULL,
  [AlertHeader] [varchar](max) NULL,
  [AlertMessage] [varchar](max) NULL,
  [AlertButtons] [varchar](6) NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_Alert_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_Alert_CreatedBy] DEFAULT (user_id()),
  [HideUntil] [datetime] NULL,
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Alert_guid] DEFAULT (newid()),
  CONSTRAINT [PK_Alert] PRIMARY KEY CLUSTERED ([AlertId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [I_Alert_Person]
  ON [dbo].[Alert] ([PersonId])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_Alert_StudyPersonClass]
  ON [dbo].[Alert] ([StudyId], [PersonId], [AlertClass])
  ON [PRIMARY]
GO

CREATE INDEX [I_Alert_User]
  ON [dbo].[Alert] ([UserId])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[Alert] WITH NOCHECK
  ADD CONSTRAINT [FK_Alert_AlertFacet] FOREIGN KEY ([AlertFacet]) REFERENCES [dbo].[MetaAlertFacet] ([FacetName])
GO

ALTER TABLE [dbo].[Alert] WITH NOCHECK
  ADD CONSTRAINT [FK_Alert_AlertLevel] FOREIGN KEY ([AlertLevel]) REFERENCES [dbo].[MetaAlertLevel] ([AlertLevel])
GO

ALTER TABLE [dbo].[Alert]
  ADD CONSTRAINT [FK_Alert_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[Alert]
  ADD CONSTRAINT [FK_Alert_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Alert]
  ADD CONSTRAINT [FK_Alert_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO

ALTER TABLE [dbo].[Alert]
  ADD CONSTRAINT [FK_Alert_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserList] ([UserId])
GO