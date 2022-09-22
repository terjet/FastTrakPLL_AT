CREATE TABLE [dbo].[UserRoleInfo] (
  [RoleName] [sysname] NOT NULL,
  [RoleCaption] [varchar](24) NULL,
  [RoleInfo] [varchar](max) NULL,
  [IsActive] [bit] NULL CONSTRAINT [DF_UserRoleInfo_IsActive] DEFAULT (1),
  [SortOrder] [int] NULL,
  [ProfRole] [bit] NULL,
  CONSTRAINT [PK_UserRoleInfo] PRIMARY KEY CLUSTERED ([RoleName])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[UserRoleInfo] TO [FastTrak]
GO