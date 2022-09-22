CREATE TABLE [dbo].[MetaAlertFacet] (
  [FacetName] [varchar](16) NOT NULL,
  [FacetDesc] [varchar](64) NOT NULL,
  CONSTRAINT [PK_MetaAlertFacet] PRIMARY KEY CLUSTERED ([FacetName])
)
ON [PRIMARY]
GO