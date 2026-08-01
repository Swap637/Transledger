namespace TransLedger.Models
{
    public class FilterModel
    {
        public string PaymentType { get; set; }
        public string PaymentMode { get; set; }
        public string ReferenceNumber { get; set; }
        public string TransactionNumber { get; set; }
        public string TripNumber { get; set; }
        public DateTime TripDate { get; set; }

    }
}
