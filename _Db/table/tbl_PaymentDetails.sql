IF OBJECT_ID('tbl_PaymentDetails') IS NULL
BEGIN
	CREATE TABLE tbl_PaymentDetails
	(
		PaymentDetailsId    INT PRIMARY KEY IDENTITY(1,1),
		TripEntryId         INT    NULL,
		Amount              MONEY  NULL,
		CreditedFrom        VARCHAR(50)  NULL,
		CreditedTo          VARCHAR(50)  NULL,
		PaymentDate         DATETIME  NULL,
		ModeOfPayment       VARCHAR(25)  NULL,
		OthrPymntMeth       VARCHAR(25) NULL,
		UTRTranRefNumber    VARCHAR(25) NULL,
		Remarks             VARCHAR(500) NULL,
		RefId               UNIQUEIDENTIFIER,
		CreatedOn           DATETIME NULL
	)
END
GO

