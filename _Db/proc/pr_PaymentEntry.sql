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
	@p_Remarks         VARCHAR(500) = NULL,
	@ERROR             VARCHAR(500) = NULL OUTPUT
)
AS
BEGIN
	DECLARE @RefId UNIQUEIDENTIFIER, @DrAccountId INT, @CrAccountId  INT

	IF @p_Action = 'MAKE-TRANSACTION'
	BEGIN
		SELECT @RefId = NEWID();	
		
		BEGIN TRY
			BEGIN TRAN

				IF @p_PaymentType = 'CASHOUT'
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
						SELECT @DrAccountId = EntityAccountId 
						FROM tbl_EntityAccount WITH (NOLOCK)
						WHERE EntityAccountType = 'ACCOUNT'
						AND AccountType =  'BANK-ACCOUNT'
					END
					ELSE
					BEGIN
						SELECT @DrAccountId = EntityAccountId FROM tbl_EntityAccount WITH (NOLOCK)
						WHERE EntityAccountType = 'ACCOUNT'
						AND AccountType =  'CASH-IN-HAND'
					END
				END
				SELECT  * FROM tbl_EntityAccount
						WHERE EntityAccountType = 'ACCOUNT'
						AND AccountType =  'BANK-ACCOUNT'

				INSERT INTO tbl_PaymentDetails(TripEntryId,Amount,CreditedFrom,CreditedTo, PaymentDate, ModeOfPayment,OthrPymntMeth, UTRTranRefNumber, Remarks, RefId,CreatedOn)
				VALUES(@P_TripEntryId,  @p_Amount,@P_CreditedFrom,@P_CreditedTo, @p_PaymentDate, @p_ModeOfPayment,@P_OthrPymntMeth,@p_ReferenceNumber, @p_Remarks, @RefId,GETDATE())
			SELECT @DrAccountId,@CrAccountId
				IF ISNULL(@DrAccountId,0) <> 0 AND ISNULL(@CrAccountId,0) <> 0 AND ISNULL(@p_Amount,0) > 0
				BEGIN 
					  EXEC pr_Transactions
						@p_DrEntityAccountId = @DrAccountId,
						@p_CrEntityAccountId = @CrAccountId,
						@p_TransactionAmount = @p_Amount,
						@p_Remark = @p_Remarks,
						@p_RefId = @RefId,
						@p_TransactionDate = @p_PaymentDate,
						@ERROR = @ERROR OUTPUT

						IF ISNULL(@ERROR, '') <> '' 
						BEGIN 
							RAISERROR(@ERROR, 16, 1); 
						END
				END
				ELSE
				BEGIN 
					RAISERROR('DATA SHOULD BE AVAILABALE FOR TRANSACTION.', 16, 1); 
				END

			COMMIT TRAN
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				SET @ERROR = ERROR_MESSAGE()
				ROLLBACK TRAN;
			THROW
		END CATCH
	END

	ELSE IF @p_Action = 'GET-LEDGER'
	BEGIN
		SELECT l.TransactionDate, ISNULL(ea.Name, ea.VehicleNumber) EntityAccount, l.Remark, pd.UTRTranRefNumber,
		CASE l.TransactionType WHEN 'DEBIT' then l.Amount ELSE NULL END AS Debit,
		CASE l.TransactionType WHEN 'CREDIT' then l.Amount ELSE NULL END AS Credit
		FROM tbl_Ledger l WITH (NOLOCK)
		INNER JOIN tbl_PaymentDetails pd WITH (NOLOCK) on pd.RefId = l.RefId
		INNER JOIN tbl_EntityAccount ea WITH (NOLOCK) on ea.EntityAccountId = l.EntityAccountId
	END

	ELSE IF @p_Action ='GET-TRIPNUMBER'
	BEGIN 
	  SELECT TripId,TripNumber,ISNULL(AmtForBkingPrty,0) Amount ,Name
      FROM b_TripEntry B WITH (NOLOCK)
	  INNER JOIN tbl_EntityAccount P WITH (NOLOCK) ON P.EntityAccountId = B.BookingPartyId
	  WHERE ISNULL(TRIPSTATUS,0)  = 0

	  SELECT EntityAccountId,ISNULL(AccountNumber,'') AccountNumber,Name
	  FROM tbl_EntityAccount WITH (NOLOCK)
	  WHERE ISNULL(EntityAccountType,'') = 'ACCOUNT'
	  

		SELECT Name,EntityAccountId FROM tbl_EntityAccount WHERE EntityAccountType = 'PARTY'
		UNION ALL -- BROKER
		SELECT Name,EntityAccountId FROM tbl_EntityAccount WHERE EntityAccountType = 'BROKER'
		UNION ALL -- COMPNAY
		SELECT Name,EntityAccountId FROM tbl_EntityAccount WHERE EntityAccountType = 'COMPANY'
		UNION ALL -- VEHICLE
		SELECT VehicleNumber,EntityAccountId FROM tbl_EntityAccount WHERE EntityAccountType = 'VEHICLE'
	 
	END
END
GO
BEGIN TRAN
DECLARE @ERROR AS VARCHAR(500)
EXEC pr_PaymentEntry
@p_Action= 'MAKE-TRANSACTION',
@p_PaymentType= 'CASHIN',
@P_TripEntryId= 4,
@p_ModeOfPayment = 'UPI',
@p_Amount= 54654.00,
@p_PaymentDate= '30-07-2026 00:00:00',
@p_ReferenceNumber= 'SDFSD',
@P_OthrPymntMethB= NULL,
@p_Remarks= 'EDSDS',
@p_EntityAccountId = 41,
@p_CreditedTo=  41,
@ERROR = @ERROR OUTPUT
SELECT @ERROR
--SELECT * FROM tbl_PaymentDetails ORDER BY CREATEDON DESC
ROLLBACK TRAN

