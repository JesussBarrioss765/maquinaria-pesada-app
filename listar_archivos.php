<?php
header('Content-Type: application/json; charset=utf-8');

/*
|--------------------------------------------------------------------------
| CONFIGURACIÓN
|--------------------------------------------------------------------------
*/

$TOKEN_VALIDO = "900.325.355-1";

// Datos MySQL
$DB_HOST = "localhost";
$DB_NAME = "u318851812_GESTIC";
$DB_USER = "u318851812_admin0";
$DB_PASS = "8Nb|^|a=";

/*
|--------------------------------------------------------------------------
| FUNCIONES
|--------------------------------------------------------------------------
*/

function responder($ok, $mensaje, $extra = []) {
    echo json_encode(array_merge([
        "ok" => $ok,
        "mensaje" => $mensaje
    ], $extra), JSON_UNESCAPED_UNICODE);
    exit;
}

function obtenerHeaderAuthorization() {
    $headers = [];

    if (function_exists('getallheaders')) {
        $headers = getallheaders();
    }

    foreach ($headers as $key => $value) {
        if (strtolower($key) === 'authorization') {
            return trim($value);
        }
    }

    if (isset($_SERVER['HTTP_AUTHORIZATION'])) {
        return trim($_SERVER['HTTP_AUTHORIZATION']);
    }

    if (isset($_SERVER['REDIRECT_HTTP_AUTHORIZATION'])) {
        return trim($_SERVER['REDIRECT_HTTP_AUTHORIZATION']);
    }

    return null;
}

/*
|--------------------------------------------------------------------------
| VALIDAR TOKEN
|--------------------------------------------------------------------------
*/

$auth = obtenerHeaderAuthorization();

if (!$auth || $auth !== $TOKEN_VALIDO) {
    responder(false, "Acceso no autorizado");
}

/*
|--------------------------------------------------------------------------
| CONSULTAR BASE DE DATOS
|--------------------------------------------------------------------------
*/

try {
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

    $mysqli = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
    $mysqli->set_charset("utf8mb4");

    $sql = "SELECT 
                id,
                usuario_id,
                proyecto,
                codigo,
                nombre,
                cantidad,
                precio,
                unidad,
                nombre_original,
                nombre_guardado,
                extension,
                mime_type,
                tamano_bytes,
                ruta_relativa,
                url_publica,
                fecha_subida
            FROM archivos_subidos
            ORDER BY id DESC";

    $result = $mysqli->query($sql);

    $datos = [];

    while ($row = $result->fetch_assoc()) {
        $datos[] = [
            "id" => $row["id"],
            "usuario_id" => $row["usuario_id"],
            "proyecto" => $row["proyecto"],
            "codigo" => $row["codigo"],
            "nombre" => $row["nombre"],
            "cantidad" => $row["cantidad"],
            "precio" => $row["precio"],
            "unidad" => $row["unidad"],
            "nombre_original" => $row["nombre_original"],
            "nombre_guardado" => $row["nombre_guardado"],
            "extension" => $row["extension"],
            "mime_type" => $row["mime_type"],
            "tamano_bytes" => $row["tamano_bytes"],
            "ruta_relativa" => $row["ruta_relativa"],
            "url_publica" => $row["url_publica"],
            "fecha_subida" => $row["fecha_subida"]
        ];
    }

    $mysqli->close();

    responder(true, "Datos consultados correctamente", [
        "total" => count($datos),
        "datos" => $datos
    ]);

} catch (Throwable $e) {
    responder(false, "Error consultando la base de datos", [
        "detalle" => $e->getMessage()
    ]);
}
?>