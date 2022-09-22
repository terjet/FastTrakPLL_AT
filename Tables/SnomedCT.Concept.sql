CREATE TABLE [SnomedCT].[Concept] (
  [SCTID] [bigint] NOT NULL,
  [Term] [varchar](160) NOT NULL,
  [NorwegianTerm] [varchar](160) NULL,
  CONSTRAINT [PK_SnomedCT_Concept] PRIMARY KEY CLUSTERED ([SCTID])
)
ON [PRIMARY]
GO