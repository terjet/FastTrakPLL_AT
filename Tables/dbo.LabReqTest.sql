CREATE TABLE [dbo].[LabReqTest] (
  [LabReqId] [int] NOT NULL,
  [LabCodeId] [int] NOT NULL,
  [LabDataId] [int] NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_LabReqTest_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_LabReqTest_CreatedBy] DEFAULT (user_id()),
  [TakenAt] [datetime] NULL,
  [TakenBy] [int] NULL,
  CONSTRAINT [PK_LabReqTest] PRIMARY KEY CLUSTERED ([LabReqId], [LabCodeId])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[LabReqTest]
  ADD CONSTRAINT [FK_LabReqTest_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[LabReqTest]
  ADD CONSTRAINT [FK_LabReqTest_LabCodeId] FOREIGN KEY ([LabCodeId]) REFERENCES [dbo].[LabCode] ([LabCodeId])
GO

ALTER TABLE [dbo].[LabReqTest]
  ADD CONSTRAINT [FK_LabReqTest_LabDataId] FOREIGN KEY ([LabDataId]) REFERENCES [dbo].[LabData] ([ResultId])
GO

ALTER TABLE [dbo].[LabReqTest]
  ADD CONSTRAINT [FK_LabReqTest_LabReqId] FOREIGN KEY ([LabReqId]) REFERENCES [dbo].[LabReq] ([LabReqId])
GO

ALTER TABLE [dbo].[LabReqTest]
  ADD CONSTRAINT [FK_LabReqTest_TakenBy] FOREIGN KEY ([TakenBy]) REFERENCES [dbo].[UserList] ([UserId])
GO