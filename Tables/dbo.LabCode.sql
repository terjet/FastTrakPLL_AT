CREATE TABLE [dbo].[LabCode] (
  [LabCodeId] [int] IDENTITY,
  [LabName] [varchar](40) NOT NULL,
  [VarName] [varchar](32) NULL,
  [SynonymId] [int] NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_LabCode_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_LabCode_CreatedBy] DEFAULT (user_id()),
  [LabClassId] [int] NULL,
  [UnitStr] [varchar](24) NOT NULL CONSTRAINT [DF_LabCode_UnitStr] DEFAULT (''),
  CONSTRAINT [PK_LabCode] PRIMARY KEY CLUSTERED ([LabCodeId]),
  CONSTRAINT [C_LabCode_SelfReference] CHECK ([SynonymId] IS NULL OR [LabCodeId]<>[SynonymId]),
  CONSTRAINT [C_LabName] CHECK (datalength([LabName])>(1))
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_LabCode_LabName_UnitStr]
  ON [dbo].[LabCode] ([LabName], [UnitStr])
  ON [PRIMARY]
GO

GRANT INSERT ON [dbo].[LabCode] TO [Administrator]
GO

ALTER TABLE [dbo].[LabCode] WITH NOCHECK
  ADD CONSTRAINT [FK_LabCode_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[LabCode]
  ADD CONSTRAINT [FK_LabCode_LabClassId] FOREIGN KEY ([LabClassId]) REFERENCES [dbo].[LabClass] ([LabClassId])
GO

ALTER TABLE [dbo].[LabCode]
  ADD CONSTRAINT [FK_LabCode_SynonymId] FOREIGN KEY ([SynonymId]) REFERENCES [dbo].[LabCode] ([LabCodeId])
GO