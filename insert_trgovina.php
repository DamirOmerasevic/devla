<?php
$servername = "localhost";
$username = "root";
$password = "SUPERsecretPASSWORD";
$dbname = "rezervacije_final";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$sql = "CALL sp_create_trgovina('Trgovina#3', 1, @isError)";
$result = $conn->query($sql);
$sql = "SELECT @isError";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
  // output data of each row
  while($row = $result->fetch_assoc()) {
    echo "isError: " . $row["@isError"] . "<br>";
  }
} else {
  echo "0 results";
}
$conn->close();
?>