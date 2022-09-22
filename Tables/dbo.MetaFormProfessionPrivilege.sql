CREATE TABLE [dbo].[MetaFormProfessionPrivilege] (
  [RowId] [int] NOT NULL,
  [FormId] [int] NOT NULL,
  [ProfType] [varchar](3) NOT NULL,
  [CanCreate] [bit] NOT NULL CONSTRAINT [DF_MetaFormProfessionPrivilege_CanCreate] DEFAULT (1),
  [CanEdit] [bit] NOT NULL CONSTRAINT [DF_MetaFormProfessionPrivilege_CanEdit] DEFAULT (1),
  [CanSign] [bit] NOT NULL CONSTRAINT [DF_MetaFormProfessionPrivilege_CanSign] DEFAULT (1),
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_MetaFormProfessionPrivilege_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_MetaFormProfessionPrivilege_CreatedBy] DEFAULT (user_id()),
  [Comment] [varchar](max) NULL,
  [LastUpdate] [datetime] NOT NULL CONSTRAINT [DF_MetaFormProfessionPrivilege_LastUpdate] DEFAULT (getdate()),
  CONSTRAINT [PK_MetaFormProfessionPrivilege] PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_MetaFormProfessionPrivilege]
  ON [dbo].[MetaFormProfessionPrivilege] ([FormId], [ProfType])
  ON [PRIMARY]
GO

GRANT
  INSERT,
  UPDATE
ON [dbo].[MetaFormProfessionPrivilege] TO [superuser]
GO

ALTER TABLE [dbo].[MetaFormProfessionPrivilege]
  ADD CONSTRAINT [FK_MetaFormProfessionPrivilege_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[MetaFormProfessionPrivilege]
  ADD CONSTRAINT [FK_MetaFormProfessionPrivilege_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO

ALTER TABLE [dbo].[MetaFormProfessionPrivilege]
  ADD CONSTRAINT [FK_MetaFormProfessionPrivilege_ProfType] FOREIGN KEY ([ProfType]) REFERENCES [dbo].[MetaProfession] ([ProfType])
GO