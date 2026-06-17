CREATE TABLE b_TripEntry (
    TripId INT IDENTITY(1,1) NOT NULL,
    VehicleId INT NOT NULL,
    BookingPartyId INT NOT NULL,
    BrokerId INT NULL,
    TripDate DATE NOT NULL,
    LoadingPoint NVARCHAR(100) NOT NULL, 
    UnloadingPoint NVARCHAR(100) NOT NULL,
    LRNumber VARCHAR(10) NOT NULL,  
    HiringAmount DECIMAL(18, 2) NOT NULL,
    Remarks NVARCHAR(MAX) NULL,
	TripStatus  INT  NULL,
    CreatedBy INT NOT NULL,
    CreatedOn DATETIME NOT NULL CONSTRAINT DF_b_TripEntry_CreatedOn DEFAULT GETDATE(),
    ModifiedBy INT NULL,
    ModifiedOn DATETIME NULL,
    CONSTRAINT PK_b_TripEntry PRIMARY KEY CLUSTERED (TripId)
);