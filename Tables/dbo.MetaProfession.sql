CREATE TABLE [dbo].[MetaProfession] (
  [ProfId] [int] IDENTITY,
  [ProfName] [varchar](32) NOT NULL,
  [OID9060] [varchar](3) NULL,
  [ProfLevel] [int] NULL CONSTRAINT [DF_MetaProfession_ProfLevel] DEFAULT (0),
  [ProfDescription] [varchar](max) NULL,
  [ProfType] [varchar](3) NOT NULL,
  [DisabledAt] [datetime] NULL,
  [DisabledBy] [int] NULL,
  CONSTRAINT [PK_MetaProfession] PRIMARY KEY CLUSTERED ([ProfId]),
  CONSTRAINT [UC_MetaProfession_ProfType] UNIQUE ([ProfType])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_MetaProfession_ProfName]
  ON [dbo].[MetaProfession] ([ProfName])
  ON [PRIMARY]
GO

GRANT INSERT ON [dbo].[MetaProfession] TO [Administrator]
GO

ALTER TABLE [dbo].[MetaProfession]
  ADD CONSTRAINT [FK_MetaProfession_DisabledBy] FOREIGN KEY ([DisabledBy]) REFERENCES [dbo].[UserList] ([UserId])
GO