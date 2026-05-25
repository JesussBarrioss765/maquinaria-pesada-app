<?php
header('Content-Type: application/json; charset=utf-8');

/*
|--------------------------------------------------------------------------
| CONFIGURACIÓN
|--------------------------------------------------------------------------
*/
$DOMINIO = "https://araucariasolar.org";
$TOKEN_VALIDO = "900.325.355-1";

// Datos MySQL
$DB_HOST = "localhost";
$DB_NAME = "u318851812_GESTIC";
$DB_USER = "u318851812_admin0";
$DB_PASS = "8Nb|^|a=";

// Tamaño máximo: 10 MB
$MAX_SIZE = 10 * 1024 * 1024;

// Extensiones permitidas
$EXT_PERMITIDAS = ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'xls', 'xlsx'];

// MIME permitidos
$MIME_PERMITIDOS = [
    'image/jpeg',
    'image/png',
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
];

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

function limpiarNombre($nombre) {
    $nombre = preg_replace('/[^A-Za-z0-9_\-\.]/', '_', $nombre);
    $nombre = preg_replace('/_+/', '_', $nombre);
    return trim($nombre, '_');
}

function limpiarTexto($valor) {
    if (!isset($valor)) {
        return null;
    }

    $valor = trim($valor);

    if ($valor === '') {
        return null;
    }

    return $valor;
}

function limpiarDecimal($valor) {
    if (!isset($valor)) {
        return null;
    }

    $valor = trim($valor);

    if ($valor === '') {
        return null;
    }

    // Permite valores tipo 12,5 o 12.5
    $valor = str_replace(',', '.', $valor);

    if (!is_numeric($valor)) {
        return null;
    }

    return (float)$valor;
}

/*
|--------------------------------------------------------------------------
| AUTENTICACIÓN
|--------------------------------------------------------------------------
*/
$auth = obtenerHeaderAuthorization();

if (!$auth || $auth !== $TOKEN_VALIDO) {
    responder(false, "Acceso no autorizado");
}

/*
|--------------------------------------------------------------------------
| VALIDAR ARCHIVO
|--------------------------------------------------------------------------
*/
if (!isset($_FILES['archivo'])) {
    responder(false, "No se recibió ningún archivo");
}

$archivo = $_FILES['archivo'];

if (!isset($archivo['error']) || is_array($archivo['error'])) {
    responder(false, "Solicitud de archivo inválida");
}

if ($archivo['error'] !== UPLOAD_ERR_OK) {
    responder(false, "Error en la subida", ["codigo" => $archivo['error']]);
}

$nombreOriginal = $archivo['name'];
$tmpName = $archivo['tmp_name'];
$tamano = (int)$archivo['size'];

if ($tamano <= 0) {
    responder(false, "El archivo está vacío");
}

if ($tamano > $MAX_SIZE) {
    responder(false, "Archivo demasiado grande. Máximo permitido: 10 MB");
}

$ext = strtolower(pathinfo($nombreOriginal, PATHINFO_EXTENSION));

if (!in_array($ext, $EXT_PERMITIDAS, true)) {
    responder(false, "Extensión no permitida");
}

$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime = finfo_file($finfo, $tmpName);
finfo_close($finfo);

if (!in_array($mime, $MIME_PERMITIDOS, true)) {
    responder(false, "Tipo MIME no permitido", ["mime_detectado" => $mime]);
}

/*
|--------------------------------------------------------------------------
| RECIBIR DATOS DEL FORMULARIO
|--------------------------------------------------------------------------
*/
$usuario_id = limpiarTexto($_POST['usuario_id'] ?? null);
$proyecto   = limpiarTexto($_POST['proyecto'] ?? null);

$codigo   = limpiarTexto($_POST['codigo'] ?? null);
$nombre   = limpiarTexto($_POST['nombre'] ?? null);
$cantidad = limpiarDecimal($_POST['cantidad'] ?? null);
$precio   = limpiarDecimal($_POST['precio'] ?? null);
$unidad   = limpiarTexto($_POST['unidad'] ?? null);

/*
|--------------------------------------------------------------------------
| VALIDAR DATOS
|--------------------------------------------------------------------------
*/
if ($usuario_id === null) {
    responder(false, "Falta usuario_id");
}

