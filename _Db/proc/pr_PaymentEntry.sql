IF OBJECT_ID('pr_PaymentEntry') IS NOT NULL
BEGIN
	DROP PROC pr_PaymentEntry
END
GO
CREATE PROC pr_PaymentEntry(
	@p_Action          VARCHAR(50)  = 'GET-LEDGER',
	@P_TripEntryId     INT          = NULL,
	@P_CreditedFrom    VARCHAR(50)  = NULL,
	@P_CreditedTo      VARCHAR(50)  = NULL,
	@P_OthrPymntMeth   VARCHAR(50)  = NULL,
	@p_PaymentType     VARCHAR(50)  = NULL,
	@p_EntityAccountId INT          = NULL,
	@p_Amount          MONEY        = NULL,
	@p_PaymentDate     DATETIME     = NULL,
	@p_ModeOfPayment   VARCHAR(25)  = NULL,
	@p_ReferenceNumber VARCHAR(25)  = NULL,
	@p_Remarks         VARCHAR(500) = NULL
)
AS
BEGIN
	DECLARE @RefId UNIQUEIDENTIFIER, @DrAccountId INT, @CrAccountId  INT

	IF @p_Action = 'MAKE-TRANSACTION'
	BEGIN
		SELECT @RefId = NEWID();	

		BEGIN TRY
			BEGIN TRAN
				IF @p_PaymentType = 'PAYMENT'
				BEGIN
					SELECT @DrAccountId = @p_EntityAccountId;

					IF @p_ModeOfPayment in ('UPI', 'TRANSFER', 'CHEQUE', 'OTHER')
					BEGIN
						SELECT @CrAccountId = EntityAccountId FROM tbl_EntityAccount
						WHERE EntityAccountType = 'ACCOUNT'
						AND AccountType =  'BANK-ACCOUNT'
					END
					ELSE
					BEGIN
						SELECT @CrAccountId = EntityAccountId FROM tbl_EntityAccount
						WHERE EntityAccountType = 'ACCOUNT'
						AND AccountType =  'CASH-IN-HAND'
					END
				END
				ELSE
				BEGIN
					SELECT @CrAccountId = @p_EntityAccountId;

					IF @p_ModeOfPayment in ('UPI', 'TRANSFER', 'CHEQUE', 'OTHER')
					BEGIN
						SELECT @DrAccountId = EntityAccountId FROM tbl_EntityAccount
						WHERE EntityAccountType = 'ACCOUNT'
						AND AccountType =  'BANK-ACCOUNT'
					END
					ELSE
					BEGIN
						SELECT @DrAccountId = EntityAccountId FROM tbl_EntityAccount
						WHERE EntityAccountType = 'ACCOUNT'
						AND AccountType =  'CASH-IN-HAND'
					END
				END


				INSERT INTO tbl_PaymentDetails(TripEntryId,Amount,CreditedFrom,CreditedTo, PaymentDate, ModeOfPayment,OthrPymntMeth, UTRTranRefNumber, Remarks, RefId)
				VALUES(@P_TripEntryId,  @p_Amount,@P_CreditedFrom,@P_CreditedTo, @p_PaymentDate, @p_ModeOfPayment,@P_OthrPymntMeth,@p_ReferenceNumber, @p_Remarks, @RefId)

				EXEC pr_Transactions
					@p_DrEntityAccountId = @DrAccountId,
					@p_CrEntityAccountId = @CrAccountId,
					@p_TransactionAmount = @p_Amount,
					@p_Remark = @p_Remarks,
					@p_RefId = @RefId,
					@p_TransactionDate = @p_PaymentDate
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK TRAN;

			THROW;
		END CATCH
	END

	ELSE IF @p_Action = 'GET-LEDGER'
	BEGIN
		SELECT l.TransactionDate, ISNULL(ea.Name, ea.VehicleNumber) EntityAccount, l.Remark, pd.ReferenceNumber,
		CASE l.TransactionType WHEN 'DEBIT' then l.Amount ELSE NULL END AS Debit,
		CASE l.TransactionType WHEN 'CREDIT' then l.Amount ELSE NULL END AS Credit
		FROM tbl_Ledger l WITH (NOLOCK)
		INNER JOIN tbl_PaymentDetails pd WITH (NOLOCK) on pd.RefId = l.RefId
		INNER JOIN tbl_EntityAccount ea WITH (NOLOCK) on ea.EntityAccountId = l.EntityAccountId
	END

	ELSE IF @p_Action ='GET-TRIPNUMBER'
	BEGIN 
	  SELECT TripId,TripNumber
      FROM b_TripEntry 
	  WHERE ISNULL(TRIPSTATUS,0)  = 0
	END
END
GO
