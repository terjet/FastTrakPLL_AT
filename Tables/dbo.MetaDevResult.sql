CREATE TABLE [dbo].[MetaDevResult] (
  [DevResult] [tinyint] NOT NULL,
  [DevText] [varchar](32) NULL,
  [OID9533] [char](1) NULL,
  [OID8244] AS ([DevResult]),
  CONSTRAINT [PK_MetaDevResult] PRIMARY KEY CLUSTERED ([DevResult])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaDevResult] TO [FastTrak]
GO