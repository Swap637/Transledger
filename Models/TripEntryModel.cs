namespace TransLedger.Models
{
    public class TripEntryModel
    {
        public int VehicleNumber { get; set; }

        public int EntityAccountId { get; set; }

        public decimal Amount { get; set; }

        public DateTime Date { get; set; }

        public string ModeOfPayment { get; set; }

        public string ReferenceNumber { get; set; }

        public string Remarks { get; set; }

        public string LoadingPoint { get; set; }

        public string UnloadingPoint { get; set; }

        public string LRNumber { get; set; }

        public int BookingPartyId { get; set; }

        public int BrokerId { get; set; }

        public decimal CommissionBrokerage { get; set; }

        public String LRBiltyNumber { get; set; }

        public int Driver { get; set; }
        public decimal HiringAmountForowner { get; set; }
        public decimal HiringAmountForBroker { get; set; }
        public decimal HiringAmountfromParty { get; set; }
    }
}