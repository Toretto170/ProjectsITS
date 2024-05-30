using Bioletto.Data;
using Bioletto.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Bioletto.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        ApiDbContext _dbContext = new ApiDbContext();
        //get
        [HttpGet]
        public IEnumerable<User> Get()
        {
            return _dbContext.Users;
        }
        //getbyid
        [HttpGet("{id}")]
        public User GetUser(int id)
        {
            var user = _dbContext.Users.FirstOrDefault(x => x.Id == id);
            return user;
        }
        //post
        [HttpPost]
        public void AggiungiUser([FromBody] User user) {
            _dbContext.Add(user);
            _dbContext.SaveChanges();
        }
        //update
        [HttpPut("{id}")]
        public void UptdateUser(int id, [FromBody] User updatedUser) {
            var user = _dbContext.Users.Find(id);
            if(user != null) { 
                user.Name = updatedUser.Name;
                user.Surname = updatedUser.Surname;
                user.Email = updatedUser.Email;
                user.Password = updatedUser.Password;
            }
            _dbContext.SaveChanges();
        }
        [HttpDelete("{id}")]
        public IActionResult DeleteUser(int id){
            var user = _dbContext.Users.Find(id);
            if(user == null) {
                return BadRequest(new {errorCode=4, errorDescription="User non trovato"});
            }
            else
            {
                _dbContext.Remove(user);
                _dbContext.SaveChanges() ;
                return Ok();
            }
        }
    }
}

