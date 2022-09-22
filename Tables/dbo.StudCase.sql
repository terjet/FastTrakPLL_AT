CREATE TABLE [dbo].[StudCase] (
  [StudyId] [int] NOT NULL,
  [PersonId] [int] NOT NULL,
  [FinState] [int] NULL CONSTRAINT [DF_StudCase_FinState] DEFAULT (1),
  [GroupId] [int] NULL,
  [CreatedBy] [int] NULL CONSTRAINT [DF_StudCase_CreatedBy] DEFAULT (user_id()),
  [CreatedAt] [datetime] NULL CONSTRAINT [DF_StudCase_CreatedAt] DEFAULT (getdate()),
  [HandledBy] [int] NULL CONSTRAINT [DF_StudCase_HandledBy] DEFAULT (user_id()),
  [Investor] AS (user_name([HandledBy])),
  [LastWrite] [datetime] NULL,
  [LastRuleExecute] [datetime] NULL,
  [RuleLag] AS ((((24)*(60))*(60))*(CONVERT([float],[LastWrite],(0))-CONVERT([float],[LastRuleExecute],(0)))),
  [StudCaseId] [int] IDENTITY,
  [StatusId] AS ([FinState]),
  [MarkedForExport] [int] NULL CONSTRAINT [DF_StudCase_MarkedForExport] DEFAULT (0),
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_StudCase_guid] DEFAULT (newid()) ROWGUIDCOL,
  [Journalansvarlig] [int] NULL,
  CONSTRAINT [PK_StudCase] PRIMARY KEY CLUSTERED ([StudCaseId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_StudCase_PersonId]
  ON [dbo].[StudCase] ([PersonId])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_StudCase_StudyIdPersonId]
  ON [dbo].[StudCase] ([StudyId], [PersonId])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_StudCase_Update] ON [dbo].[StudCase]
AFTER UPDATE AS 
 BEGIN
  INSERT INTO dbo.StudCaseLog( StudCaseId, OldStatusId, OldGroupId, OldJournalansvarlig, NewStatusId, NewGroupId, NewJournalansvarlig )
    SELECT o.StudCaseId,o.FinState,o.GroupId,o.Journalansvarlig,n.FinState,n.GroupId,n.Journalansvarlig
    FROM deleted o JOIN inserted n on n.StudCaseId=o.StudCaseId
    AND (( o.FinState<>n.FinState) OR (ISNULL(o.GroupId,0)<>ISNULL(n.GroupId,0)) OR ( ISNULL(o.Journalansvarlig,0) <> ISNULL(n.Journalansvarlig,0) )  )
END
GO

GRANT SELECT ON [dbo].[StudCase] TO [FastTrak]
GO

GRANT INSERT ON [dbo].[StudCase] TO [superuser]
GO

ALTER TABLE [dbo].[StudCase]
  ADD CONSTRAINT [FK_StudCase_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[StudCase]
  ADD CONSTRAINT [FK_StudCase_HandledBy] FOREIGN KEY ([HandledBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[StudCase]
  ADD CONSTRAINT [FK_StudCase_Journalansvarlig] FOREIGN KEY ([Journalansvarlig]) REFERENCES [dbo].[UserList] ([UserId]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[StudCase] WITH NOCHECK
  ADD CONSTRAINT [FK_StudCase_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[StudCase]
  ADD CONSTRAINT [FK_StudCase_StudyGroup] FOREIGN KEY ([StudyId], [GroupId]) REFERENCES [dbo].[StudyGroup] ([StudyId], [GroupId])
GO

ALTER TABLE [dbo].[StudCase] WITH NOCHECK
  ADD CONSTRAINT [FK_StudCase_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[StudCase]
  ADD CONSTRAINT [FK_StudCase_StudyStatus] FOREIGN KEY ([StudyId], [FinState]) REFERENCES [dbo].[StudyStatus] ([StudyId], [StatusId])
GO