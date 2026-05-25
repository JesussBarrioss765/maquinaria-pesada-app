<?php
header('Content-Type: application/json; charset=utf-8');

/*
|--------------------------------------------------------------------------
| CONFIGURACIÓN
|--------------------------------------------------------------------------
*/
$TOKEN_VALIDO = "900.325.355-1";

$DB_HOST = "localhost";
$DB_NAME = "u318851812_GESTIC";
$DB_USER = "u318851812_admin0";
$DB_PASS = "8Nb|^|a=";

/*
|--------------------------------------------------------------------------
| FUNCIONES AUXILIARES
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

function limpiarEntrada($valor) {
    if (!isset($valor)) return null;
    $valor = trim($valor);
    return $valor === '' ? null : $valor;
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
| OBTENER ACCIÓN
|--------------------------------------------------------------------------
*/
$action = $_GET["act"] ?? null;
if (!$action) {
    responder(false, "Acción no especificada");
}

/*
|--------------------------------------------------------------------------
| CONECTAR A BD
|--------------------------------------------------------------------------
*/
try {
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    $mysqli = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
    $mysqli->set_charset("utf8mb4");

    switch ($action) {

        /*
        |----------------------------------------------------------------------
        | OBTENER TODAS LAS MÁQUINAS
        |----------------------------------------------------------------------
        */
        case 'listar':
            $sql = "SELECT 
                        id_maquina,
                        codigo,
                        nombre,
                        marca,
                        tipo,
                        estado,
                        fecha_ingreso
                    FROM maquinas
                    ORDER BY nombre ASC";

            $result = $mysqli->query($sql);
            $maquinas = [];

            while ($row = $result->fetch_assoc()) {
                $maquinas[] = $row;
            }

            responder(true, "Máquinas obtenidas", [
                "total" => count($maquinas),
                "datos" => $maquinas
            ]);
            break;

        /*
        |----------------------------------------------------------------------
        | OBTENER ESTADÍSTICAS DE MÁQUINAS
        |----------------------------------------------------------------------
        */
        case 'stats':
            $sql = "SELECT 
                        m.id_maquina,
                        m.nombre,
                        m.codigo,
                        m.estado,
                        COUNT(f.id_falla) as total_fallas,
                        SUM(CASE WHEN f.estado = 'ABIERTA' THEN 1 ELSE 0 END) as fallas_abiertas,
                        SUM(CASE WHEN f.estado = 'CERRADA' THEN 1 ELSE 0 END) as fallas_cerradas,
                        SUM(f.tiempo_parada) as tiempo_parada_total,
                        COALESCE(MAX(f.fecha_falla), 'N/A') as ultima_falla,
                        COUNT(u.id_uso) as total_usos
                    FROM maquinas m
                    LEFT JOIN fallas_maquinas f ON m.id_maquina = f.id_maquina
                    LEFT JOIN uso_maquinas u ON m.id_maquina = u.id_maquina
                    GROUP BY m.id_maquina, m.nombre, m.codigo, m.estado
                    ORDER BY total_fallas DESC";

            $result = $mysqli->query($sql);
            $estadisticas = [];

            while ($row = $result->fetch_assoc()) {
                $estadisticas[] = [
                    "id_maquina" => (int)$row["id_maquina"],
                    "nombre" => $row["nombre"],
                    "codigo" => $row["codigo"],
                    "estado" => $row["estado"],
                    "total_fallas" => (int)$row["total_fallas"],
                    "fallas_abiertas" => (int)$row["fallas_abiertas"],
                    "fallas_cerradas" => (int)$row["fallas_cerradas"],
                    "tiempo_parada_horas" => round((int)$row["tiempo_parada_total"] / 60, 2),
                    "ultima_falla" => $row["ultima_falla"],
                    "total_usos" => (int)$row["total_usos"]
                ];
            }

            responder(true, "Estadísticas obtenidas", [
                "total_maquinas" => count($estadisticas),
                "datos" => $estadisticas
            ]);
            break;

        /*
        |----------------------------------------------------------------------
        | REGISTRAR NUEVA FALLA
        |----------------------------------------------------------------------
        */
        case 'registrar_falla':
            $id_maquina = (int)($_POST["id_maquina"] ?? 0);
            $tipo_falla = limpiarEntrada($_POST["tipo_falla"] ?? null);
            $descripcion = limpiarEntrada($_POST["descripcion"] ?? null);

            if ($id_maquina <= 0) {
                responder(false, "ID de máquina inválido");
            }

            if (!$tipo_falla) {
                responder(false, "Tipo de falla requerido");
            }

            if (!$descripcion) {
                responder(false, "Descripción requerida");
            }

            // Verificar que la máquina existe
            $stmt = $mysqli->prepare("SELECT id_maquina FROM maquinas WHERE id_maquina = ?");
            $stmt->bind_param("i", $id_maquina);
            $stmt->execute();
            if ($stmt->get_result()->num_rows === 0) {
                $stmt->close();
                responder(false, "Máquina no encontrada");
            }
            $stmt->close();

            // Insertar falla
            $stmt = $mysqli->prepare(
                "INSERT INTO fallas_maquinas (id_maquina, tipo_falla, descripcion, estado)
                 VALUES (?, ?, ?, 'ABIERTA')"
            );
            $stmt->bind_param("iss", $id_maquina, $tipo_falla, $descripcion);

            if ($stmt->execute()) {
                $id_falla = $mysqli->insert_id;
                $stmt->close();
                responder(true, "Falla registrada exitosamente", ["id_falla" => $id_falla]);
            } else {
                $stmt->close();
                responder(false, "Error al registrar falla");
            }
            break;

        /*
        |----------------------------------------------------------------------
        | OBTENER FALLAS DE UNA MÁQUINA
        |----------------------------------------------------------------------
        */
        case 'fallas':
            $id_maquina = (int)($_GET["id_maquina"] ?? 0);

            if ($id_maquina <= 0) {
                responder(false, "ID de máquina inválido");
            }

            $stmt = $mysqli->prepare(
                "SELECT 
                    id_falla,
                    id_maquina,
                    tipo_falla,
                    descripcion,
                    fecha_falla,
                    estado,
                    tiempo_parada
                 FROM fallas_maquinas
                 WHERE id_maquina = ?
                 ORDER BY fecha_falla DESC"
            );
            $stmt->bind_param("i", $id_maquina);
            $stmt->execute();
            $result = $stmt->get_result();

            $fallas = [];
            while ($row = $result->fetch_assoc()) {
                $fallas[] = $row;
            }
            $stmt->close();

            responder(true, "Fallas obtenidas", [
                "total" => count($fallas),
                "datos" => $fallas
            ]);
            break;

        /*
        |----------------------------------------------------------------------
        | REGISTRAR USO DE MÁQUINA
        |----------------------------------------------------------------------
        */
        case 'registrar_uso':
            $id_maquina = (int)($_POST["id_maquina"] ?? 0);
            $usuario = limpiarEntrada($_POST["usuario"] ?? null);
            $hora_inicio = limpiarEntrada($_POST["hora_inicio"] ?? null);
            $hora_fin = limpiarEntrada($_POST["hora_fin"] ?? null);

            if ($id_maquina <= 0) {
                responder(false, "ID de máquina inválido");
            }

            if (!$usuario) {
                responder(false, "Usuario requerido");
            }

            if (!$hora_inicio || !$hora_fin) {
                responder(false, "Horas requeridas");
            }

            // Calcular minutos
            $inicio = new DateTime($hora_inicio);
            $fin = new DateTime($hora_fin);
            $intervalo = $inicio->diff($fin);
            $total_minutos = ($intervalo->h * 60) + $intervalo->i;

            if ($total_minutos < 0) {
                responder(false, "La hora de fin debe ser posterior a la de inicio");
            }

            // Insertar uso
            $stmt = $mysqli->prepare(
                "INSERT INTO uso_maquinas (id_maquina, usuario, hora_inicio, hora_fin, total_minutos)
                 VALUES (?, ?, ?, ?, ?)"
            );
            $stmt->bind_param("isssi", $id_maquina, $usuario, $hora_inicio, $hora_fin, $total_minutos);

            if ($stmt->execute()) {
                $id_uso = $mysqli->insert_id;
                $stmt->close();
                responder(true, "Uso registrado exitosamente", [
                    "id_uso" => $id_uso,
                    "total_minutos" => $total_minutos
                ]);
            } else {
                $stmt->close();
                responder(false, "Error al registrar uso");
            }
            break;

        /*
        |----------------------------------------------------------------------
        | OBTENER HISTORIAL DE USO
        |----------------------------------------------------------------------
        */
        case 'historial_uso':
            $id_maquina = (int)($_GET["id_maquina"] ?? 0);

            if ($id_maquina <= 0) {
                responder(false, "ID de máquina inválido");
            }

            $stmt = $mysqli->prepare(
                "SELECT 
                    id_uso,
                    id_maquina,
                    usuario,
                    hora_inicio,
                    hora_fin,
                    total_minutos
                 FROM uso_maquinas
                 WHERE id_maquina = ?
                 ORDER BY hora_inicio DESC"
            );
            $stmt->bind_param("i", $id_maquina);
            $stmt->execute();
            $result = $stmt->get_result();

            $usos = [];
            while ($row = $result->fetch_assoc()) {
                $usos[] = [
                    "id_uso" => (int)$row["id_uso"],
                    "id_maquina" => (int)$row["id_maquina"],
                    "usuario" => $row["usuario"],
                    "hora_inicio" => $row["hora_inicio"],
                    "hora_fin" => $row["hora_fin"],
                    "total_minutos" => (int)$row["total_minutos"],
                    "total_horas" => round((int)$row["total_minutos"] / 60, 2)
                ];
            }
            $stmt->close();

            responder(true, "Historial de uso obtenido", [
                "total" => count($usos),
                "datos" => $usos
            ]);
            break;

        default:
            responder(false, "Acción no reconocida");
    }

    $mysqli->close();

} catch (Throwable $e) {
    responder(false, "Error en servidor", [
        "detalle" => $e->getMessage()
    ]);
}
?>
