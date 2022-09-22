CREATE TABLE [dbo].[KBDrugToProblem] (
  [DrugProbId] [int] NOT NULL,
  [ATC] [varchar](7) NOT NULL,
  [ItemCode] [varchar](8) NOT NULL,
  [ProbDesc] [varchar](32) NULL,
  [ListName] [varchar](32) NULL,
  [DxSystem] [int] NULL,
  [ChkSum] [int] NOT NULL CONSTRAINT [DF_KBDrugToProblem_ChkSum] DEFAULT (0),
  CONSTRAINT [PK_KBDrugToProblem] PRIMARY KEY CLUSTERED ([DrugProbId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_KBDrugToProblem_ATCListName]
  ON [dbo].[KBDrugToProblem] ([ATC], [ListName])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[KBDrugToProblem] TO [FastTrak]
GO