if ($proyecto === null) {
    responder(false, "Falta proyecto");
}

if ($codigo === null) {
    responder(false, "Falta codigo");
}

if ($nombre === null) {
    responder(false, "Falta nombre");
}

if ($cantidad === null) {
    responder(false, "Falta cantidad o no es válida");
}

if ($precio === null) {
    responder(false, "Falta precio o no es válido");
}

if ($unidad === null) {
    responder(false, "Falta unidad");
}

/*
|--------------------------------------------------------------------------
| CREAR CARPETA DE DESTINO POR FECHA
|--------------------------------------------------------------------------
*/
$subcarpeta = date("Y/m");
$uploadDir = __DIR__ . "/uploads/" . $subcarpeta . "/";

if (!is_dir($uploadDir)) {
    if (!mkdir($uploadDir, 0755, true)) {
        responder(false, "No se pudo crear la carpeta de destino");
    }
}

/*
|--------------------------------------------------------------------------
| GENERAR NOMBRE ÚNICO
|--------------------------------------------------------------------------
*/
$baseOriginal = pathinfo($nombreOriginal, PATHINFO_FILENAME);
$baseOriginal = limpiarNombre($baseOriginal);

if ($baseOriginal === '') {
    $baseOriginal = 'archivo';
}

try {
    $nombreNuevo = date("Ymd_His") . "_" . bin2hex(random_bytes(4)) . "_" . $baseOriginal . "." . $ext;
} catch (Exception $e) {
    $nombreNuevo = date("Ymd_His") . "_" . uniqid() . "_" . $baseOriginal . "." . $ext;
}

$rutaDestino = $uploadDir . $nombreNuevo;

if (!is_uploaded_file($tmpName)) {
    responder(false, "Archivo no válido");
}

/*
|--------------------------------------------------------------------------
| MOVER ARCHIVO
|--------------------------------------------------------------------------
*/
if (!move_uploaded_file($tmpName, $rutaDestino)) {
    responder(false, "No se pudo guardar el archivo en el servidor");
}

/*
|--------------------------------------------------------------------------
| URL FINAL
|--------------------------------------------------------------------------
*/
$url = $DOMINIO . "/uploads/" . $subcarpeta . "/" . rawurlencode($nombreNuevo);
$rutaRelativa = "uploads/" . $subcarpeta . "/" . $nombreNuevo;

/*
|--------------------------------------------------------------------------
| GUARDAR EN BASE DE DATOS
|--------------------------------------------------------------------------
*/
try {
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

    $mysqli = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
    $mysqli->set_charset("utf8mb4");

    $sql = "INSERT INTO archivos_subidos
            (
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
            )
            VALUES
            (
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                NOW()
            )";

    $stmt = $mysqli->prepare($sql);

    $stmt->bind_param(
        "ssssddsssssiss",
        $usuario_id,
        $proyecto,
        $codigo,
        $nombre,
        $cantidad,
        $precio,
        $unidad,
        $nombreOriginal,
        $nombreNuevo,
        $ext,
        $mime,
        $tamano,
        $rutaRelativa,
        $url
    );

    $stmt->execute();
    $idInsertado = $stmt->insert_id;

    $stmt->close();
    $mysqli->close();

} catch (Throwable $e) {
    // Si falla la BD, borra el archivo para no dejar basura huérfana
    if (file_exists($rutaDestino)) {
        @unlink($rutaDestino);
    }

    responder(false, "Error guardando en base de datos", [
        "detalle" => $e->getMessage()
    ]);
}

/*
|--------------------------------------------------------------------------
| RESPUESTA EXITOSA
|--------------------------------------------------------------------------
*/
responder(true, "Archivo y datos guardados correctamente", [
    "id" => $idInsertado,
    "usuario_id" => $usuario_id,
    "proyecto" => $proyecto,
    "codigo" => $codigo,
    "nombre" => $nombre,
    "cantidad" => $cantidad,
    "precio" => $precio,
    "unidad" => $unidad,
    "nombre_original" => $nombreOriginal,
    "nombre_guardado" => $nombreNuevo,
    "extension" => $ext,
    "mime_type" => $mime,
    "tamano_bytes" => $tamano,
    "url" => $url,
    "ruta_relativa" => $rutaRelativa
]);
?>
