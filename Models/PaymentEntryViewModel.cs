namespace TransLedger.Models
{
    public class PaymentEntryViewModel
    {   
        public string PaymentType { get; set; }
        public int BookingPartyId { get; set; }
        public int EntityAccountId { get; set; }
        public decimal Amount { get; set; }
        public DateTime Date { get; set; }
        public string ModeOfPayment { get; set; }
        public string ReferenceNumber { get; set; }
        public string Remarks { get; set; }
        public string OtherPaymentMethod { get; set; }
        public string tripNumber { get; set; }
        public string Credited_Accountid { get; set; }
        public int HiddenTripid { get; set; }
        public int DebitedFromacctid { get; set; }
        public int CreditedToCashout { get; set; }
    }
}
