CREATE TABLE [dbo].[LabCodeGroup] (
  [LabGroupId] [int] NOT NULL,
  [LabCodeId] [int] NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_LabCodeGroup_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_LabCodeGroup_CreatedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_LabCodeGroup] PRIMARY KEY CLUSTERED ([LabGroupId], [LabCodeId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_LabCodeGroup_LabCodeId]
  ON [dbo].[LabCodeGroup] ([LabCodeId])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[LabCodeGroup] TO [FastTrak]
GO

ALTER TABLE [dbo].[LabCodeGroup]
  ADD CONSTRAINT [FK_LabCodeGroup_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[LabCodeGroup]
  ADD CONSTRAINT [FK_LabCodeGroup_LabCodeId] FOREIGN KEY ([LabCodeId]) REFERENCES [dbo].[LabCode] ([LabCodeId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[LabCodeGroup]
  ADD CONSTRAINT [FK_LabCodeGroup_LabGroupId] FOREIGN KEY ([LabGroupId]) REFERENCES [dbo].[LabGroup] ([LabGroupId])
GO