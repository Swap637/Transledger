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
    @p_AmtforOwner        DECIMAL(18,2)  = NULL,
	@p_AmtForBroker             DECIMAL(18,2)  = NULL,
	@p_AmtForBkingPrty             DECIMAL(18,2)  = NULL,
	@p_Amount             DECIMAL(18,2)  = NULL,
    @p_Date               DATE           = NULL,
    @p_Remarks            VARCHAR(250)   = NULL,
    @p_LoadingPoint       VARCHAR(100)   = NULL,
    @p_UnloadingPoint     VARCHAR(100)   = NULL,
    @p_LRNumber           VARCHAR(20)    = NULL,
    @p_BookingPartyId     INT            = NULL ,
    @p_BrokerId           INT            = NULL,
	@p_Driverid           INT            = NULL,
    @p_CommissionBrokerage DECIMAL(18,2) = NULL
)
AS
/*
--<Changes>----------------------------------------------------------------------------------------------------------------------
-- Name       Version    Date           Purpose
-- Swapnil k  1.0.0.0    19-06-2026      Made changes to save the trio entry details
--</Changes>---------------------------------------------------------------------------------------------------------------------
*/
BEGIN
    SET NOCOUNT ON;
	-- <Variable Declaration>
	 DECLARE @TripNumber AS VARCHAR(20)
	-- </Variable Declaration>
	IF ISNULL(@p_Mode,0)=0
		BEGIN
		
		 SET @TripNumber  =   CONVERT(VARCHAR(6), @p_Date, 12); 
		 INSERT INTO b_TripEntry
			(TripNumber,LRBiltyNumber,VehicleId,TripDate,AmtforOwner,BrokerId,AmtForBroker,BookingPartyId,AmtForBkingPrty,Driverid,LoadingPoint,UnloadingPoint,Remarks,TripStatus,CreatedBy,CreatedOn)
		 VALUES(@TripNumber,@p_LRNumber,@p_VehicleNumber,@p_Date,@p_AmtforOwner,@p_BrokerId,@p_AmtForBroker,@p_BookingPartyId,@p_AmtForBkingPrty,@p_Driverid,@p_LoadingPoint,      
			 @p_UnloadingPoint,@p_Remarks,0,1,GETDATE());
		SELECT SCOPE_IDENTITY() AS NewTripId;

	END
	IF ISNULL(@p_Mode,0)=1  
	 BEGIN  
  
   SELECT CapacityInTons,OwnerName,ISNULL(ContactNo,AlternateContactNo) 'ContactNo' FROM tbl_EntityAccount WITH(NOLOCK)
   WHERE EntityAccountType = 'VEHICLE'  AND EntityAccountId = @p_VehicleNumber
  END  
	
END