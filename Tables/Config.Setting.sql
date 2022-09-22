CREATE TABLE [Config].[Setting] (
  [SettingId] [int] IDENTITY,
  [UserId] [int] NULL,
  [Section] [varchar](64) NOT NULL,
  [KeyName] [varchar](64) NOT NULL,
  [StringValue] [varchar](max) NULL,
  [DateValue] [datetime] NULL,
  [BitValue] [bit] NULL,
  [IntValue] [int] NULL,
  [DecimalValue] [decimal](15, 5) NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

GRANT
  DELETE,
  INSERT,
  UPDATE
ON [Config].[Setting] TO [Administrator]
GO

ALTER TABLE [Config].[Setting]
  ADD CONSTRAINT [FK_Config_Setting_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserList] ([UserId])
GO