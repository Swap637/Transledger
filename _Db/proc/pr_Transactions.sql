IF OBJECT_ID('pr_Transactions') IS NOT NULL
BEGIN
	DROP PROC pr_Transactions
END
GO
CREATE PROC pr_Transactions(  
 @p_DrEntityAccountId     INT,  
 @p_CrEntityAccountId     INT,  
 @p_TransactionAmount     MONEY,  
 @p_Remark                VARCHAR(500),  
 @p_RefId                 UNIQUEIDENTIFIER,  
 @p_TransactionDate       DATETIME,  
 @error                   VARCHAR(MAX) = NULL OUTPUT  
)  
AS  
BEGIN  
BEGIN TRY  
BEGIN TRAN  
   DECLARE @NewTransactionId VARCHAR(50)  
  
  WHILE 1 = 1  
	BEGIN  
		SET @NewTransactionId = 'TXN' +  
			RIGHT(  
				'0000000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(10)),  
				10  
			)  
  
		IF NOT EXISTS(SELECT 1 FROM tbl_Ledger WITH (NOLOCK) WHERE TransactionId = @NewTransactionId)  
		BEGIN
			BREAK;  
		END
	END

 INSERT INTO tbl_Ledger(EntityAccountId, TransactionId, Amount, TransactionType, TransactionDate, Remark, RefId)  
 VALUES(@p_DrEntityAccountId, @NewTransactionId, @p_TransactionAmount, 'DEBIT', GETDATE(), @p_Remark, @p_RefId)  
  
 INSERT INTO tbl_Ledger(EntityAccountId, TransactionId, Amount, TransactionType, TransactionDate, Remark, RefId)  
 VALUES(@p_CrEntityAccountId, @NewTransactionId, @p_TransactionAmount, 'CREDIT', GETDATE(), @p_Remark, @p_RefId)  
  
 UPDATE tbl_EntityAccount  
 SET Balance = ISNULL(Balance, 0) - ISNULL(@p_TransactionAmount, 0)  
 WHERE EntityAccountId = @p_DrEntityAccountId;  
  
 UPDATE tbl_EntityAccount  
 SET Balance = ISNULL(Balance, 0) + ISNULL(@p_TransactionAmount, 0)  
 WHERE EntityAccountId = @p_CrEntityAccountId;  
  
COMMIT TRAN  
END TRY  
BEGIN CATCH  
 ROLLBACK TRAN  
 SET @error = ERROR_MESSAGE()  
END CATCH  
END  
GO
--BEGIN TRAN
--DECLARE @ERROR AS VARCHAR(MAX)
--EXEC pr_Transactions
--@p_DrEntityAccountId = 17,
--@p_CrEntityAccountId = 39,
--@p_TransactionAmount = 6000,
--@p_Remark = 'SDFSDF',
--@p_RefId = 'D510BEFF-2D05-4BAD-B32F-1E18ACA9564B',
--@p_TransactionDate = '2026-07-02',
--@ERROR = @ERROR OUTPUT
--SELECT @ERROR
--select * from tbl_Ledger
--ROLLBACK TRAN


select * from tbl_Ledger
select * from tbl_PaymentDetails
select * from tbl_EntityAccount where EntityAccountId in (11,9,41)
/*
	truncate table tbl_Ledger
	truncate table tbl_transaction
		truncate table tbl_PaymentDetails
*/


