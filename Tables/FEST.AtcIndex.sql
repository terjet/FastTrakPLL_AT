CREATE TABLE [FEST].[AtcIndex] (
  [AtcId] [int] NOT NULL,
  [AtcCode] [varchar](7) NOT NULL,
  [AtcName] [varchar](80) NOT NULL,
  [AtcMaintained] [tinyint] NOT NULL,
  [LastUpdate] [datetime] NOT NULL CONSTRAINT [DF_AtcIndex_LastUpdate] DEFAULT (getdate()),
  CONSTRAINT [PK_KBAtcIndex] PRIMARY KEY CLUSTERED ([AtcId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_KBAtcIndex_AtcCode]
  ON [FEST].[AtcIndex] ([AtcCode])
  ON [PRIMARY]
GO