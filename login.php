<?php
require_once 'conexion.php'; // Incluir el archivo de conexión

function validarCredenciales($nombreUsuario, $clave) {
    global $conn; // Utilizar la variable de conexión definida en el archivo de conexión
    
    // Escapar los valores para prevenir inyección de SQL
    $nombreUsuario = $conn->real_escape_string($nombreUsuario);
    $clave = $conn->real_escape_string($clave);
    
    // Consulta para verificar las credenciales
    $sql = "SELECT * FROM trabajador WHERE nombreUsuario = '$nombreUsuario' AND clave = '$clave'";
    $result = $conn->query($sql);
    
    if ($result === false) {
        die("Error en la consulta: " . $conn->error);
    }
    
    if ($result->num_rows > 0) {
        echo "Usuario encontrado";
    } else {
        echo "Usuario no encontrado";
    }
}

// Resto del código del archivo login.php...

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nombreUsuario = $_POST["nombreUsuario"];
    $clave = $_POST["clave"];
    
    validarCredenciales($nombreUsuario, $clave);
}
?>
