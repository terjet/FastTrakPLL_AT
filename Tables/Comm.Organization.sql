CREATE TABLE [Comm].[Organization] (
  [OrgId] [int] NOT NULL,
  [OrgName] [varchar](64) NOT NULL,
  [OrgAddress] [varchar](32) NULL,
  [OrgPostCode] [varchar](5) NULL,
  [OrgCity] [varchar](32) NULL,
  [HERId] [int] NULL,
  [Email] [varchar](64) NULL,
  [LastUpdate] [datetime] NULL,
  CONSTRAINT [PK_Organization] PRIMARY KEY CLUSTERED ([OrgId])
)
ON [PRIMARY]
GO