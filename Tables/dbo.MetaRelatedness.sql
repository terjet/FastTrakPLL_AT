CREATE TABLE [dbo].[MetaRelatedness] (
  [RelId] [tinyint] NOT NULL,
  [RelName] [varchar](32) NULL,
  [RelText] [varchar](max) NOT NULL,
  CONSTRAINT [PK_MetaRelatedness] PRIMARY KEY CLUSTERED ([RelId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO