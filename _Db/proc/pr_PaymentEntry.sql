if OBJECT_ID('pr_PaymentEntry') is not null
begin
	drop proc pr_PaymentEntry
end
go
create proc pr_PaymentEntry(
	@p_Action varchar(50),
	@p_PaymentType varchar(50) = null,
	@p_EntityAccountId int = null,
	@p_Amount money = null,
	@p_PaymentDate  datetime = null,
	@p_ModeOfPayment varchar(25) = null,
	@p_ReferenceNumber varchar(25) = null,
	@p_Remarks varchar(500) = null
)
as
begin
	declare @RefId uniqueidentifier, @DrAccountId int, @CrAccountId  int

	if @p_Action = 'MAKE-TRANSACTION'
	begin
		select @RefId = NEWID();	

		begin try
			begin tran
				if @p_PaymentType = 'PAYMENT'
				begin
					select @DrAccountId = @p_EntityAccountId;

					if @p_ModeOfPayment in ('UPI', 'TRANSFER', 'CHEQUE', 'OTHER')
					begin
						select @CrAccountId = EntityAccountId from tbl_EntityAccount
						where EntityAccountType = 'ACCOUNT'
						and AccountType =  'BANK-ACCOUNT'
					end
					else
					begin
						select @CrAccountId = EntityAccountId from tbl_EntityAccount
						where EntityAccountType = 'ACCOUNT'
						and AccountType =  'CASH-IN-HAND'
					end
				end
				else
				begin
					select @CrAccountId = @p_EntityAccountId;

					if @p_ModeOfPayment in ('UPI', 'TRANSFER', 'CHEQUE', 'OTHER')
					begin
						select @DrAccountId = EntityAccountId from tbl_EntityAccount
						where EntityAccountType = 'ACCOUNT'
						and AccountType =  'BANK-ACCOUNT'
					end
					else
					begin
						select @DrAccountId = EntityAccountId from tbl_EntityAccount
						where EntityAccountType = 'ACCOUNT'
						and AccountType =  'CASH-IN-HAND'
					end
				end

				insert into tbl_PaymentDetails(PaymentType, EntityAccountId, Amount, PaymentDate, ModeOfPayment, ReferenceNumber, Remarks, RefId)
				values(@p_PaymentType, @p_EntityAccountId, @p_Amount, @p_PaymentDate, @p_ModeOfPayment, @p_ReferenceNumber, @p_Remarks, @RefId)

				exec pr_Transactions
					@p_DrEntityAccountId = @DrAccountId,
					@p_CrEntityAccountId = @CrAccountId,
					@p_TransactionAmount = @p_Amount,
					@p_Remark = @p_Remarks,
					@p_RefId = @RefId,
					@p_TransactionDate = @p_PaymentDate
			commit tran
		end try
		begin catch
			if @@TRANCOUNT > 0
				rollback tran;

			throw;
		end catch
	end

	else if @p_Action = 'GET-LEDGER'
	begin
		select l.TransactionDate, isnull(ea.Name, ea.VehicleNumber) EntityAccount, l.Remark, pd.ReferenceNumber,
		case l.TransactionType when 'DEBIT' then l.Amount else null end as Debit,
		case l.TransactionType when 'CREDIT' then l.Amount else null end as Credit
		from tbl_Ledger l with (nolock)
		inner join tbl_PaymentDetails pd with (nolock) on pd.RefId = l.RefId
		inner join tbl_EntityAccount ea with (nolock) on ea.EntityAccountId = l.EntityAccountId
	end
end