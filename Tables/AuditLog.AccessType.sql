CREATE TABLE [AuditLog].[AccessType] (
  [AccessTypeId] [int] NOT NULL,
  [AccessTypeText] [varchar](64) NULL,
  CONSTRAINT [PK_AuditLog_AccessType] PRIMARY KEY CLUSTERED ([AccessTypeId])
)
ON [PRIMARY]
GO