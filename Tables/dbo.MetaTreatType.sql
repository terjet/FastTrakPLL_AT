﻿CREATE TABLE [dbo].[MetaTreatType] (
  [TreatType] [char](1) NOT NULL,
  [TreatDesc] [varchar](16) NULL,
  [SortOrder] [int] NOT NULL,
  CONSTRAINT [PK_MetaTreatType] PRIMARY KEY CLUSTERED ([TreatType])
)
ON [PRIMARY]
GO

GRANT UPDATE ON [dbo].[MetaTreatType] TO [Administrator]
GO

GRANT SELECT ON [dbo].[MetaTreatType] TO [FastTrak]
GO