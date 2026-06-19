namespace TransLedger.Models
{
    public class EntityAccountViewModel
    {
        public int EntityAccountId { get; set; }

        public string? EntityAccountType { get; set; }

        public string? Name { get; set; }

        public string? GSTIN { get; set; }

        public string? PAN { get; set; }

        public string? AadharNumber { get; set; }

        public string? ContactNo { get; set; }

        public string? Email { get; set; }

        public string? RegistrationType { get; set; }

        public double? CommissionPercent { get; set; }

        public string? LicenseNumber { get; set; }

        public DateTime? LicenseExpiry { get; set; }

        public string? VehicleNumber { get; set; }

        public string? VehicleType { get; set; }

        public double? CapacityInTons { get; set; }

        public string? PermitType { get; set; }

        public string? PermitNumber { get; set; }

        public DateTime? PermitExpiryDate { get; set; }

        public string? InsurancePolicyNumber { get; set; }

        public DateTime? InsuranceExpiryDate { get; set; }

        public string? OwnerName { get; set; }

        public string? AccountType { get; set; }

        public decimal? OpeningBalance { get; set; }

        /// <summary>
        /// 0 = Debit, 1 = Credit
        /// </summary>
        public bool OpeningBalanceType { get; set; }

        public string? Address { get; set; }

        public int? DocumentId { get; set; }

        public DateTime RegisteredOn { get; set; } = DateTime.Now;
        public string? ContactPersonName { get; set; }
        public string? AlterNativeMobileNo { get; set; }
        public string? AccountNumber { get; set; }
    }
}
