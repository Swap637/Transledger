IF OBJECT_ID('pr_EntityAccount') IS NOT NULL
BEGIN
	DROP PROC pr_EntityAccount
END
GO
CREATE  PROC pr_EntityAccount(    
 @p_Action varchar(25),    
 @p_EntityAccountId int = null,    
 @p_EntityAccountType varchar(100) = null,    
 @p_Name varchar(200) = null,    
 @p_GSTIN varchar(25) = null,    
 @p_PAN varchar(25) = null,    
 @p_AadharNumber varchar(25) = null,  
 @p_ContactName varchar(200) = null,    
 @p_ContactNo varchar(50) = null,   
 @p_AlterNativeMobileNo varchar(50) = null,   
 @p_Email varchar(100) = null,    
 @p_RegistrationType varchar(50) = null,    
 @p_CommissionPercent float = null,    
 @p_LicenseNumber varchar(100) = null,    
 @p_LicenseExpiry datetime = null,    
 @p_VehicleNumber varchar(25) = null,    
 @p_VehicleType varchar(25) = null,    
 @p_CapacityInTons float = null,    
 @p_PermitType varchar(25) = null,    
 @p_PermitNumber varchar(25) = null,    
 @p_PermitExpiryDate datetime = null,    
 @p_InsurancePolicyNumber varchar(25) = null,    
 @p_InsuranceExpiryDate datetime = null,    
 @p_OwnerName varchar(200) = null,    
 @p_AccountType varchar(50) = null,    
 @p_OpeningBalance money = null,    
 @p_OpeningBalanceType bit = null,    
 @p_Address varchar(500) = null    
)    
as    
begin    
 declare @DocumentId int, @Balance money    
    
 if @p_Action = 'CREATE'    
 begin    
  if @p_EntityAccountType = 'COMPANY'    
  begin    
   insert into tbl_EntityAccount(EntityAccountType, Name, GSTIN, ContactName,AlternateContactNo, ContactNo, Email, RegistrationType, Address)    
   values(@p_EntityAccountType, @p_Name, @p_GSTIN,@p_ContactName,@p_AlterNativeMobileNo,@p_ContactNo, @p_Email, @p_RegistrationType, @p_Address)    
  end    
  else if @p_EntityAccountType = 'PARTY'    
  begin    
   insert into tbl_EntityAccount(EntityAccountType, Name, GSTIN,ContactName,AlternateContactNo, ContactNo, Email, Address)    
   values(@p_EntityAccountType, @p_Name, @p_GSTIN,@p_ContactName,@p_AlterNativeMobileNo,@p_ContactNo, @p_Email, @p_Address)    
  end    
  else if @p_EntityAccountType = 'BROKER'    
  begin    
   insert into tbl_EntityAccount(EntityAccountType, Name,AadharNumber, PAN,ContactName, ContactNo,AlternateContactNo, CommissionPercent, Address)    
   values(@p_EntityAccountType, @p_Name, @p_AadharNumber, @p_PAN,@p_ContactName,@p_ContactNo,@p_AlterNativeMobileNo, @p_CommissionPercent, @p_Address)    
  end    
  else if @p_EntityAccountType = 'DRIVER'    
  begin    
   insert into tbl_EntityAccount(EntityAccountType, Name, LicenseNumber,  AadharNumber, ContactNo,AlternateContactNo,  Address)    
   values(@p_EntityAccountType, @p_Name, @p_LicenseNumber,  @p_AadharNumber, @p_ContactNo,@p_AlterNativeMobileNo, @p_Address)    
  end    
  else if @p_EntityAccountType = 'VEHICLE'    
  begin    
   insert into tbl_EntityAccount(    
       -- Vehicle Details    
       EntityAccountType, VehicleNumber, VehicleType, CapacityInTons, PermitType, PermitNumber, PermitExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate,    
    
       -- Owner Information / Other    
       OwnerName, AadharNumber, PAN, Address, DocumentId    
      )    
    values  (    
       -- Vehicle Details    
       @p_EntityAccountType, @p_VehicleNumber, @p_VehicleType, @p_CapacityInTons, @p_PermitType, @p_PermitNumber, @p_PermitExpiryDate, @p_InsurancePolicyNumber, @p_InsuranceExpiryDate,    
    
       -- Owner Information / Other    
       @p_OwnerName, @p_AadharNumber, @p_PAN, @p_Address, @DocumentId    
      )    
  end    
  else if @p_EntityAccountType = 'ACCOUNT'    
  begin    
   if isnull(@p_OpeningBalance, 0) <= 0    
   begin    
    set @p_OpeningBalance = null    
    set @p_OpeningBalanceType = null    
   end    
   else    
   begin    
    if isnull(@p_OpeningBalanceType, 0) = 0    
     SET @Balance = -@p_OpeningBalance    
    else    
     SET @Balance = @p_OpeningBalance    
   end    
    
   insert into tbl_EntityAccount(EntityAccountType, Name, AccountType, OpeningBalance, OpeningBalanceType, Balance)    
   values(@p_EntityAccountType, @p_Name, @p_AccountType, @p_OpeningBalance, @p_OpeningBalanceType, @Balance)    
  end    
 end    
    
 if @p_Action = 'GET-LIST'    
 begin    
  if @p_EntityAccountType = 'COMPANY'    
  begin    
   select EntityAccountId, EntityAccountType, Name, GSTIN, PAN, ContactNo, Email, RegistrationType, Address, RegisteredOn    
   from tbl_EntityAccount    
   where EntityAccountType = @p_EntityAccountType    
  end    
  else if @p_EntityAccountType = 'PARTY'    
  begin    
   select EntityAccountId, EntityAccountType, Name, GSTIN, PAN, ContactNo, Email, Address, RegisteredOn    
   from tbl_EntityAccount    
   where EntityAccountType = @p_EntityAccountType    
  end    
  else if @p_EntityAccountType = 'BROKER'    
  begin    
   select EntityAccountId, EntityAccountType, Name, GSTIN, PAN, ContactNo, Email, CommissionPercent, Address, RegisteredOn    
   from tbl_EntityAccount    
   where EntityAccountType = @p_EntityAccountType    
  end    
  else if @p_EntityAccountType = 'DRIVER'    
  begin    
   select EntityAccountId, EntityAccountType, Name, LicenseNumber, LicenseExpiry, PAN, ContactNo, Email, Address, RegisteredOn    
   from tbl_EntityAccount    
   where EntityAccountType = @p_EntityAccountType    
  end    
  else if @p_EntityAccountType = 'VEHICLE'    
  begin    
   select EntityAccountId, EntityAccountType, VehicleNumber, VehicleType, CapacityInTons, PermitType, PermitNumber, PermitExpiryDate,    
   InsurancePolicyNumber, InsuranceExpiryDate, OwnerName, AadharNumber, PAN, Address, DocumentId, RegisteredOn    
   from tbl_EntityAccount    
   where EntityAccountType = @p_EntityAccountType    
  end    
  else if @p_EntityAccountType = 'ACCOUNT'    
  begin    
   select EntityAccountId, EntityAccountType, Name, AccountType, OpeningBalance,    
       case OpeningBalanceType    
       when 1 then 'Cr'    
       when 0 then 'Dr'    
       else '' end as OpeningBalanceType, RegisteredOn    
   from tbl_EntityAccount    
   where EntityAccountType = @p_EntityAccountType    
  end    
 end    
end