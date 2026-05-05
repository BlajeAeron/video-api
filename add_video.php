<?php
include 'db.php';

$title = $_POST['title'];
$thumbnail = $_POST['thumbnail'];
$video_url = $_POST['video_url'];

$sql = "INSERT INTO videos (title, thumbnail, video_url) 
        VALUES ('$title', '$thumbnail', '$video_url')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error"]);
}
?>