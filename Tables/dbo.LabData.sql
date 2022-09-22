CREATE TABLE [dbo].[LabData] (
  [ResultId] [int] IDENTITY,
  [PersonId] [int] NOT NULL,
  [LabDate] [datetime] NOT NULL,
  [LabCodeId] [int] NOT NULL,
  [OrigCodeId] [int] NULL,
  [NumResult] [float] NULL,
  [TxtResult] [varchar](max) NULL,
  [DevResult] [tinyint] NULL,
  [RefInterval] [varchar](max) NULL,
  [Comment] [varchar](max) NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_LabData_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_LabData_CreatedBy] DEFAULT (user_id()),
  [SignedAt] [datetime] NULL,
  [SignedBy] [int] NULL,
  [BatchId] [int] NULL,
  [UnitStr] [varchar](24) NULL,
  [ArithmeticComp] [char](2) NULL,
  [Text32] AS (substring([TxtResult],(1),(32))),
  [InvestigationId] [varchar](16) NULL,
  CONSTRAINT [PK_LabData] PRIMARY KEY CLUSTERED ([ResultId]),
  CONSTRAINT [C_DevInd] CHECK ([DevResult] IS NULL OR [DevResult]>=(0) AND [DevResult]<=(3))
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [I_LabData_LabCode]
  ON [dbo].[LabData] ([LabCodeId])
  ON [PRIMARY]
GO

CREATE INDEX [I_LabData_OrigCode]
  ON [dbo].[LabData] ([OrigCodeId])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_Labdata_Person]
  ON [dbo].[LabData] ([PersonId], [LabDate], [LabCodeId])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_LabData_Delete]
ON [dbo].[LabData]
AFTER DELETE
AS
BEGIN
    INSERT INTO dbo.LabDataDeleted (ResultId, PersonId, LabDate, LabCodeId, OrigCodeId, NumResult, TxtResult, DevResult, RefInterval, Comment, CreatedAt, CreatedBy, SignedAt, SignedBy, ArithmeticComp, BatchId, UnitStr, InvestigationId)
        SELECT ld.ResultId, ld.PersonId, ld.LabDate, ld.LabCodeId, ld.OrigCodeId, ld.NumResult, ld.TxtResult, ld.DevResult, ld.RefInterval, ld.Comment, ld.CreatedAt, ld.CreatedBy, ld.SignedAt, ld.SignedBy, ld.ArithmeticComp, ld.BatchId, ld.UnitStr, ld.InvestigationId
        FROM deleted ld
END
GO

GRANT UPDATE ON [dbo].[LabData] TO [Administrator]
GO

ALTER TABLE [dbo].[LabData]
  ADD CONSTRAINT [FK_LabData_BatchId] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[ImportBatch] ([BatchId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[LabData]
  ADD CONSTRAINT [FK_LabData_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[LabData] WITH NOCHECK
  ADD CONSTRAINT [FK_LabData_DevResult] FOREIGN KEY ([DevResult]) REFERENCES [dbo].[MetaDevResult] ([DevResult])
GO

ALTER TABLE [dbo].[LabData] WITH NOCHECK
  ADD CONSTRAINT [FK_LabData_LabCodeId] FOREIGN KEY ([LabCodeId]) REFERENCES [dbo].[LabCode] ([LabCodeId])
GO

ALTER TABLE [dbo].[LabData] WITH NOCHECK
  ADD CONSTRAINT [FK_LabData_OrigCodeId] FOREIGN KEY ([OrigCodeId]) REFERENCES [dbo].[LabCode] ([LabCodeId])
GO

ALTER TABLE [dbo].[LabData] WITH NOCHECK
  ADD CONSTRAINT [FK_LabData_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [dbo].[LabData]
  ADD CONSTRAINT [FK_LabData_SignedBy] FOREIGN KEY ([SignedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO