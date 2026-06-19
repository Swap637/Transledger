IF OBJECT_ID('PR_TR_TripEntry') IS NOT NULL 
    BEGIN
        DROP PROCEDURE PR_TR_TripEntry
    END
GO
CREATE PROCEDURE PR_TR_TripEntry
(
    @p_Mode               INT            = 0 ,
    @p_VehicleNumber      INT            = NULL ,
    @p_EntityAccountId    INT            = NULL ,
    @p_AmtforOwner        DECIMAL(18,2)  = NULL,
	@p_AmtForBroker       DECIMAL(18,2)  = NULL,
	@p_AmtForBkingPrty    DECIMAL(18,2)  = NULL,
	@p_Amount             DECIMAL(18,2)  = NULL,
    @p_Date               DATE           = NULL,
    @p_Remarks            VARCHAR(250)   = NULL,
    @p_LoadingPoint       VARCHAR(100)   = NULL,
    @p_UnloadingPoint     VARCHAR(100)   = NULL,
    @p_LRNumber           VARCHAR(20)    = NULL,
	@p_TripNumber         VARCHAR(20)    = NULL,
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
	 DECLARE @TripNumber AS VARCHAR(20),@RunningNo INT
	-- </Variable Declaration>
	IF ISNULL(@p_Mode,0)=0
		BEGIN
		
		 

		-- Get the next running number for today
		SELECT @RunningNo = ISNULL(MAX(CAST(RIGHT(TripNumber,4) AS INT)),0) + 1
		FROM b_TripEntry
		WHERE LEFT(TripNumber,8) = 'TR' + CONVERT(VARCHAR(6), @p_Date, 12)

		SET @TripNumber = 'TR'
						+ CONVERT(VARCHAR(6), @p_Date, 12)
						+ RIGHT('0000' + CAST(@RunningNo AS VARCHAR(4)),4)

		 INSERT INTO b_TripEntry
			(TripNumber,LRBiltyNumber,VehicleId,TripDate,AmtforOwner,BrokerId,AmtForBroker,BookingPartyId,AmtForBkingPrty,Driverid,LoadingPoint,UnloadingPoint,Remarks,TripStatus,CreatedBy,CreatedOn)
		 VALUES(@TripNumber,@p_LRNumber,@p_VehicleNumber,@p_Date,@p_AmtforOwner,@p_BrokerId,@p_AmtForBroker,@p_BookingPartyId,@p_AmtForBkingPrty,@p_Driverid,@p_LoadingPoint,      
			 @p_UnloadingPoint,@p_Remarks,0,1,GETDATE());
		SELECT SCOPE_IDENTITY() AS NewTripId;
	END
	-- <Fetch Vehicle Details>
	IF ISNULL(@p_Mode,0)=1  
	 BEGIN  
	   SELECT CapacityInTons,OwnerName,ISNULL(ContactNo,AlternateContactNo) 'ContactNo'
	   FROM tbl_EntityAccount WITH(NOLOCK)
	   WHERE EntityAccountType = 'VEHICLE'  AND EntityAccountId = @p_VehicleNumber
	  END  
	 -- </Fetch Vehicle Details>
	 	-- <Fetch Vehicle Details>
	IF ISNULL(@p_Mode,0) = 2  
	 BEGIN  
	   SELECT TripId,TripNumber,EA.VehicleNumber,DRIVER.Name,FORMAT(TripDate,'dd-MMM-yyyy') TripDate,LoadingPoint,UnloadingPoint,
			CASE 
				WHEN ISNULL(TripStatus, 0) = 0 THEN 'PENDING'
				WHEN ISNULL(TripStatus, 0) = 1 THEN 'COMPLETED'
				WHEN ISNULL(TripStatus, 0) = 2 THEN 'CANCELLED'
				ELSE 'UNKNOWN'
			END AS TRIPSTATUS
	   FROM b_TripEntry te WITH(NOLOCK)
	   INNER JOIN tbl_EntityAccount EA WITH(NOLOCK)ON EA.EntityAccountId = te.VehicleId 
	   INNER JOIN tbl_EntityAccount DRIVER WITH(NOLOCK)ON DRIVER.EntityAccountId = te.Driverid
	   WHERE 1=1 AND TripNumber LIKE ISNULL(@p_TripNumber,TripNumber)
	   ORDER BY CreatedOn DESC
	  END  
	 -- </Fetch Vehicle Details>
	
END
go
EXEC PR_TR_TripEntry
@p_Mode= 2,
@p_TripNumber = 'TR2606230019'
--GO
--BEGIN TRAN
--EXEC PR_TR_TripEntry
--@p_Mode= 0,
--@p_VehicleNumber= 19,
--@p_EntityAccountId= 0,
--@p_AmtforOwner= 546456,
--@p_Date= '2026-06-07 00:00:00',
--@p_Remarks= 'dfgdfgdf',
--@p_LoadingPoint= 'sddfgdf',
--@p_UnloadingPoint= 'dfgdfg',
--@p_LRNumber= 'dfgdf',
--@p_BookingPartyId= 17,
--@p_AmtForBkingPrty= 54654,
--@p_BrokerId= 15,
--@p_AmtForBroker= 54645,
--@p_Driverid= 30
--select * from b_TripEntry
--ROLLBACK TRAN