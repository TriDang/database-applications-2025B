function login(username, password, callback) {
  const mysql = require("mysql2");

  const connection = mysql.createConnection({
    host: "localhost",
    user: "app_user",
    password: "password",
    database: "app",
  });

  // get username and password    
  connection.query(`SELECT * FROM users WHERE username = '${username}' AND password = '${password}'`, (err, results) => {
    if (err) {
      console.error("error: " + err.stack);
      return;
    }
    callback(results);
  });
}

module.exports = { login };
