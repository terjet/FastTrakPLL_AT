CREATE TABLE [FEST].[Interaction] (
  [IntId] [int] NOT NULL,
  [ATC1] [varchar](7) NOT NULL,
  [ATC2] [varchar](7) NOT NULL,
  [LevelId] [tinyint] NOT NULL,
  [InfoText] [varchar](512) NOT NULL,
  [LastUpdate] [datetime] NOT NULL CONSTRAINT [DF_Interaction_LastUpdate] DEFAULT (getdate()),
  CONSTRAINT [PK_KBInteraction] PRIMARY KEY CLUSTERED ([IntId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_KBInteraction_ATC1]
  ON [FEST].[Interaction] ([ATC1])
  ON [PRIMARY]
GO

CREATE INDEX [I_KBInteraction_ATC2]
  ON [FEST].[Interaction] ([ATC2])
  ON [PRIMARY]
GO