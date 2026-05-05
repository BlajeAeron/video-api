<?php
$conn = new mysqli(
  getenv("mysql.railway.internal"),
  getenv("root"),
  getenv("MRuHglKVQsWhHDFROtCUHnWyBYAHrHmg"),
  getenv("railway"),
  getenv("3306")
);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
?>
