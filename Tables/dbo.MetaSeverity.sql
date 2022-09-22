CREATE TABLE [dbo].[MetaSeverity] (
  [SevId] [tinyint] NOT NULL,
  [SevName] [varchar](32) NULL,
  [SevText] [varchar](max) NOT NULL,
  CONSTRAINT [PK_MetaSeverity] PRIMARY KEY CLUSTERED ([SevId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaSeverity] TO [FastTrak]
GO