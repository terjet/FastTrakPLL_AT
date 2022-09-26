CREATE TABLE [dbo].[LabGroup] (
  [LabGroupId] [int] IDENTITY,
  [LabGroupName] [varchar](40) NOT NULL,
  [SortOrder] [int] NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_LabGroup_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_LabGroup_CreatedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_LabGroup] PRIMARY KEY CLUSTERED ([LabGroupId]),
  CONSTRAINT [C_LabGroupName] CHECK (datalength([LabGroupName])>(2))
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_LabGroup_LabGroupName]
  ON [dbo].[LabGroup] ([LabGroupName])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[LabGroup] TO [FastTrak]
GO

ALTER TABLE [dbo].[LabGroup]
  ADD CONSTRAINT [FK_LabGroup_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO