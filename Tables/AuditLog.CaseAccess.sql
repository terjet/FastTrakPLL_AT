CREATE TABLE [AuditLog].[CaseAccess] (
  [RowId] [int] IDENTITY,
  [EventGuid] [uniqueidentifier] NOT NULL,
  [PersonId] [int] NOT NULL,
  [AccessTypeId] [int] NOT NULL,
  [AccessText] [varchar](max) NULL,
  [ClinRelId] [int] NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_CaseAccess_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_CaseAccess_CreatedBy] DEFAULT (user_id()),
  [ClosedAt] [datetime] NULL,
  [ClosedBy] [int] NULL,
  [OpenInSeconds] AS (datediff(second,[CreatedAt],[ClosedAt])),
  CONSTRAINT [PK_AuditLog_CaseAccess] PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_AuditLog_CaseAccess_CreatedAt]
  ON [AuditLog].[CaseAccess] ([CreatedAt])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_AuditLog_CaseAccess_EventGuid]
  ON [AuditLog].[CaseAccess] ([EventGuid])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_AuditLog_CaseAccess_PersonId]
  ON [AuditLog].[CaseAccess] ([PersonId])
  ON [PRIMARY]
GO

GRANT SELECT ON [AuditLog].[CaseAccess] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [AuditLog].[CaseAccess] TO [public]
GO

ALTER TABLE [AuditLog].[CaseAccess]
  ADD CONSTRAINT [FK_AuditLog_CaseAccess_ClinRelId] FOREIGN KEY ([ClinRelId]) REFERENCES [dbo].[ClinRelation] ([ClinRelId])
GO

ALTER TABLE [AuditLog].[CaseAccess]
  ADD CONSTRAINT [FK_AuditLog_CaseAccess_ClosedBy] FOREIGN KEY ([ClosedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [AuditLog].[CaseAccess]
  ADD CONSTRAINT [FK_AuditLog_CaseAccess_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [AuditLog].[CaseAccess]
  ADD CONSTRAINT [FK_AuditLog_CaseAccess_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO