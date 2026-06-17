if OBJECT_ID('pr_Transactions') is not null
begin
	drop proc pr_Transactions
end
go
create proc pr_Transactions(
	@p_DrEntityAccountId int,
	@p_CrEntityAccountId int,
	@p_TransactionAmount money,
	@p_Remark varchar(500),
	@p_RefId uniqueidentifier,
	@p_TransactionDate datetime
)
as
begin
	declare @NewTransactionId varchar(50)

	while 1 = 1
	begin
		SET @NewTransactionId = 'TXN' +
			RIGHT(
				CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(10))
				+ '0000000000',
				10
			)

		if not exists(select 1 from tbl_Ledger where TransactionId = @NewTransactionId)
			break;
	end

	insert into tbl_Ledger(EntityAccountId, TransactionId, Amount, TransactionType, TransactionDate, Remark, RefId)
	values(@p_DrEntityAccountId, @NewTransactionId, @p_TransactionAmount, 'DEBIT', @p_TransactionDate, @p_Remark, @p_RefId)

	insert into tbl_Ledger(EntityAccountId, TransactionId, Amount, TransactionType, TransactionDate, Remark, RefId)
	values(@p_CrEntityAccountId, @NewTransactionId, @p_TransactionAmount, 'CREDIT', @p_TransactionDate, @p_Remark, @p_RefId)

	update tbl_EntityAccount
	set Balance = isnull(Balance, 0) - isnull(@p_TransactionAmount, 0)
	where EntityAccountId = @p_DrEntityAccountId;

	update tbl_EntityAccount
	set Balance = isnull(Balance, 0) + isnull(@p_TransactionAmount, 0)
	where EntityAccountId = @p_CrEntityAccountId;
end