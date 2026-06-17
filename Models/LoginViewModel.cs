using System.ComponentModel.DataAnnotations;

namespace TransLedger.Models
{
    public class LoginViewModel
    {
        [Required]
        public string UserId { get; set; }

        [Required]
        public string Password { get; set; }
    }
}
