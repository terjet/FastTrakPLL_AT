SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddRx]( @TreatId INT, @CodeId INT, @PackName VARCHAR(64),@PackSize FLOAT,@PackSizeUnit VARCHAR(24), @PackCount INT,@Refills INT,@RxText TEXT,@RxType INT, @RxPrint INT )
AS BEGIN 
  IF @CodeId=0 SET @CodeId=NULL;
  INSERT INTO DrugPrescription(TreatId,CodeId,PackName,PackSize,PackSizeUnit,PackCount,Refills,RxText,RxType,RxPrint )
  VALUES (@TreatId,@CodeId,@PackName,@PackSize,@PackSizeUnit,@PackCount,@Refills,@RxText,@RxType,@RxPrint );
  SELECT SCOPE_IDENTITY() AS PrescId;
END;

GRANT EXECUTE ON dbo.AddRx TO public
GO

GRANT EXECUTE ON [dbo].[AddRx] TO [FastTrak]
GO