CREATE TABLE [FEST].[PIA] (
  [PackId] [int] NOT NULL,
  [ATC] [varchar](7) NULL,
  [DrugName] [varchar](128) NULL,
  [DrugForm] [varchar](64) NULL,
  [DrugGroup] [varchar](1) NULL,
  [Strength] [decimal](18, 4) NULL,
  [StrengthUnit] [varchar](24) NULL,
  [SubstanceName] [varchar](128) NULL,
  [PackSize] [decimal](18, 4) NULL,
  [PackSizeUnit] [varchar](10) NULL,
  [PackQuantity] [varchar](3) NULL,
  [PackName] [varchar](64) NULL,
  [PackInfo] [varchar](40) NULL,
  [Refundable] [varchar](1) NULL,
  [DrugNameFormStrength] [varchar](128) NULL,
  [DoseUnit] [varchar](24) NULL,
  [LastUpdate] [datetime] NOT NULL CONSTRAINT [DF_PIA_LastUpdate] DEFAULT ('2000-01-01'),
  CONSTRAINT [PK_PIA] PRIMARY KEY CLUSTERED ([PackId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_PIA_ATC]
  ON [FEST].[PIA] ([ATC])
  ON [PRIMARY]
GO

CREATE INDEX [I_PIA_DrugName]
  ON [FEST].[PIA] ([DrugName])
  ON [PRIMARY]
GO