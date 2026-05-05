<?php
$url = getenv("MYSQL_PUBLIC_URL");

$parts = parse_url($url);

$conn = new mysqli(
  $parts['host'],
  $parts['user'],
  $parts['pass'],
  ltrim($parts['path'], '/'),
  $parts['port']
);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
?>
