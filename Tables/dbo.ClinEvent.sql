SET QUOTED_IDENTIFIER ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ClinEvent] (
  [EventId] [int] IDENTITY,
  [StudyId] [int] NOT NULL,
  [PersonId] [int] NOT NULL,
  [EventNum] [int] NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_ClinEvent_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_ClinEvent_CreatedBy] DEFAULT (user_id()),
  [EventTime] AS (CONVERT([datetime],CONVERT([float],[EventNum]-(24),(0))/(24)+(0.00000002),(0))) PERSISTED,
  [StatusId] [int] NULL,
  [GroupId] [int] NULL,
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ClinEvent_guid] DEFAULT (newid()),
  CONSTRAINT [PK_ClinEvent] PRIMARY KEY CLUSTERED ([EventId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_ClinEvent_EventTime]
  ON [dbo].[ClinEvent] ([EventTime])
  ON [PRIMARY]
GO

CREATE INDEX [I_ClinEvent_GroupId]
  ON [dbo].[ClinEvent] ([GroupId])
  ON [PRIMARY]
GO

CREATE INDEX [I_ClinEvent_Person]
  ON [dbo].[ClinEvent] ([PersonId])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_ClinEvent_StudyPersonEvent]
  ON [dbo].[ClinEvent] ([StudyId], [PersonId], [EventNum])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[ClinEvent] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[ClinEvent] TO [public]
GO

ALTER TABLE [dbo].[ClinEvent]
  ADD CONSTRAINT [FK_ClinEvent_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[ClinEvent] WITH NOCHECK
  ADD CONSTRAINT [FK_ClinEvent_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [dbo].[ClinEvent] WITH NOCHECK
  ADD CONSTRAINT [FK_ClinEvent_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO