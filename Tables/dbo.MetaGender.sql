CREATE TABLE [dbo].[MetaGender] (
  [GenderId] [tinyint] NOT NULL,
  [GenderName] [varchar](16) NOT NULL,
  CONSTRAINT [PK_MetaGender] PRIMARY KEY CLUSTERED ([GenderId])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaGender] TO [FastTrak]
GO