using Bioletto.Models;
using Microsoft.EntityFrameworkCore;

namespace Bioletto.Data
{
    public class ApiDbContext : DbContext
    {
          
        public DbSet<Book> Books { get; set; }
        public DbSet<User> Users { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {

            optionsBuilder.UseSqlServer(@"Server= (localdb)\MSSQLLocalDB;Database=bookshop");
        }

        internal object Find(int id)
        {
            throw new NotImplementedException();
        }
    }
}
