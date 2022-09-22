CREATE TABLE [Comm].[OutBox] (
  [OutId] [int] IDENTITY,
  [PartnerId] [int] NOT NULL,
  [PersonId] [int] NULL,
  [MessageText] [varchar](max) NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_OutBox_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_OutBox_CreatedBy] DEFAULT (user_id()),
  [PulledAt] [datetime] NULL,
  [PulledBy] [int] NULL,
  [MsgGuid] [uniqueidentifier] NULL,
  [ClinFormId] [int] NULL,
  [StatusCode] [int] NULL,
  [StatusMessage] [varchar](max) NULL,
  [SrvReportStatus] [char](1) NULL,
  [AppRecMessage] [nvarchar](max) NULL,
  CONSTRAINT [PK_OutBox] PRIMARY KEY CLUSTERED ([OutId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

GRANT SELECT ON [Comm].[OutBox] TO [FastTrak]
GO

ALTER TABLE [Comm].[OutBox]
  ADD CONSTRAINT [FK_Comm_OutBox_ClinFormId] FOREIGN KEY ([ClinFormId]) REFERENCES [dbo].[ClinForm] ([ClinFormId])
GO

ALTER TABLE [Comm].[OutBox]
  ADD CONSTRAINT [FK_Comm_OutBox_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [Comm].[OutBox]
  ADD CONSTRAINT [FK_Comm_OutBox_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [Comm].[OutBox]
  ADD CONSTRAINT [FK_Comm_OutBox_PulledBy] FOREIGN KEY ([PulledBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [Comm].[OutBox]
  ADD CONSTRAINT [FK_Comm_OutBox_StatusCode] FOREIGN KEY ([StatusCode]) REFERENCES [Comm].[MetaStatusCode] ([StatusCode])
GO