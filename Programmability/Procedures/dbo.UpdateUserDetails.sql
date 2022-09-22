SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateUserDetails](
  @UserId INT, @DOB DateTime, 
  @FstName varchar(30), @MidName varchar(30), @LstName varchar(30),  @GenderId INT,
  @NationalId varchar(16), @HPRNo INT )
AS 
BEGIN
  DECLARE @PersonId INT;
  /* See if person exists */
  SELECT @PersonId=PersonId FROM UserList WHERE UserId=@UserId;
  IF @PersonId IS NULL BEGIN
    /* Find a valid person */      
    SELECT @PersonId=PersonId FROM Person WHERE DOB=@Dob AND FstName=@FstName AND LstName=@LstName;
    IF @PersonId IS NULL BEGIN
       /* If there was no match, add this person */
       INSERT INTO Person(DOB,FstName,MidName,LstName,GenderId) VALUES(@DOB,@FstName,@MidName,@LstName,@GenderId);
       SET @PersonId=SCOPE_IDENTITY();
    END;
  END;
  /* Add to userlist if necessary*/
  IF NOT EXISTS( SELECT UserId FROM UserList WHERE UserId=@UserId ) 
    INSERT INTO UserList (UserId,PersonId,UserName) VALUES(@UserId,@PersonId,USER_NAME(@UserId))
  ELSE
    UPDATE UserList SET PersonId=@PersonId WHERE UserId=@UserId;
  /* Update with new information */
  UPDATE Person SET NationalId = NULL, GenderId=NULL WHERE PersonId=@PersonId;
  UPDATE Person SET DOB=@DOB,FstName=@FstName,MidName=@MidName,LstName=@LstName,@GenderId=GenderId,HPRNo=@HPRNo,
    NationalId=@NationalId
    WHERE PersonId=@PersonId;
END
GO