<?php

header("Content-Type: application/json");

include 'db.php';

$result = $conn->query("SELECT * FROM videos");

if (!$result) {
    die("Query error: " . $conn->error);
}

$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);

?>
