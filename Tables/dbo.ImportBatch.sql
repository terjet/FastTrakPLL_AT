CREATE TABLE [dbo].[ImportBatch] (
  [BatchId] [int] IDENTITY,
  [ContextId] [int] NOT NULL,
  [CreatedBy] [int] NULL CONSTRAINT [DF_ImportBatch_CreatedBy] DEFAULT (user_id()),
  [CreatedAt] [datetime] NULL CONSTRAINT [DF_ImportBatch_CreatedAt] DEFAULT (getdate()),
  [ClosedAt] [datetime] NULL,
  [SecondsElapsed] AS ((((CONVERT([float],[ClosedAt],(0))-CONVERT([float],[CreatedAt],(0)))*(24))*(60))*(60)),
  [ErrorCount] [int] NULL,
  [ErrorMessages] [varchar](max) NULL,
  CONSTRAINT [PK_ImportBatch] PRIMARY KEY CLUSTERED ([BatchId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[ImportBatch] TO [FastTrak]
GO

ALTER TABLE [dbo].[ImportBatch]
  ADD CONSTRAINT [FK_ImportBatch_ContextId] FOREIGN KEY ([ContextId]) REFERENCES [dbo].[ImportContext] ([ContextId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ImportBatch]
  ADD CONSTRAINT [FK_ImportBatch_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO