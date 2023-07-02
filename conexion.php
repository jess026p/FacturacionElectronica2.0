<?php
$servername = "localhost";
$username = "id20988108_facturacionelectronica";
$password = "teamCalidad1.";
$database = "id20988108_facturacionelectronica";

$conn = new mysqli($servername, $username, $password, $database);

if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
} else {
    echo "Conexión exitosa a la base de datos";
}
?>