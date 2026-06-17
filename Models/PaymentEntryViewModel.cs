namespace TransLedger.Models
{
    public class PaymentEntryViewModel
    {   
        public string PaymentType { get; set; }
        public int EntityAccountId { get; set; }
        public decimal Amount { get; set; }
        public DateTime Date { get; set; }
        public string ModeOfPayment { get; set; }
        public string ReferenceNumber { get; set; }
        public string Remarks { get; set; }
    }
}
