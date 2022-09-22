CREATE TABLE [dbo].[MetaPackType] (
  [PackType] [char](1) NOT NULL,
  [PackDesc] [varchar](16) NULL,
  [SortOrder] [tinyint] NULL,
  [OID9135] [tinyint] NOT NULL,
  [Active] [tinyint] NULL,
  CONSTRAINT [PK_MetaPackType] PRIMARY KEY CLUSTERED ([PackType])
)
ON [PRIMARY]
GO