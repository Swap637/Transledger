if OBJECT_ID('tbl_Ledger') is null
begin
	create table tbl_Ledger
	(
		LedgerId int primary key identity(1,1),
		EntityAccountId int,
		TransactionId varchar(50),
		Amount money,
		TransactionType varchar(50),
		TransactionDate  datetime,
		Remark varchar(500),
		RefId uniqueidentifier,
		EntryDate datetime DEFAULT GETDATE()
	)
end