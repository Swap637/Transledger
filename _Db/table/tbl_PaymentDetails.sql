if OBJECT_ID('tbl_PaymentDetails') is null
begin
	create table tbl_PaymentDetails
	(
		PaymentDetailsId int primary key identity(1,1),
		PaymentType varchar(50),
		EntityAccountId int,
		Amount money,
		PaymentDate  datetime,
		ModeOfPayment varchar(25),
		ReferenceNumber varchar(25),
		Remarks varchar(500),
		RefId uniqueidentifier
	)
end