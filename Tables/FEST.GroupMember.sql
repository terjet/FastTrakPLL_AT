CREATE TABLE [FEST].[GroupMember] (
  [MembId] [int] NOT NULL,
  [GrpCode] [varchar](7) NOT NULL,
  [GrpMember] [varchar](7) NOT NULL,
  [LastUpdate] [datetime] NOT NULL CONSTRAINT [DF_GroupMember_LastUpdate] DEFAULT (getdate()),
  CONSTRAINT [PK_KBMetaMember] PRIMARY KEY CLUSTERED ([MembId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_KBMetaMember_GrpMember]
  ON [FEST].[GroupMember] ([GrpMember])
  ON [PRIMARY]
GO