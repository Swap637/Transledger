if OBJECT_ID('tbl_EntityAccount') is null
begin
	create table tbl_EntityAccount
	(
		EntityAccountId int primary key identity(1,1),
		EntityAccountType varchar(100),
		Name varchar(200),
		GSTIN varchar(25),
		PAN varchar(25),
		AadharNumber varchar(25),
		ContactName varchar(200),
		ContactNo varchar(50),
		AlternateContactNo varchar(50),
		Email varchar(100),
		RegistrationType varchar(50),
		CommissionPercent float,
		LicenseNumber varchar(100),
		LicenseExpiry datetime,
		VehicleNumber varchar(25),
		VehicleType varchar(25),
		CapacityInTons float,
		PermitType varchar(25),
		PermitNumber varchar(25),
		PermitExpiryDate datetime,
		InsurancePolicyNumber varchar(25),
		InsuranceExpiryDate datetime,
		OwnerName varchar(200),
		AccountType varchar(50),
		OpeningBalance money,
		OpeningBalanceType bit, -- 0 for debit, 1 for credit
		Address varchar(500),
		DocumentId int,
		RegisteredOn datetime DEFAULT GETDATE(),
		Balance money
	)
end

if not exists(
	select null from tbl_EntityAccount
	where EntityAccountType = 'ACCOUNT'
	and AccountType =  'CASH-IN-HAND'
)
begin
	insert into tbl_EntityAccount(EntityAccountType, Name, AccountType, OpeningBalance, OpeningBalanceType, Balance)
	values('ACCOUNT', 'Cash', 'CASH-IN-HAND', null, null, 0)
end

if not exists(
	select null from tbl_EntityAccount
	where EntityAccountType = 'ACCOUNT'
	and AccountType =  'BANK-ACCOUNT'
)
begin
	insert into tbl_EntityAccount(EntityAccountType, Name, AccountType, OpeningBalance, OpeningBalanceType, Balance)
	values('ACCOUNT', 'Bank Account', 'BANK-ACCOUNT', null, null, 0)
end


