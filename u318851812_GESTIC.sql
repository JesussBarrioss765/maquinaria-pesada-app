-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 25-05-2026 a las 16:40:10
-- Versión del servidor: 11.8.6-MariaDB-log
-- Versión de PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `u318851812_GESTIC`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `archivos_subidos`
--

CREATE TABLE `archivos_subidos` (
  `id` int(10) UNSIGNED NOT NULL,
  `usuario_id` varchar(100) DEFAULT NULL,
  `proyecto` varchar(150) DEFAULT NULL,
  `codigo` varchar(100) DEFAULT NULL,
  `nombre` varchar(150) DEFAULT NULL,
  `cantidad` decimal(10,2) DEFAULT NULL,
  `precio` decimal(12,2) DEFAULT NULL,
  `unidad` varchar(50) DEFAULT NULL,
  `nombre_original` varchar(255) NOT NULL,
  `nombre_guardado` varchar(255) NOT NULL,
  `extension` varchar(20) NOT NULL,
  `mime_type` varchar(150) NOT NULL,
  `tamano_bytes` int(10) UNSIGNED NOT NULL,
  `ruta_relativa` varchar(500) NOT NULL,
  `url_publica` varchar(500) NOT NULL,
  `fecha_subida` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `archivos_subidos`
--

INSERT INTO `archivos_subidos` (`id`, `usuario_id`, `proyecto`, `codigo`, `nombre`, `cantidad`, `precio`, `unidad`, `nombre_original`, `nombre_guardado`, `extension`, `mime_type`, `tamano_bytes`, `ruta_relativa`, `url_publica`, `fecha_subida`) VALUES
(1, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'f2.png', '20260413_105439_d65b4c7c_f2.png', 'png', 'image/png', 754572, 'uploads/2026/04/20260413_105439_d65b4c7c_f2.png', 'https://araucariasolar.org/uploads/2026/04/20260413_105439_d65b4c7c_f2.png', '2026-04-13 10:54:39'),
(2, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'f2.png', '20260413_105817_87ed0c6b_f2.png', 'png', 'image/png', 754572, 'uploads/2026/04/20260413_105817_87ed0c6b_f2.png', 'https://araucariasolar.org/uploads/2026/04/20260413_105817_87ed0c6b_f2.png', '2026-04-13 10:58:17'),
(3, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1776245842257.jpg', '20260415_093727_17d8e3c1_foto_1776245842257.jpg', 'jpg', 'image/jpeg', 179355, 'uploads/2026/04/20260415_093727_17d8e3c1_foto_1776245842257.jpg', 'https://araucariasolar.org/uploads/2026/04/20260415_093727_17d8e3c1_foto_1776245842257.jpg', '2026-04-15 09:37:27'),
(4, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1776416634799.jpg', '20260417_090412_2b0cf9fd_foto_1776416634799.jpg', 'jpg', 'image/jpeg', 7193583, 'uploads/2026/04/20260417_090412_2b0cf9fd_foto_1776416634799.jpg', 'https://araucariasolar.org/uploads/2026/04/20260417_090412_2b0cf9fd_foto_1776416634799.jpg', '2026-04-17 09:04:12'),
(5, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1776419530242.jpg', '20260417_095215_ec9f2763_foto_1776419530242.jpg', 'jpg', 'image/jpeg', 161509, 'uploads/2026/04/20260417_095215_ec9f2763_foto_1776419530242.jpg', 'https://araucariasolar.org/uploads/2026/04/20260417_095215_ec9f2763_foto_1776419530242.jpg', '2026-04-17 09:52:15'),
(6, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1777237863936.jpg', '20260426_211108_69bc2ae9_foto_1777237863936.jpg', 'jpg', 'image/jpeg', 1382324, 'uploads/2026/04/20260426_211108_69bc2ae9_foto_1777237863936.jpg', 'https://araucariasolar.org/uploads/2026/04/20260426_211108_69bc2ae9_foto_1777237863936.jpg', '2026-04-26 21:11:08'),
(7, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1777837543123.jpg', '20260503_194550_f550049d_foto_1777837543123.jpg', 'jpg', 'image/jpeg', 78949, 'uploads/2026/05/20260503_194550_f550049d_foto_1777837543123.jpg', 'https://araucariasolar.org/uploads/2026/05/20260503_194550_f550049d_foto_1777837543123.jpg', '2026-05-03 19:45:50'),
(8, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1778029758156.jpg', '20260506_010926_0d9857ca_foto_1778029758156.jpg', 'jpg', 'image/jpeg', 130631, 'uploads/2026/05/20260506_010926_0d9857ca_foto_1778029758156.jpg', 'https://araucariasolar.org/uploads/2026/05/20260506_010926_0d9857ca_foto_1778029758156.jpg', '2026-05-06 01:09:26'),
(9, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1778029851558.jpg', '20260506_011126_e84bccc0_foto_1778029851558.jpg', 'jpg', 'image/jpeg', 3552560, 'uploads/2026/05/20260506_011126_e84bccc0_foto_1778029851558.jpg', 'https://araucariasolar.org/uploads/2026/05/20260506_011126_e84bccc0_foto_1778029851558.jpg', '2026-05-06 01:11:26'),
(10, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1778030676523.jpg', '20260506_012556_f0a40266_foto_1778030676523.jpg', 'jpg', 'image/jpeg', 6519526, 'uploads/2026/05/20260506_012556_f0a40266_foto_1778030676523.jpg', 'https://araucariasolar.org/uploads/2026/05/20260506_012556_f0a40266_foto_1778030676523.jpg', '2026-05-06 01:25:56'),
(11, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1778075215221.jpg', '20260506_134932_9a27884a_foto_1778075215221.jpg', 'jpg', 'image/jpeg', 4736832, 'uploads/2026/05/20260506_134932_9a27884a_foto_1778075215221.jpg', 'https://araucariasolar.org/uploads/2026/05/20260506_134932_9a27884a_foto_1778075215221.jpg', '2026-05-06 13:49:32'),
(12, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1778075869040.jpg', '20260506_135800_dade0f0d_foto_1778075869040.jpg', 'jpg', 'image/jpeg', 4117265, 'uploads/2026/05/20260506_135800_dade0f0d_foto_1778075869040.jpg', 'https://araucariasolar.org/uploads/2026/05/20260506_135800_dade0f0d_foto_1778075869040.jpg', '2026-05-06 13:58:00'),
(13, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1778076153473.jpg', '20260506_140242_d5905bb2_foto_1778076153473.jpg', 'jpg', 'image/jpeg', 4321057, 'uploads/2026/05/20260506_140242_d5905bb2_foto_1778076153473.jpg', 'https://araucariasolar.org/uploads/2026/05/20260506_140242_d5905bb2_foto_1778076153473.jpg', '2026-05-06 14:02:42'),
(14, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1778076268270.jpg', '20260506_140438_77ca2d43_foto_1778076268270.jpg', 'jpg', 'image/jpeg', 3696179, 'uploads/2026/05/20260506_140438_77ca2d43_foto_1778076268270.jpg', 'https://araucariasolar.org/uploads/2026/05/20260506_140438_77ca2d43_foto_1778076268270.jpg', '2026-05-06 14:04:39'),
(15, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1778076360552.jpg', '20260506_140609_4e5f6a0b_foto_1778076360552.jpg', 'jpg', 'image/jpeg', 4011037, 'uploads/2026/05/20260506_140609_4e5f6a0b_foto_1778076360552.jpg', 'https://araucariasolar.org/uploads/2026/05/20260506_140609_4e5f6a0b_foto_1778076360552.jpg', '2026-05-06 14:06:09'),
(16, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1779068799290.jpg', '20260518_014717_7b870ab3_foto_1779068799290.jpg', 'jpg', 'image/jpeg', 1731604, 'uploads/2026/05/20260518_014717_7b870ab3_foto_1779068799290.jpg', 'https://araucariasolar.org/uploads/2026/05/20260518_014717_7b870ab3_foto_1779068799290.jpg', '2026-05-18 01:47:17'),
(17, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1779067280101.jpg', '20260518_014807_99d87ee2_foto_1779067280101.jpg', 'jpg', 'image/jpeg', 75335, 'uploads/2026/05/20260518_014807_99d87ee2_foto_1779067280101.jpg', 'https://araucariasolar.org/uploads/2026/05/20260518_014807_99d87ee2_foto_1779067280101.jpg', '2026-05-18 01:48:07'),
(18, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1779069355552.jpg', '20260518_015642_f55f6653_foto_1779069355552.jpg', 'jpg', 'image/jpeg', 1731604, 'uploads/2026/05/20260518_015642_f55f6653_foto_1779069355552.jpg', 'https://araucariasolar.org/uploads/2026/05/20260518_015642_f55f6653_foto_1779069355552.jpg', '2026-05-18 01:56:42'),
(19, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1779069494923.jpg', '20260518_015850_1a175cfd_foto_1779069494923.jpg', 'jpg', 'image/jpeg', 1731604, 'uploads/2026/05/20260518_015850_1a175cfd_foto_1779069494923.jpg', 'https://araucariasolar.org/uploads/2026/05/20260518_015850_1a175cfd_foto_1779069494923.jpg', '2026-05-18 01:58:50'),
(20, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1779154123150.jpg', '20260519_013030_b1a1a0b3_foto_1779154123150.jpg', 'jpg', 'image/jpeg', 5842823, 'uploads/2026/05/20260519_013030_b1a1a0b3_foto_1779154123150.jpg', 'https://araucariasolar.org/uploads/2026/05/20260519_013030_b1a1a0b3_foto_1779154123150.jpg', '2026-05-19 01:30:30'),
(21, '1', 'prueba', NULL, NULL, NULL, NULL, NULL, 'foto_1779157747127.jpg', '20260519_023016_994ab60c_foto_1779157747127.jpg', 'jpg', 'image/jpeg', 5695065, 'uploads/2026/05/20260519_023016_994ab60c_foto_1779157747127.jpg', 'https://araucariasolar.org/uploads/2026/05/20260519_023016_994ab60c_foto_1779157747127.jpg', '2026-05-19 02:30:16'),
(22, '1', 'prueba', 'GSTM0182430522', 'montacarga', 1.00, 30.00, '1', 'foto_1779198696427.jpg', '20260519_135144_add95153_foto_1779198696427.jpg', 'jpg', 'image/jpeg', 5861107, 'uploads/2026/05/20260519_135144_add95153_foto_1779198696427.jpg', 'https://araucariasolar.org/uploads/2026/05/20260519_135144_add95153_foto_1779198696427.jpg', '2026-05-19 13:51:44'),
(23, '1', 'prueba', 'GSTM0182320116', 'cargador', 1.00, 100.00, '1', 'foto_1779211359521.jpg', '20260519_172249_5c02b5bf_foto_1779211359521.jpg', 'jpg', 'image/jpeg', 5626796, 'uploads/2026/05/20260519_172249_5c02b5bf_foto_1779211359521.jpg', 'https://araucariasolar.org/uploads/2026/05/20260519_172249_5c02b5bf_foto_1779211359521.jpg', '2026-05-19 17:22:49'),
(24, '1', 'prueba', 'GSTM0182430522', 'montacarga', 2.00, 25000.00, '2', 'foto_1779220530800.jpg', '20260519_195536_bed82b95_foto_1779220530800.jpg', 'jpg', 'image/jpeg', 132491, 'uploads/2026/05/20260519_195536_bed82b95_foto_1779220530800.jpg', 'https://araucariasolar.org/uploads/2026/05/20260519_195536_bed82b95_foto_1779220530800.jpg', '2026-05-19 19:55:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `id` int(11) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `cargo` varchar(100) NOT NULL,
  `documento` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `es_admin` tinyint(1) DEFAULT 0,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id`, `nombres`, `apellidos`, `cargo`, `documento`, `contrasena`, `es_admin`, `fecha_creacion`) VALUES
(4, 'LUIS', 'LUIS', 'TECNICO', '0987654', '1234', 1, '2026-04-15 12:01:54'),
(5, 'Jesus', 'Jesus', 'Ingeniero ', '1065845765', '1234', 1, '2026-05-06 13:14:58'),
(110, 'Eduardo', 'Eduardo', 'sistema ', '26918556', '1234', 1, '2026-05-06 13:29:00'),
(112, 'Napoleón ', 'Napoleón ', 'Tecnico', '12487328', '1234', 0, '2026-05-06 14:44:22'),
(161, 'Jorge ', 'Jorge ', 'ingeniero ', '1003316086', '1234', 1, '2026-05-19 18:01:52'),
(183, 'Rubén arturo', 'Rubén arturo', 'tecnico', '1003315775', '123456', 0, '2026-05-19 19:52:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fallas_maquinas`
--

CREATE TABLE `fallas_maquinas` (
  `id_falla` int(11) NOT NULL,
  `id_maquina` int(11) DEFAULT NULL,
  `tipo_falla` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_falla` datetime DEFAULT current_timestamp(),
  `estado` varchar(30) DEFAULT 'ABIERTA',
  `tiempo_parada` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `fallas_maquinas`
--

INSERT INTO `fallas_maquinas` (`id_falla`, `id_maquina`, `tipo_falla`, `descripcion`, `fecha_falla`, `estado`, `tiempo_parada`) VALUES
(1, 1, 'Motor', 'Falla motor', '2026-05-24 20:52:57', 'ABIERTA', 0),
(2, 1, 'Hidráulico', 'Fuga aceite', '2026-05-24 20:52:57', 'ABIERTA', 0),
(3, 2, 'Eléctrica', 'Batería dañada', '2026-05-24 20:52:57', 'ABIERTA', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maquinas`
--

CREATE TABLE `maquinas` (
  `id_maquina` int(11) NOT NULL,
  `codigo` varchar(50) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `marca` varchar(100) DEFAULT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `estado` varchar(30) DEFAULT 'ACTIVA',
  `fecha_ingreso` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `maquinas`
--

INSERT INTO `maquinas` (`id_maquina`, `codigo`, `nombre`, `marca`, `tipo`, `estado`, `fecha_ingreso`) VALUES
(1, NULL, 'Excavadora CAT', NULL, NULL, 'ACTIVA', '2026-05-24 20:51:46'),
(2, NULL, 'Retroexcavadora JCB', NULL, NULL, 'ACTIVA', '2026-05-24 20:51:46'),
(3, NULL, 'Bulldozer Komatsu', NULL, NULL, 'ACTIVA', '2026-05-24 20:51:46');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `uso_maquinas`
--

CREATE TABLE `uso_maquinas` (
  `id_uso` int(11) NOT NULL,
  `id_maquina` int(11) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `hora_inicio` datetime DEFAULT NULL,
  `hora_fin` datetime DEFAULT NULL,
  `total_minutos` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `uso_maquinas`
--

INSERT INTO `uso_maquinas` (`id_uso`, `id_maquina`, `usuario`, `hora_inicio`, `hora_fin`, `total_minutos`) VALUES
(1, 1, 'Jesus', '2026-05-24 10:00:00', '2026-05-24 11:30:00', 90);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `archivos_subidos`
--
ALTER TABLE `archivos_subidos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `documento` (`documento`);

--
-- Indices de la tabla `fallas_maquinas`
--
ALTER TABLE `fallas_maquinas`
  ADD PRIMARY KEY (`id_falla`),
  ADD KEY `id_maquina` (`id_maquina`);

--
-- Indices de la tabla `maquinas`
--
ALTER TABLE `maquinas`
  ADD PRIMARY KEY (`id_maquina`),
  ADD UNIQUE KEY `codigo` (`codigo`);

--
-- Indices de la tabla `uso_maquinas`
--
ALTER TABLE `uso_maquinas`
  ADD PRIMARY KEY (`id_uso`),
  ADD KEY `id_maquina` (`id_maquina`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `archivos_subidos`
--
ALTER TABLE `archivos_subidos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=185;

--
-- AUTO_INCREMENT de la tabla `fallas_maquinas`
--
ALTER TABLE `fallas_maquinas`
  MODIFY `id_falla` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `maquinas`
--
ALTER TABLE `maquinas`
  MODIFY `id_maquina` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `uso_maquinas`
--
ALTER TABLE `uso_maquinas`
  MODIFY `id_uso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `fallas_maquinas`
--
ALTER TABLE `fallas_maquinas`
  ADD CONSTRAINT `fallas_maquinas_ibfk_1` FOREIGN KEY (`id_maquina`) REFERENCES `maquinas` (`id_maquina`);

--
-- Filtros para la tabla `uso_maquinas`
--
ALTER TABLE `uso_maquinas`
  ADD CONSTRAINT `uso_maquinas_ibfk_1` FOREIGN KEY (`id_maquina`) REFERENCES `maquinas` (`id_maquina`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
