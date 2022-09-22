SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[NationalIdIsValid] (@NationalId VARCHAR(11)) RETURNS INTEGER
AS  
BEGIN  
  DECLARE @pasientid VARCHAR (11);
  DECLARE @d1 integer, @d2 integer, @m1 integer, 
          @m2 integer, @a1 integer, @a2 integer, 
          @i1 integer, @i2 integer, @i3 integer, 
          @k1 integer, @k2 integer;

  SET @pasientid = RIGHT(REPLICATE('0',11) + @NationalId,11)
  SET @d1 = CAST(SUBSTRING(@pasientid,  1, 1) AS INTEGER)
  SET @d2 = CAST(SUBSTRING(@pasientid,  2, 1) AS INTEGER)
  SET @m1 = CAST(SUBSTRING(@pasientid,  3, 1) AS INTEGER)
  SET @m2 = CAST(SUBSTRING(@pasientid,  4, 1) AS INTEGER)
  SET @a1 = CAST(SUBSTRING(@pasientid,  5, 1) AS INTEGER)
  SET @a2 = CAST(SUBSTRING(@pasientid,  6, 1) AS INTEGER)
  SET @i1 = CAST(SUBSTRING(@pasientid,  7, 1) AS INTEGER)
  SET @i2 = CAST(SUBSTRING(@pasientid,  8, 1) AS INTEGER)
  SET @i3 = CAST(SUBSTRING(@pasientid,  9, 1) AS INTEGER)
  SET @k1 = CAST(SUBSTRING(@pasientid, 10, 1) AS INTEGER)
  SET @k2 = CAST(SUBSTRING(@pasientid, 11, 1) AS INTEGER)
  
  IF (((3 * @d1 + 7 * @d2 + 6 * @m1 + 1 * @m2 + 8 * @a1 + 9 * @a2 + 4 * @i1 + 5 * @i2 + 2 * @i3 + 1 * @k1) % 11) != 0) RETURN 0;
  IF (((5 * @d1 + 4 * @d2 + 3 * @m1 + 2 * @m2 + 7 * @a1 + 6 * @a2 + 5 * @i1 + 4 * @i2 + 3 * @i3 + 2 * @k1 + 1 * @k2) % 11) != 0) RETURN 0;
  RETURN 1;
END
GO