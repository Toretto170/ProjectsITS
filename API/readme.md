   [HttpPost("[action]")]
        public IActionResult Login([FromBody] User user) {

            var userAttuale = _apiDbContextcs.Users.FirstOrDefault(u => u.Email == user.Email && u.Password == user.Password);

            if (userAttuale == null) {
                return  NotFound();
            }
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["JWT:Key"]));
            var credenziali = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);//hash per la chiave
            var claims = new[]
            {
                new Claim(ClaimTypes.Email, user.Email)
            };

            var token = new JwtSecurityToken(issuer: _config["JWT:Issuer"], audience: _config["JWT:Audience"], claims = claims, 
                expires: DateTime.Now.AddMinutes(20),
                signingCredentials: credenziali);


            var jwt = new JwtSecurityTokenHandler().WriteToken(token); // converte il token in una stringa
            
            return Ok(jwt);
            //return Ok("Loggato");
        }