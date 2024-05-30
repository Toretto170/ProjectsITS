using System.ComponentModel.DataAnnotations.Schema;

namespace Bioletto.Models
{
    public class Book
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Author { get; set; }
        public int Year { get; set; }
        [ForeignKey("User")]
        public int User { get; set; }
        public  float Score { get; set; }
        public double Price { get; set; }

    }
}
