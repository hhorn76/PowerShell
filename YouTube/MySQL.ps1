#Create Variables
$strUser = "powershell"
$strPW = "myPassword"
$strDB = "mysql"
$strServer = "mysql.mydomain.com”

#Demonstrate Connecting to MySQL
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$conn = New-Object MySql.Data.MySqlClient.MySqlConnection
$cs = "server=$($strServer);port=3306;database=$($strDB);uid=$($strUser);pwd=$($strPW)"
$conn.ConnectionString = $cs
$conn.Open()

#Demonstrate Querying MySQL with Data Set
$query = "SELECT * FROM mysql.user;"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$da = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($cmd)
$ds = New-Object System.Data.DataSet
$RecordCount = $da.Fill($ds, "data")
Write-Host $RecordCount

$ds.Tables.Count
$ds.Tables.Rows.Count
$ds.Tables.Rows.User
$ds.Tables[0].Rows[9].Host

#Demonstrate CREATE DATABASE with ExecuteNonQuery
$query = "CREATE DATABASE my_db;"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

#Demonstrate ExecuteNonQuery
$query = "USE my_db;"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

#Demonstrate CREATE TABLE with ExecuteNonQuery
$query = "CREATE TABLE animals (
    id INT NOT NULL AUTO_INCREMENT,
    name CHAR(30) NOT NULL,
    PRIMARY KEY (id)
    );"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

#Demonstrate INSERT with ExecuteNonQuery
$query = "INSERT INTO animals (name) VALUES
    ('dog'),('cat'),('penguin'),
    ('lax'),('whale'),('ostrich');
    ;"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

#Demonstrate UPDATE with ExecuteNonQuery
$query = "UPDATE animals SET name='mouse' WHERE name='lax';"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

#Demonstrate DELETE with ExecuteNonQuery
$query = "DELETE FROM animals WHERE name='whale';"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

#Demonstrate Parameters with @
$query = "SELECT * FROM animals WHERE id=@id;”
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.Parameters.AddWithValue("@id", 3);
$da = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($cmd)
$ds = New-Object System.Data.DataSet
$da.Fill($ds, "data")
$ds.Tables.Rows

#Demonstrate Parameters with ?
$query = "SELECT * FROM animals WHERE id=?id;”
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.Parameters.AddWithValue("id", 3);
$da = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($cmd)
$ds = New-Object System.Data.DataSet
$da.Fill($ds, "data")
$ds.Tables.Rows

#Demonstrate Aggrigation witn ExecuteScalar
$query="SELECT COUNT(*) FROM animals;"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteScalar()

#Demonstrate PROCEDURES with ExecuteNonQuery and ExecuteScalar
$query="CREATE PROCEDURE my_routine() 
BEGIN 
    SELECT name FROM animals ORDER BY name;
    SELECT COUNT(name) FROM animals;
END"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

$query="CALL my_db.my_routine();"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$ds = New-Object System.Data.DataSet
$da.Fill($ds, "data")
$ds.Tables.Count
$ds.Tables[0]
$ds.Tables[1]

#Demonstrate FUNCTIONS with ExecuteNonQuery and ExecuteScalar
$query="CREATE FUNCTION hello (s CHAR(20))
    RETURNS CHAR(50) DETERMINISTIC
    RETURN CONCAT('Hello, ',s,'!');"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

$query="SELECT hello('world');"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteScalar()

#Demonstrate DROP TABLE with ExecuteNonQuery
$query = "DROP FUNCTION hello;"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

#Demonstrate DROP TABLE with ExecuteNonQuery
$query = "DROP PROCEDURE my_routine;"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

#Demonstrate DROP TABLE with ExecuteNonQuery
$query = "DROP TABLE animals;"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

#Demonstrate DROP DATABASE with ExecuteNonQuery
$query = "DROP DATABASE my_db;"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$cmd.ExecuteNonQuery()

#Using the Try, Catch and Finally Block
Try
{
      
    [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
    $conn = New-Object MySql.Data.MySqlClient.MySqlConnection
    $conn.Open()
    #...
}
Catch
{
    Write-Host "ERROR : Unable to run query : $query `n$Error[0]"
}
Finally
{
  $conn.Close()
}
