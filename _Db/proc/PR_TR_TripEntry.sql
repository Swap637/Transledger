IF OBJECT_ID('PR_TR_TripEntry') IS NOT NULL 
    BEGIN
        DROP PROCEDURE PR_TR_TripEntry
    END
GO
CREATE PROCEDURE PR_TR_TripEntry
(
    @p_Mode             INT            = 0 ,
    @p_VehicleNumber      INT            = NULL ,
    @p_EntityAccountId    INT            = NULL ,
    @p_Amount             DECIMAL(18,2)  = NULL,
    @p_Date               DATE           = NULL,
    @p_Remarks            VARCHAR(250)   = NULL,
    @p_LoadingPoint       VARCHAR(100)   = NULL,
    @p_UnloadingPoint     VARCHAR(100)   = NULL,
    @p_LRNumber           VARCHAR(20)    = NULL,
    @p_BookingPartyId     INT            = NULL ,
    @p_BrokerId           INT            = NULL,
    @p_CommissionBrokerage DECIMAL(18,2) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
	IF ISNULL(@p_Mode,0)=0
		BEGIN

		 INSERT INTO b_TripEntry
			(VehicleId,BookingPartyId,BrokerId,TripDate,LoadingPoint,UnloadingPoint,LRNumber,
			HiringAmount,Remarks,TripStatus,CreatedBy,CreatedOn)
		 VALUES
			(@p_VehicleNumber,@p_BookingPartyId,@p_BrokerId,@p_Date,@p_LoadingPoint,      
			 @p_UnloadingPoint,@p_LRNumber,@p_Amount,@p_Remarks,0,        
			1,GETDATE()           
			);
		SELECT SCOPE_IDENTITY() AS NewTripId;

	END
	IF ISNULL(@p_Mode,0)=1  
	 BEGIN  
  
   SELECT CapacityInTons,OwnerName,ISNULL(ContactNo,AlternateContactNo) 'ContactNo' FROM tbl_EntityAccount WITH(NOLOCK)
   WHERE EntityAccountType = 'VEHICLE'  AND EntityAccountId = @p_VehicleNumber
  END  
	
END