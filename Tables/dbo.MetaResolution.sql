CREATE TABLE [dbo].[MetaResolution] (
  [ResId] [tinyint] NOT NULL,
  [ResDesc] [varchar](64) NULL,
  CONSTRAINT [PK_MetaResoluton] PRIMARY KEY CLUSTERED ([ResId])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaResolution] TO [FastTrak]
GO