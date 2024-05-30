using System.ComponentModel.DataAnnotations;

namespace Bioletto.Models
{
    public class Category
    {
        [Key]
        public int Id { get; set; }

        public string tipologia { get; set; }
    }
}
