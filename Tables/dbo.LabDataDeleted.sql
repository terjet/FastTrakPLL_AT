CREATE TABLE [dbo].[LabDataDeleted] (
  [ResultId] [int] NOT NULL,
  [PersonId] [int] NOT NULL,
  [LabDate] [datetime] NOT NULL,
  [LabCodeId] [int] NOT NULL,
  [OrigCodeId] [int] NULL,
  [NumResult] [float] NULL,
  [TxtResult] [varchar](max) NULL,
  [DevResult] [tinyint] NULL,
  [RefInterval] [varchar](max) NULL,
  [Comment] [varchar](max) NULL,
  [CreatedAt] [datetime] NOT NULL,
  [CreatedBy] [int] NOT NULL,
  [SignedAt] [datetime] NULL,
  [SignedBy] [int] NULL,
  [BatchId] [int] NULL,
  [UnitStr] [varchar](24) NULL,
  [ArithmeticComp] [char](2) NULL,
  [Text32] AS (substring([TxtResult],(1),(32))),
  [InvestigationId] [varchar](16) NULL,
  CONSTRAINT [PK_LabDataDeleted] PRIMARY KEY CLUSTERED ([ResultId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[LabDataDeleted]
  ADD CONSTRAINT [FK_LabDataDeleted_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[LabDataDeleted]
  ADD CONSTRAINT [FK_LabDataDeleted_LabCodeId] FOREIGN KEY ([LabCodeId]) REFERENCES [dbo].[LabCode] ([LabCodeId])
GO

ALTER TABLE [dbo].[LabDataDeleted]
  ADD CONSTRAINT [FK_LabDataDeleted_OrigCodeId] FOREIGN KEY ([OrigCodeId]) REFERENCES [dbo].[LabCode] ([LabCodeId])
GO

ALTER TABLE [dbo].[LabDataDeleted]
  ADD CONSTRAINT [FK_LabDataDeleted_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [dbo].[LabDataDeleted]
  ADD CONSTRAINT [FK_LabDataDeleted_SignedBy] FOREIGN KEY ([SignedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO