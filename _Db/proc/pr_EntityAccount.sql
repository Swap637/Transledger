IF OBJECT_ID('pr_EntityAccount') IS NOT NULL
BEGIN
	DROP PROC pr_EntityAccount
END
GO
CREATE  PROC pr_EntityAccount(    
 @p_Action                VARCHAR(25),    
 @p_EntityAccountId       INT = null,    
 @p_EntityAccountType     VARCHAR(100) = null,    
 @p_Name                  VARCHAR(200) = null,    
 @p_GSTIN                 VARCHAR(25) = null,    
 @p_PAN                   VARCHAR(25) = null,    
 @p_AadharNumber          VARCHAR(25) = null,  
 @p_ContactName           VARCHAR(200) = null,    
 @p_ContactNo             VARCHAR(50) = null,   
 @p_AlterNativeMobileNo   VARCHAR(50) = null,   
 @p_Email                 VARCHAR(100) = null,    
 @p_RegistrationType      VARCHAR(50) = null,    
 @p_CommissionPercent     FLOAT = null,    
 @p_LicenseNumber         VARCHAR(100) = null,    
 @p_LicenseExpiry         DATETIME = null,    
 @p_VehicleNumber         VARCHAR(25) = null,    
 @p_VehicleType           VARCHAR(25) = null,    
 @p_CapacityINTons        FLOAT = null,    
 @p_PermitType            VARCHAR(25) = null,    
 @p_PermitNumber          VARCHAR(25) = null,    
 @p_PermitExpiryDate      DATETIME = null,    
 @p_InsurancePolicyNumber VARCHAR(25) = null,    
 @p_InsuranceExpiryDate   DATETIME = null,    
 @p_OwnerName             VARCHAR(200) = null,    
 @p_AccountType           VARCHAR(50) = null,    
 @p_OpeningBalance        MONEY = null,    
 @p_OpeningBalanceType    BIT = null,    
 @p_Address               VARCHAR(500) = null,
 @p_AccountNumber         VARCHAR(20) = NULL,
 @ERROR                   VARCHAR(MAX) = NULL OUTPUT
)    
AS    
BEGIN    
 DECLARE @DocumentId INT, @Balance MONEY    
    
BEGIN TRY
BEGIN TRAN
   IF @p_Action = 'CREATE'    
 BEGIN    
  IF @p_EntityAccountType = 'COMPANY'    
  BEGIN    
   INSERT INTo tbl_EntityAccount(EntityAccountType, Name, GSTIN, ContactName,AlternateContactNo, ContactNo, Email, RegistrationType, Address)    
   VALUES(@p_EntityAccountType, @p_Name, @p_GSTIN,@p_ContactName,@p_AlterNativeMobileNo,@p_ContactNo, @p_Email, @p_RegistrationType, @p_Address)    
  END    
  ELSE IF @p_EntityAccountType = 'PARTY'    
  BEGIN    
   INSERT INTo tbl_EntityAccount(EntityAccountType, Name, GSTIN,ContactName,AlternateContactNo, ContactNo, Email, Address)    
   VALUES(@p_EntityAccountType, @p_Name, @p_GSTIN,@p_ContactName,@p_AlterNativeMobileNo,@p_ContactNo, @p_Email, @p_Address)    
  END    
  ELSE IF @p_EntityAccountType = 'BROKER'    
  BEGIN    
   INSERT INTo tbl_EntityAccount(EntityAccountType, Name,AadharNumber, PAN,ContactName, ContactNo,AlternateContactNo, CommissionPercent, Address)    
   VALUES(@p_EntityAccountType, @p_Name, @p_AadharNumber, @p_PAN,@p_ContactName,@p_ContactNo,@p_AlterNativeMobileNo, @p_CommissionPercent, @p_Address)    
  END    
  ELSE IF @p_EntityAccountType = 'DRIVER'    
  BEGIN    
   INSERT INTo tbl_EntityAccount(EntityAccountType, Name, LicenseNumber,  AadharNumber, ContactNo,AlternateContactNo,  Address)    
   VALUES(@p_EntityAccountType, @p_Name, @p_LicenseNumber,  @p_AadharNumber, @p_ContactNo,@p_AlterNativeMobileNo, @p_Address)    
  END    
  ELSE IF @p_EntityAccountType = 'VEHICLE'    
  BEGIN    
   INSERT INTo tbl_EntityAccount(    
       -- Vehicle Details    
       EntityAccountType, VehicleNumber, VehicleType, CapacityINTons, PermitType, PermitNumber, PermitExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate,    
    
       -- Owner Information / Other    
       OwnerName, AadharNumber, PAN, Address, DocumentId    
      )    
    VALUES  (    
       -- Vehicle Details    
       @p_EntityAccountType, @p_VehicleNumber, @p_VehicleType, @p_CapacityINTons, @p_PermitType, @p_PermitNumber, @p_PermitExpiryDate, @p_InsurancePolicyNumber, @p_InsuranceExpiryDate,    
    
       -- Owner Information / Other    
       @p_OwnerName, @p_AadharNumber, @p_PAN, @p_Address, @DocumentId    
      )    
  END    
  ELSE IF @p_EntityAccountType = 'ACCOUNT'    
  BEGIN    
   IF isnull(@p_OpeningBalance, 0) <= 0    
   BEGIN    
    SET @p_OpeningBalance = null    
    SET @p_OpeningBalanceType = null    
   END    
   ELSE    
   BEGIN    
    IF isnull(@p_OpeningBalanceType, 0) = 0    
     SET @Balance = -@p_OpeningBalance    
    ELSE    
     SET @Balance = @p_OpeningBalance    
   END    

   IF EXISTS(SELECT 1 FROM tbl_EntityAccount WITH (NOLOCK) WHERE ISNULL(AccountNumber,0) = ISNULL(@p_AccountNumber,0))
   BEGIN
     SET @ERROR = 'Account Number alredy Exists.'
	 RAISERROR(@ERROR, 16, 1);
   END
    
   INSERT INTo tbl_EntityAccount(EntityAccountType, Name, AccountType, OpeningBalance, OpeningBalanceType, Balance,AccountNumber)    
   VALUES(@p_EntityAccountType, @p_Name, @p_AccountType, @p_OpeningBalance, @p_OpeningBalanceType, @Balance,@p_AccountNumber)    
  END    
 END  
 IF @p_Action = 'DELETE'    
 BEGIN    
  IF @p_EntityAccountType = 'ACCOUNT' AND ISNULL(@p_EntityAccountId,0) > 0    
  BEGIN  
    DELETE FROM tbl_EntityAccount WHERE EntityAccountId = @p_EntityAccountId

	SET @p_Action = 'GET-LIST' 
	SET @p_EntityAccountType = 'ACCOUNT' 
  END    
 END
    
 IF @p_Action = 'GET-LIST'    
 BEGIN    
  IF @p_EntityAccountType = 'COMPANY'    
  BEGIN    
   SELECT EntityAccountId, EntityAccountType, Name, GSTIN, PAN, ContactNo, Email, RegistrationType, Address, RegisteredOn    
   FROM tbl_EntityAccount    
   where EntityAccountType = @p_EntityAccountType    
  END    
  ELSE IF @p_EntityAccountType = 'PARTY'    
  BEGIN    
   SELECT EntityAccountId, EntityAccountType, Name, GSTIN, PAN, ContactNo, Email, Address, RegisteredOn    
   FROM tbl_EntityAccount    
   where EntityAccountType = @p_EntityAccountType    
  END    
  ELSE IF @p_EntityAccountType = 'BROKER'    
  BEGIN    
   SELECT EntityAccountId, EntityAccountType, Name, GSTIN, PAN, ContactNo, Email, CommissionPercent, Address, RegisteredOn    
   FROM tbl_EntityAccount    
   where EntityAccountType = @p_EntityAccountType    
  END    
  ELSE IF @p_EntityAccountType = 'DRIVER'    
  BEGIN    
   SELECT EntityAccountId, EntityAccountType, Name, LicenseNumber, LicenseExpiry, PAN, ContactNo, Email, Address, RegisteredOn    
   FROM tbl_EntityAccount    
   where EntityAccountType = @p_EntityAccountType    
  END    
  ELSE IF @p_EntityAccountType = 'VEHICLE'    
  BEGIN    
   SELECT EntityAccountId, EntityAccountType, VehicleNumber, VehicleType, CapacityINTons, PermitType, PermitNumber, PermitExpiryDate,    
   InsurancePolicyNumber, InsuranceExpiryDate, OwnerName, AadharNumber, PAN, Address, DocumentId, RegisteredOn    
   FROM tbl_EntityAccount    
   where EntityAccountType = @p_EntityAccountType    
  END    
  ELSE IF @p_EntityAccountType = 'ACCOUNT'    
  BEGIN    
   SELECT EntityAccountId, EntityAccountType, Name, AccountType, OpeningBalance,ISNULL(AccountNumber,0) AccountNumber,   
       CASE OpeningBalanceType    
       WHEN 1 THEN 'Cr'    
       WHEN 0 THEN 'Dr'    
       ELSE '' END AS OpeningBalanceType, RegisteredOn    
   FROM tbl_EntityAccount    
   WHERE EntityAccountType = @p_EntityAccountType    
  END    
 END   
COMMIT TRAN
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;
    SET @ERROR = ERROR_MESSAGE();
    RAISERROR(@ERROR, 16, 1);
END CATCH
END