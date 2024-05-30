using System.ComponentModel.DataAnnotations;

namespace Bioletto.Models
{
    public class Seller
    {
        [Key]
        public int id { get; set; }
        public string name { get; set; }
        public string email { get; set; }
        public string password { get; set; }
    }
}
