﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMetaRxTypes]
AS 
BEGIN
  SELECT RxType,RxTypeName FROM MetaRxType
END
GO