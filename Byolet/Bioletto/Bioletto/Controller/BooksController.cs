using Bioletto.Data;
using Bioletto.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Bioletto.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class BooksController : ControllerBase
    {
        ApiDbContext _dbContext = new ApiDbContext();

        //GET
        [HttpGet]
        public IEnumerable<Book> GetBooks()
        {
           return _dbContext.Books;
        }

        //GETbyID
        [HttpGet("{id}")]
        public Book GetBook(int id)
        {
            var book = _dbContext.Books.FirstOrDefault(x => x.Id == id);
            return book;
        }

        //POST
        [HttpPost]

        public IActionResult PostBook([FromBody]Book book) {
            _dbContext.Add(book); 
            _dbContext.SaveChanges();
            return Ok();
        }

        //UPDATE
        [HttpPut("{id}")]
        public IActionResult UpdateBook(int id, [FromBody]Book updateBook)
        {
            var book = _dbContext.Books.Find(id);
            if (book != null) {
                book.Title = updateBook.Title;
                book.Author = updateBook.Author;
                book.Year = updateBook.Year;
            }

            _dbContext.SaveChanges();
            return Ok();

        }
        //DELETE
        [HttpDelete("{id}")]

        public IActionResult DeleteBook(int id) {
            var book = _dbContext.Books.Find(id);
            if (book == null) {
                return BadRequest(new { errorCode = 4, errorDescription = "Libro non trovato" });
            }
            else
            {
                _dbContext.Remove(book);
                _dbContext.SaveChanges();
                return Ok();

            }
        }


    }
}
