CREATE TABLE [dbo].[MetaProblemType] (
  [ProbType] [char](1) NOT NULL,
  [ProbDesc] [varchar](32) NOT NULL,
  [ProbLifecycle] [tinyint] NOT NULL,
  [ProbActive] AS ((1)-abs(sign([ProbLifecycle]-(1)))),
  CONSTRAINT [PK_MetaProblemType] PRIMARY KEY CLUSTERED ([ProbType]),
  CONSTRAINT [C_MetaProblemType_Lifecycle] CHECK ([ProbLifecycle]>=(0) AND [ProbLifecycle]<=(2))
)
ON [PRIMARY]
GO