CREATE TABLE [dbo].[LabReq] (
  [LabReqId] [int] IDENTITY,
  [LabReqDate] [datetime] NOT NULL CONSTRAINT [DF_LabReq_LabReqDate] DEFAULT (getdate()),
  [PersonId] [int] NOT NULL,
  [ClinInfo] [varchar](max) NULL,
  [LabReqClosed] [int] NOT NULL CONSTRAINT [DF_LabReq_LabReqClosed] DEFAULT (0),
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_LabReq_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_LabReq_CreatedBy] DEFAULT (user_id()),
  [ClosedAt] [datetime] NULL,
  [ClosedBy] [int] NULL,
  CONSTRAINT [PK_LabReq] PRIMARY KEY CLUSTERED ([LabReqId]),
  CONSTRAINT [C_LabReq_Timing] CHECK ([ClosedAt] IS NULL OR [ClosedAt]>[CreatedAt])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [I_LabReq_Closed]
  ON [dbo].[LabReq] ([LabReqClosed], [CreatedAt])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[LabReq] TO [FastTrak]
GO

ALTER TABLE [dbo].[LabReq]
  ADD CONSTRAINT [FK_LabReq_ClosedBy] FOREIGN KEY ([ClosedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[LabReq]
  ADD CONSTRAINT [FK_LabReq_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[LabReq] WITH NOCHECK
  ADD CONSTRAINT [FK_LabReq_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO