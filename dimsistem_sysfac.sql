-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 12-07-2023 a las 21:46:38
-- Versión del servidor: 10.6.14-MariaDB-cll-lve
-- Versión de PHP: 8.1.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `dimsistem_sysfac`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`dimsistem`@`localhost` PROCEDURE `sp_getXmlFc` (IN `IdRegistro` INT)   BEGIN
    declare xmlFinal TEXT;
    declare comprobante TEXT;
    declare cuerpo TEXT;
    declare infoTributaria TEXT;
    declare infoFacturaP TEXT;
    declare infoFacturaImp TEXT;
    declare infoFacturaS TEXT;
    declare infoFacturaPagos TEXT;
    declare infoFactura TEXT;
    declare detallesP TEXT;
    declare detallesS TEXT;
    declare detalles TEXT;
    declare infoAdicional TEXT;

    SET xmlFinal = '';
    SET infoAdicional = '';
    SELECT concat('<ambiente>',e.Ambiente,'</ambiente>','<tipoEmision>',e.TipoEmision,'</tipoEmision>',
        '<razonSocial>',e.RazonSocial,'</razonSocial>',
        if(e.NombreComercial != '', concat('<nombreComercial>',e.NombreComercial,'</nombreComercial>') ,''),    
        '<ruc>',e.Identificacion,'</ruc>'
        '<claveAcceso>',vm.ClaveAcceso,'</claveAcceso>'
        '<codDoc>',c.Codigo,'</codDoc>',
        '<estab>',SUBSTR(vm.Serie, 1, 3),'</estab>',
        '<ptoEmi>',SUBSTR(vm.Serie, 4, 3),'</ptoEmi>'
        '<secuencial>',LPAD(vm.Secuencial,9,'0'),'</secuencial>'
        '<dirMatriz>',e.Direccion,'</dirMatriz>'
        , if(e.Microempresa = 'SI', concat('<regimenMicroempresas>CONTRIBUYENTE RÉGIMEN MICROEMPRESAS</regimenMicroempresas>') ,'')
        , if(e.RegimenRimpe = 'SI', concat('<contribuyenteRimpe>CONTRIBUYENTE RÉGIMEN RIMPE</contribuyenteRimpe>') ,'')
        , if(e.AgenteRetencion != '', concat('<agenteRetencion>', e.AgenteRetencion,'</agenteRetencion>') ,'')
        ) INTO infoTributaria
        FROM empresas e INNER JOIN ventasmaestro vm ON e.Id = vm.IdEmpresa
        INNER JOIN comprobantes c ON c.Id = vm.IdComprobante
        where vm.Id = IdRegistro;
        
    SELECT concat('<fechaEmision>',DATE_FORMAT(vm.fechaemision,'%d/%m/%Y'),'</fechaEmision>',
        IF(e.ContribuyenteEspecial != '', concat('<contribuyenteEspecial>',e.ContribuyenteEspecial,'</contribuyenteEspecial>'), '')
        ,'<obligadoContabilidad>',e.LlevaContabilidad,'</obligadoContabilidad>'
        ,'<tipoIdentificacionComprador>',ti.CodigoVenta,'</tipoIdentificacionComprador>'
        ,'<razonSocialComprador>',p.RazonSocial,'</razonSocialComprador>'
        ,'<identificacionComprador>',p.Identificacion,'</identificacionComprador>'
        ,'<direccionComprador>',concat((SELECT Nombre FROM ciudades WHERE Id = p.IdCiudad),'-',p.Direccion),'</direccionComprador>'
        ,'<totalSinImpuestos>',vm.SubTotal,'</totalSinImpuestos>'
        ,'<totalDescuento>',vm.Descuento,'</totalDescuento>') INTO infoFacturaP
        FROM empresas e INNER JOIN ventasmaestro vm ON e.Id = vm.IdEmpresa INNER JOIN comprobantes c ON c.Id = vm.IdComprobante
            INNER JOIN personas p ON p.Id = vm.IdPersona INNER JOIN tiposidentificacion ti ON p.IdTipoIdentificacion = ti.Id
        where vm.Id = IdRegistro;
    
    select GROUP_CONCAT(ce.totalImpuesto separator '')  INTO infoFacturaImp from (
        select ti.IdVentaMaestro,
        concat('<totalImpuesto><codigo>',ti.CodigoImpuesto,'</codigo>',
        '<codigoPorcentaje>',ti.CodigoSRI,'</codigoPorcentaje>',
        '<baseImponible>',round(SUM(ti.bi), 2),'</baseImponible>',
        '<tarifa>',ti.Porcentaje,'</tarifa>',
        '<valor>',round(SUM(ti.bi*(ti.Porcentaje/100)), 2),'</valor></totalImpuesto>') as totalImpuesto
        FROM (
            SELECT vd.IdVentaMaestro,
            SUBSTRING_INDEX(vd.CodigosSRIIVA,  '|' , 1 ) AS CodigoImpuesto,
            SUBSTRING_INDEX(vd.CodigosSRIIVA,  '|' , -1 ) AS CodigoSRI,
            vd.PorcentajeIVA as Porcentaje,
            ROUND((vd.Cantidad*vd.ValorUnitario-vd.Descuento+vd.ValorICE),2) AS bi, vd.ValorIVA as Valor
            FROM productos p INNER JOIN ventasdetalle vd ON vd.IdProducto = p.Id
                where vd.IdVentaMaestro = IdRegistro
            UNION ALL
            SELECT vd.IdVentaMaestro, 
            SUBSTRING_INDEX(vd.CodigosSRIICE,  '|' , 1 ) AS CodigoImpuesto,
            SUBSTRING_INDEX(vd.CodigosSRIICE,  '|' , -1 ) AS CodigoSRI,
            vd.PorcentajeICE as Porcentaje,
            ROUND((vd.Cantidad*vd.ValorUnitario-vd.Descuento),2) AS bi, ValorICE as Valor
            FROM productos p INNER JOIN ventasdetalle vd ON vd.IdProducto = p.Id
            where SUBSTRING_INDEX(vd.CodigosSRIICE,  '|' , 1 ) not in('null', '')
            and vd.IdVentaMaestro = IdRegistro
            UNION ALL
            SELECT vd.IdVentaMaestro, 
            SUBSTRING_INDEX(vd.CodigosSRIIRBPNR,  '|' , 1 ) AS CodigoImpuesto,
            SUBSTRING_INDEX(vd.CodigosSRIIRBPNR,  '|' , -1 ) AS CodigoSRI,
            vd.PorcentajeICE as Porcentaje,
            vd.Cantidad AS bi, ValorIRBPNR as Valor
            FROM productos p INNER JOIN ventasdetalle vd ON vd.IdProducto = p.Id
            where SUBSTRING_INDEX(vd.CodigosSRIIRBPNR,  '|' , 1 ) not in('null', '')
            and vd.IdVentaMaestro = IdRegistro
        ) AS ti
        GROUP BY ti.IdVentaMaestro, ti.CodigoImpuesto, ti.CodigoSRI, ti.Porcentaje
        order by ti.CodigoImpuesto
    ) as ce
    group by ce.IdVentaMaestro;

    SELECT concat('<propina>',vm.Propina,'</propina>'
        '<importeTotal>',vm.Total,'</importeTotal>'
        '<moneda>','DOLAR','</moneda>') INTO infoFacturaS
        FROM empresas e INNER JOIN ventasmaestro vm ON e.Id = vm.IdEmpresa INNER JOIN comprobantes c ON c.Id = vm.IdComprobante
            INNER JOIN personas p ON p.Id = vm.IdPersona INNER JOIN tiposidentificacion ti ON p.IdTipoIdentificacion = ti.Id
        where vm.Id = IdRegistro;
        
    SELECT GROUP_CONCAT(concat('<pago>',concat('<formaPago>',fp.CodigoSRI,'</formaPago>'), concat('<total>',vfp.Valor,'</total>'),
        IF(Plazo > 0, concat('<plazo>',Plazo,'</plazo>'), ''),
        IF(Tiempo != '', concat('<unidadTiempo>',Tiempo,'</unidadTiempo>'), ''), '</pago>') separator '') INTO infoFacturaPagos
        FROM ventamaestro_formapago vfp INNER JOIN formaspago fp ON fp.Id = vfp.IdVentaFormaPago
        WHERE vfp.IdVentaMaestro = IdRegistro;
        
    #SET xmlFinal = concat(infoTributaria, infoFacturaP, infoFacturaImp, infoFacturaS, infoFacturaPagos);

    select GROUP_CONCAT(
    concat('<detalle>',
        '<codigoPrincipal>',p.Codigo,'</codigoPrincipal>'
        , if(p.CodigoAuxiliar != '', concat('<codigoAuxiliar>',p.CodigoAuxiliar,'</codigoAuxiliar>'), '')
        , '<descripcion>',p.Nombre,'</descripcion>'
        , '<cantidad>',vd.Cantidad,'</cantidad>'
        , '<precioUnitario>',vd.ValorUnitario,'</precioUnitario>'
        , '<descuento>',vd.Descuento,'</descuento>'
        , '<precioTotalSinImpuesto>',ROUND((vd.Cantidad*vd.ValorUnitario-vd.Descuento),2),'</precioTotalSinImpuesto>',
        '<impuestos>',
    (
        select #impuestos
        GROUP_CONCAT(impuestos separator '') as imp
        from (
            SELECT imp.Id, imp.IdVentaMaestro, imp.IdProducto, GROUP_CONCAT(concat('<impuesto>', '<codigo>',imp.CodigoImpuesto,'</codigo>', '<codigoPorcentaje>',imp.CodigoSRI,'</codigoPorcentaje>',
            '<tarifa>',imp.Porcentaje,'</tarifa>', '<baseImponible>',imp.bi,'</baseImponible>', '<valor>',round((imp.bi*(imp.Porcentaje/100)), 2),'</valor>',
            '</impuesto>') SEPARATOR '') AS impuestos
                FROM (
                    SELECT vdi.Id, vdi.IdVentaMaestro, pi.Id as IdProducto, 
                        SUBSTRING_INDEX(vdi.CodigosSRIIVA,  '|' , 1 ) AS CodigoImpuesto,
                        SUBSTRING_INDEX(vdi.CodigosSRIIVA,  '|' , -1 ) AS CodigoSRI,
                        vdi.PorcentajeIVA as Porcentaje, 
                        ROUND((vdi.Cantidad*vdi.ValorUnitario-vdi.Descuento+vdi.ValorICE),2) AS bi, vdi.ValorIVA as Valor
                        FROM productos pi INNER JOIN ventasdetalle vdi ON vdi.IdProducto = pi.Id
                        WHERE vdi.IdVentaMaestro = IdRegistro
                    UNION ALL
                    SELECT vdi.Id, vdi.IdVentaMaestro, pi.Id as IdProducto, 
                        SUBSTRING_INDEX(vdi.CodigosSRIICE,  '|' , 1 ) AS CodigoImpuesto,
                        SUBSTRING_INDEX(vdi.CodigosSRIICE,  '|' , -1 ) AS CodigoSRI,
                        vdi.PorcentajeICE as Porcentaje, 
                        ROUND((vdi.Cantidad*vdi.ValorUnitario-vdi.Descuento),2) AS bi, vdi.ValorICE as Valor
                        FROM productos pi INNER JOIN ventasdetalle vdi ON vdi.IdProducto = pi.Id
                        WHERE SUBSTRING_INDEX(vdi.CodigosSRIICE,  '|' , 1 ) not in('null', '') and vdi.IdVentaMaestro = IdRegistro 
                    UNION ALL
                    SELECT vdi.Id, vdi.IdVentaMaestro, pi.Id as IdProducto,
                        SUBSTRING_INDEX(vdi.CodigosSRIIRBPNR,  '|' , 1 ) AS CodigoImpuesto,
                        SUBSTRING_INDEX(vdi.CodigosSRIIRBPNR,  '|' , -1 ) AS CodigoSRI,
                        vdi.PorcentajeICE as Porcentaje,
                        0 AS bi, vdi.ValorIRBPNR as Valor
                        FROM productos pi INNER JOIN ventasdetalle vdi ON vdi.IdProducto = pi.Id
                        WHERE SUBSTRING_INDEX(vdi.CodigosSRIIRBPNR,  '|' , 1 ) not in('null', '') and vdi.IdVentaMaestro = IdRegistro 
                ) AS imp 
                GROUP BY imp.Id, imp.IdProducto, imp.CodigoImpuesto, imp.CodigoSRI, imp.Porcentaje
            ) as i where i.IdVentaMaestro = IdRegistro and i.IdProducto = vd.IdProducto and i.Id = vd.Id
            GROUP BY i.Id, i.IdVentaMaestro, i.IdProducto
        ) 
    , '</impuestos>', '</detalle>') separator '') INTO detallesP
    from ventasdetalle vd INNER JOIN productos p ON p.Id = vd.IdProducto
    WHERE vd.IdVentaMaestro = IdRegistro 
    group by vd.IdVentaMaestro;

    SELECT GROUP_CONCAT(concat('<campoAdicional nombre="',vca.Nombre,'">',vca.Valor,'</campoAdicional>') separator '') INTO infoAdicional
        FROM ventamaestro_campoadicional vca
        WHERE vca.IdVentaMaestro = IdRegistro
        group by vca.IdVentaMaestro;

    SET infoTributaria = concat('<infoTributaria>',infoTributaria,'</infoTributaria>');
    SET infoFacturaImp = concat('<totalConImpuestos>',infoFacturaImp,'</totalConImpuestos>');
    SET infoFacturaPagos = concat('<pagos>',infoFacturaPagos,'</pagos>');
    SET infoFactura = concat('<infoFactura>',infoFacturaP, infoFacturaImp,infoFacturaS,infoFacturaPagos,'</infoFactura>');
    IF NOT strcmp(infoAdicional, '') = 0 THEN
        SET infoAdicional = concat('<infoAdicional>',infoAdicional,'</infoAdicional>');
    END IF;
    SET detalles = concat('<detalles>',detallesP,'</detalles>');
    SET xmlFinal = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>';

    SET cuerpo = concat(infoTributaria, infoFactura, detalles, infoAdicional);
    SET cuerpo = replace(cuerpo, '&', 'Y');
    SET comprobante = concat('<factura id="comprobante" version="1.1.0">',cuerpo,'</factura>');
    SET xmlFinal = concat(xmlFinal, replace(comprobante, '\n', ''));
    #SET xmlFinal = concat(infoTributaria, infoFacturaP, infoFacturaImp, infoFacturaS, infoFacturaPagos);
    update ventasmaestro set XmlOriginal = xmlFinal where Id = IdRegistro;
    SELECT xmlFinal;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ciudades`
--

CREATE TABLE `ciudades` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `IdProvincia` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ciudades`
--

INSERT INTO `ciudades` (`id`, `Nombre`, `IdProvincia`, `created_at`, `updated_at`) VALUES
(1, 'Cuenca', 2, NULL, NULL),
(2, 'Camilo Ponce Enríquez ', 2, NULL, NULL),
(3, 'Chordeleg', 2, NULL, NULL),
(4, 'El Pan', 2, NULL, NULL),
(5, 'Girón', 2, NULL, NULL),
(6, 'Guachapala', 2, NULL, NULL),
(7, 'Gualaceo', 2, NULL, NULL),
(8, 'Nabón', 2, NULL, NULL),
(9, 'Oña', 2, NULL, NULL),
(10, 'Paute', 2, NULL, NULL),
(11, 'Pucara', 2, NULL, NULL),
(12, 'San Fernando', 2, NULL, NULL),
(13, 'Santa Isabel', 2, NULL, NULL),
(14, 'Sevilla de Oro', 2, NULL, NULL),
(15, 'SígSig', 2, NULL, NULL),
(16, 'Guaranda', 3, NULL, NULL),
(17, 'Chimbo', 3, NULL, NULL),
(18, 'Echeandía', 3, NULL, NULL),
(19, 'San Miguel', 3, NULL, NULL),
(20, 'Chillanes', 3, NULL, NULL),
(21, 'Caluma', 3, NULL, NULL),
(22, 'Las Naves', 3, NULL, NULL),
(23, 'Azogues', 4, NULL, NULL),
(24, 'Cañar', 4, NULL, NULL),
(25, 'Biblián', 4, NULL, NULL),
(26, 'La Troncal', 4, NULL, NULL),
(27, 'El Tambo', 4, NULL, NULL),
(28, 'Déleg', 4, NULL, NULL),
(29, 'Suscal ', 4, NULL, NULL),
(30, 'Tulcán', 5, NULL, NULL),
(31, 'Espejo', 5, NULL, NULL),
(32, 'Montúfar', 5, NULL, NULL),
(33, 'Mira', 5, NULL, NULL),
(34, 'Bolívar', 5, NULL, NULL),
(35, 'San Pedro de Huaca', 5, NULL, NULL),
(36, 'Latacunga', 6, NULL, NULL),
(37, 'La Maná', 6, NULL, NULL),
(38, 'Pangua', 6, NULL, NULL),
(39, 'Pujilí', 6, NULL, NULL),
(40, 'Salcedo', 6, NULL, NULL),
(41, 'Saquisilí', 6, NULL, NULL),
(42, 'Sigchos', 6, NULL, NULL),
(43, 'Riobamba', 7, NULL, NULL),
(44, 'Alausí', 7, NULL, NULL),
(45, 'Colta', 7, NULL, NULL),
(46, 'Chunchi', 7, NULL, NULL),
(47, 'Guamote', 7, NULL, NULL),
(48, 'Guano', 7, NULL, NULL),
(49, 'Penipe', 7, NULL, NULL),
(50, 'Pallatanga', 7, NULL, NULL),
(51, 'Chambo', 7, NULL, NULL),
(52, 'Cumandá', 7, NULL, NULL),
(53, 'Ibarra', 8, NULL, NULL),
(54, 'Antonio Ante', 8, NULL, NULL),
(55, 'Otavalo', 8, NULL, NULL),
(56, 'Cotacachi', 8, NULL, NULL),
(57, 'Pimampiro', 8, NULL, NULL),
(58, 'San Miguel de Urcuquí', 8, NULL, NULL),
(59, 'Loja', 9, NULL, NULL),
(60, 'Macará', 9, NULL, NULL),
(61, 'Paltas', 9, NULL, NULL),
(62, 'Puyango', 9, NULL, NULL),
(63, 'Saraguro', 9, NULL, NULL),
(64, 'Celica', 9, NULL, NULL),
(65, 'Catamayo', 9, NULL, NULL),
(66, 'Espíndola', 9, NULL, NULL),
(67, 'Gonzanamá', 9, NULL, NULL),
(68, 'Sozoranga', 9, NULL, NULL),
(69, 'Zapotillo', 9, NULL, NULL),
(70, 'Calvas', 9, NULL, NULL),
(71, 'Chaguarpamba', 9, NULL, NULL),
(72, 'Olmedo', 9, NULL, NULL),
(73, 'Pindal', 9, NULL, NULL),
(74, 'Quilanga ', 9, NULL, NULL),
(75, 'Quito', 10, NULL, NULL),
(76, 'Cayambe', 10, NULL, NULL),
(77, 'Mejía', 10, NULL, NULL),
(78, 'Pedro Moncayo', 10, NULL, NULL),
(79, 'Pedro Vicente Maldonado', 10, NULL, NULL),
(80, 'Puerto Quito ', 10, NULL, NULL),
(81, 'Rumiñahui', 10, NULL, NULL),
(82, 'San Miguel de los Bancos', 10, NULL, NULL),
(83, 'Ambato', 1, NULL, NULL),
(84, 'Baños', 1, NULL, NULL),
(85, 'Cevallos', 1, NULL, NULL),
(86, 'Mocha', 1, NULL, NULL),
(87, 'Patate', 1, NULL, NULL),
(88, 'Quero', 1, NULL, NULL),
(89, 'San Pedro de Pelileo', 1, NULL, NULL),
(90, 'Santiago de Píllaro', 1, NULL, NULL),
(91, 'Tisaleo', 1, NULL, NULL),
(92, 'Santo Domingo', 11, NULL, NULL),
(93, 'Machala', 12, NULL, NULL),
(94, 'Arenillas', 12, NULL, NULL),
(95, 'Atahualpa', 12, NULL, NULL),
(96, 'El Guabo', 12, NULL, NULL),
(97, 'Huaquillas', 12, NULL, NULL),
(98, 'La Concordia ', 12, NULL, NULL),
(99, 'Marcabelí', 12, NULL, NULL),
(100, 'Pasaje', 12, NULL, NULL),
(101, 'Piñas', 12, NULL, NULL),
(102, 'Portovelo', 12, NULL, NULL),
(103, 'Rioverde', 12, NULL, NULL),
(104, 'Santa Rosa', 12, NULL, NULL),
(105, 'Zaruma', 12, NULL, NULL),
(106, 'Balsas', 12, NULL, NULL),
(107, 'Chilla', 12, NULL, NULL),
(108, 'Las Lajas', 12, NULL, NULL),
(109, 'Esmeraldas', 13, NULL, NULL),
(110, 'Eloy Alfaro', 13, NULL, NULL),
(111, 'Muisne', 13, NULL, NULL),
(112, 'Quinindé', 13, NULL, NULL),
(113, 'San Lorenzo', 13, NULL, NULL),
(114, 'Atacames', 13, NULL, NULL),
(115, 'Guayaquil', 14, NULL, NULL),
(116, 'Daule', 14, NULL, NULL),
(117, 'Durán', 14, NULL, NULL),
(118, 'Yaguachi', 14, NULL, NULL),
(119, 'Balzar', 14, NULL, NULL),
(120, 'Milagro', 14, NULL, NULL),
(121, 'Naranjal', 14, NULL, NULL),
(122, 'Samborondón', 14, NULL, NULL),
(123, 'El Triunfo', 14, NULL, NULL),
(124, 'Isidro Ayora', 14, NULL, NULL),
(125, 'Naranjito', 14, NULL, NULL),
(126, 'El Empalme', 14, NULL, NULL),
(127, 'Baquerizo Moreno', 14, NULL, NULL),
(128, 'Pedro Carbo', 14, NULL, NULL),
(129, 'Salitre', 14, NULL, NULL),
(130, 'Santa Lucía', 14, NULL, NULL),
(131, 'Palestina', 14, NULL, NULL),
(132, 'Balao', 14, NULL, NULL),
(133, 'Colimes', 14, NULL, NULL),
(134, 'Playas', 14, NULL, NULL),
(135, 'Simón Bolívar', 14, NULL, NULL),
(136, 'Coronel. Marcelino Maridueña', 14, NULL, NULL),
(137, 'Lomas de Sangentillo', 14, NULL, NULL),
(138, 'Nobol', 14, NULL, NULL),
(139, 'Babahoyo', 15, NULL, NULL),
(140, 'Baba', 15, NULL, NULL),
(141, 'Buena Fe', 15, NULL, NULL),
(142, 'Montalvo', 15, NULL, NULL),
(143, 'Puebloviejo', 15, NULL, NULL),
(144, 'Quevedo', 15, NULL, NULL),
(145, 'Quinsaloma', 15, NULL, NULL),
(146, 'Urdaneta', 15, NULL, NULL),
(147, 'Valencia', 15, NULL, NULL),
(148, 'Mocache', 15, NULL, NULL),
(149, 'Ventanas', 15, NULL, NULL),
(150, 'Vinces', 15, NULL, NULL),
(151, 'Palenque', 15, NULL, NULL),
(152, 'Portoviejo', 16, NULL, NULL),
(153, 'Bolívar', 16, NULL, NULL),
(154, 'Chone', 16, NULL, NULL),
(155, 'El Carmen', 16, NULL, NULL),
(156, 'Flavio Alfaro', 16, NULL, NULL),
(157, 'Jama', 16, NULL, NULL),
(158, 'Jaramijó', 16, NULL, NULL),
(159, 'Junín', 16, NULL, NULL),
(160, 'Jipijapa', 16, NULL, NULL),
(161, 'Manta', 16, NULL, NULL),
(162, 'Montecristi', 16, NULL, NULL),
(163, 'Olmedo', 16, NULL, NULL),
(164, 'Paján', 16, NULL, NULL),
(165, 'Pedernales', 16, NULL, NULL),
(166, 'Pichincha', 16, NULL, NULL),
(167, 'Puerto López ', 16, NULL, NULL),
(168, 'Rocafuerte', 16, NULL, NULL),
(169, 'San Vicente', 16, NULL, NULL),
(170, 'Santa Ana', 16, NULL, NULL),
(171, 'Sucre', 16, NULL, NULL),
(172, 'Tosagua', 16, NULL, NULL),
(173, '24 de mayo', 16, NULL, NULL),
(174, 'Santa Elena', 17, NULL, NULL),
(175, 'La Libertad', 17, NULL, NULL),
(176, 'Salinas', 17, NULL, NULL),
(177, 'Morona', 18, NULL, NULL),
(178, 'Gualaquiza', 18, NULL, NULL),
(179, 'Limón Indanza', 18, NULL, NULL),
(180, 'Logroño', 18, NULL, NULL),
(181, 'Pablo Sexto', 18, NULL, NULL),
(182, 'Palora', 18, NULL, NULL),
(183, 'Santiago', 18, NULL, NULL),
(184, 'Sucúa', 18, NULL, NULL),
(185, 'Huamboya', 18, NULL, NULL),
(186, 'San Juan Bosco', 18, NULL, NULL),
(187, 'Taisha', 18, NULL, NULL),
(188, 'Tiwintza', 18, NULL, NULL),
(189, 'Tena', 19, NULL, NULL),
(190, 'Archidona', 19, NULL, NULL),
(191, 'Carlos Julio Arosemena Tola ', 19, NULL, NULL),
(192, 'El Chaco', 19, NULL, NULL),
(193, 'Quijos', 19, NULL, NULL),
(194, 'Pastaza', 20, NULL, NULL),
(195, 'Arajuno', 20, NULL, NULL),
(196, 'Mera', 20, NULL, NULL),
(197, 'Santa Clara', 20, NULL, NULL),
(198, 'Zamora', 21, NULL, NULL),
(199, 'Chinchipe', 21, NULL, NULL),
(200, 'Nangaritza', 21, NULL, NULL),
(201, 'Palanda', 21, NULL, NULL),
(202, 'Paquisha', 21, NULL, NULL),
(203, 'Yacuambi', 21, NULL, NULL),
(204, 'Yantzaza', 21, NULL, NULL),
(205, 'El Pangui', 21, NULL, NULL),
(206, 'Centinela del Cóndor', 21, NULL, NULL),
(207, 'Lago Agrío', 23, NULL, NULL),
(208, 'Cuyabeno', 23, NULL, NULL),
(209, 'Gonzalo Pizarro', 23, NULL, NULL),
(210, 'Putumayo', 23, NULL, NULL),
(211, 'Shushufindi', 23, NULL, NULL),
(212, 'Sucumbíos', 23, NULL, NULL),
(213, 'Cascales', 23, NULL, NULL),
(214, 'Orellana', 23, NULL, NULL),
(215, 'Aguarico', 23, NULL, NULL),
(216, 'La Joya de los Sachas', 23, NULL, NULL),
(217, 'Loreto', 23, NULL, NULL),
(218, 'San Cristóbal: 5 islas', 24, NULL, NULL),
(219, 'Isabela: 4 islas', 24, NULL, NULL),
(220, 'Santa Cruz: 8 islas ', 24, NULL, NULL),
(221, 'Puyo', 20, NULL, NULL),
(222, 'La Concordia', 11, NULL, NULL),
(223, 'Santo Domingo', 11, NULL, NULL),
(224, 'Cascales', 22, NULL, NULL),
(225, 'Cuyabeno', 22, NULL, NULL),
(226, 'Gonzalo Pizarro', 22, NULL, NULL),
(227, 'Lago Agrio', 22, NULL, NULL),
(228, 'Putumayo', 22, NULL, NULL),
(229, 'Shushufindi', 22, NULL, NULL),
(230, 'Sucumbíos', 22, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comprobantes`
--

CREATE TABLE `comprobantes` (
  `Id` int(11) NOT NULL,
  `Identificador` varchar(3) NOT NULL,
  `Codigo` varchar(2) NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `Tributario` tinyint(4) NOT NULL DEFAULT 0,
  `NaturalezaCompras` char(1) NOT NULL,
  `NaturalezaVentas` char(1) NOT NULL,
  `Contabiliza` tinyint(4) NOT NULL,
  `Importacion` tinyint(4) NOT NULL DEFAULT 0,
  `IdEmpresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `comprobantes`
--

INSERT INTO `comprobantes` (`Id`, `Identificador`, `Codigo`, `Nombre`, `Tributario`, `NaturalezaCompras`, `NaturalezaVentas`, `Contabiliza`, `Importacion`, `IdEmpresa`) VALUES
(1, 'FC', '01', 'FACTURA', 1, 'H', 'D', 1, 1, 1),
(2, 'NV', '02', 'NOTA O BOLETA DE VENTA', 1, 'H', 'D', 1, 0, 1),
(3, 'LC', '03', 'LIQUIDACIÓN DE COMPRA DE BIENES O PRESTACIÓN DE SERVICIOS', 1, 'H', '', 1, 0, 1),
(4, 'NC', '04', 'NOTA DE CRÉDITO', 1, 'D', 'H', 1, 0, 1),
(5, 'ND', '05', 'NOTA DE DÉBITO', 1, 'H', 'D', 1, 0, 1),
(6, 'GR', '06', 'GUÍA DE REMISIÓN', 0, '', '', 0, 0, 1),
(7, 'CR', '07', 'COMPROBANTE DE RETENCIÓN', 1, 'D', 'H', 1, 0, 1),
(8, 'CZ', '80', 'COTIZACIÓN', 0, '', '', 0, 0, 1),
(9, 'SI', '81', 'SALDOS INICIALES', 0, 'H', 'D', 1, 0, 1),
(10, 'AP', '82', 'APORTE DE SOCIO', 0, 'H', 'D', 1, 0, 1),
(12, 'CVE', '15', 'COMPROBANTES DE VENTA EMITIDOS EN EL EXTERIOR', 0, 'H', 'D', 1, 1, 1),
(13, 'LQI', '', 'LIQUIDACIÓN DE IMPORTACIÓN', 0, '', '', 0, 1, 1),
(14, 'NTR', '83', 'COMPROBANTE NO TRIBUTARIO 	', 0, '', '', 0, 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresas`
--

CREATE TABLE `empresas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `RazonSocial` varchar(255) NOT NULL,
  `NombreComercial` varchar(255) DEFAULT NULL,
  `Identificacion` varchar(20) NOT NULL,
  `RutaLogo` varchar(255) DEFAULT NULL,
  `FechaIniActividad` date DEFAULT NULL,
  `Representante` varchar(100) DEFAULT NULL,
  `RucRepresentante` varchar(13) DEFAULT NULL,
  `Direccion` varchar(255) NOT NULL,
  `AgenteRetencion` varchar(30) DEFAULT NULL,
  `IvaVigente` double NOT NULL DEFAULT 12,
  `ArtesanoCalificado` varchar(20) DEFAULT NULL,
  `Microempresa` varchar(2) NOT NULL,
  `RegimenRimpe` varchar(2) NOT NULL,
  `NegocioPopular` varchar(2) NOT NULL,
  `LlevaContabilidad` varchar(2) NOT NULL,
  `Correo` varchar(60) NOT NULL,
  `Telefono` varchar(35) DEFAULT NULL,
  `Celular` varchar(35) DEFAULT NULL,
  `Contador` varchar(100) DEFAULT NULL,
  `RucContador` varchar(13) DEFAULT NULL,
  `Asistente` varchar(100) DEFAULT NULL,
  `RucAsistente` varchar(13) DEFAULT NULL,
  `TipoControlInventario` varchar(10) NOT NULL DEFAULT 'Periódico',
  `Ambiente` varchar(1) NOT NULL,
  `TipoEmision` varchar(1) NOT NULL,
  `ContribuyenteEspecial` varchar(13) DEFAULT NULL,
  `RutaFirma` varchar(255) DEFAULT NULL,
  `ContraseniaFirma` varchar(255) DEFAULT NULL,
  `CodigoNumerico` varchar(8) DEFAULT NULL,
  `SMTPUsuario` varchar(80) DEFAULT NULL,
  `SMTPServidor` varchar(100) DEFAULT NULL,
  `SMTPContrasenia` varchar(100) DEFAULT NULL,
  `SMTPPuerto` varchar(5) DEFAULT NULL,
  `CorreoAsunto` varchar(255) DEFAULT NULL,
  `CorreoMensajeHTML` mediumtext DEFAULT NULL,
  `IdProvincia` bigint(20) UNSIGNED NOT NULL,
  `IdCiudad` bigint(20) UNSIGNED NOT NULL,
  `NumeroAsiento` bigint(20) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `empresas`
--

INSERT INTO `empresas` (`id`, `RazonSocial`, `NombreComercial`, `Identificacion`, `RutaLogo`, `FechaIniActividad`, `Representante`, `RucRepresentante`, `Direccion`, `AgenteRetencion`, `IvaVigente`, `ArtesanoCalificado`, `Microempresa`, `RegimenRimpe`, `NegocioPopular`, `LlevaContabilidad`, `Correo`, `Telefono`, `Celular`, `Contador`, `RucContador`, `Asistente`, `RucAsistente`, `TipoControlInventario`, `Ambiente`, `TipoEmision`, `ContribuyenteEspecial`, `RutaFirma`, `ContraseniaFirma`, `CodigoNumerico`, `SMTPUsuario`, `SMTPServidor`, `SMTPContrasenia`, `SMTPPuerto`, `CorreoAsunto`, `CorreoMensajeHTML`, `IdProvincia`, `IdCiudad`, `NumeroAsiento`) VALUES
(1, 'SOFT', 'SISFACT', '1804003497001', 'logoSistfac.jpg', '2019-11-12', 'IBARRA TORRES OSCAR FERNANDO', '1804003497', 'SAN FRANCISCO / ELOY ALFARO 01-23 Y LIZARDO RUIZ', '', 12, '', 'NO', 'NO', 'NO', 'NO', 'dimsistem@gmail.com', '032829075', '0984959580', 'ALMENDARIZ PROAÑO JUANA PATRICIA', '1801676667', NULL, NULL, 'Periódico', '1', '1', '', 'OSCAR.p12', 'Ofit1985', '19862012', 'admin@dimsistem.com', 'mail.dimsistem.com', '099010Correo', '26', 'DOCUMENTOS ELECTRONICOS FACELECT', '<!DOCTYPE html><html><head><meta charset=\"UTF-8\"></head><body><center><p>Estimado(a):<br/><hr><h3>@RazonSocialPersona@, </h3><hr><strong>@RazonSocialEmpresa@</strong> le comunica que su comprobantente electrónico <strong>@Comprobante@</strong> con número <strong>@NumeroComprobante@</strong> ha sido generado y autorizado con éxito y esta adjunto para su descarga.<br/><p style=\"color:#FEBF39\">Para información, dudas o servicio, escribanos a admin@dimsistem.com.ec o contáctenos al teléfono 0990592339</p><p style=\"color:#FEBF39\">AMBATO-ECUADOR</p><hr><p><small>El presente mensaje puede contener información privilegiada o confidencial. Si usted no es el destinatario indicado, se le notifica que, la utilización, divulgación y/o copia de documentos sin autorización, está prohibida en virtud de la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos vigente. Si ha recibido este mensaje por error, solicitamos nos comunique por esta misma vía y proceda a su eliminación del mensaje</small></p><hr></center></body></html>', 1, 83, 861);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `establecimientos`
--

CREATE TABLE `establecimientos` (
  `Id` int(11) NOT NULL,
  `Estab` varchar(3) NOT NULL,
  `PuntoEmision` varchar(3) NOT NULL,
  `Direccion` varchar(255) NOT NULL,
  `SecuenciaAP` bigint(20) NOT NULL,
  `SecuenciaFC` int(11) NOT NULL,
  `SecuenciaLC` int(11) NOT NULL,
  `SecuenciaNC` int(11) NOT NULL,
  `SecuenciaND` int(11) NOT NULL,
  `SecuenciaGR` int(11) NOT NULL,
  `SecuenciaCR` int(11) NOT NULL,
  `SecuenciaCZ` int(11) NOT NULL,
  `SecuenciaIMP` bigint(20) NOT NULL DEFAULT 0,
  `SecuenciaAsiento` int(11) NOT NULL,
  `SecuenciaIngreso` int(11) NOT NULL,
  `SecuenciaEgreso` int(11) NOT NULL,
  `SecuenciaDiario` int(11) NOT NULL,
  `EnviarCorreo` tinyint(4) NOT NULL,
  `ImpresionAutomatica` tinyint(4) NOT NULL,
  `Electronico` tinyint(4) NOT NULL,
  `IdEmpresa` int(11) NOT NULL,
  `IdProvincia` int(11) NOT NULL,
  `IdCiudad` int(11) NOT NULL,
  `RutaLogo` varchar(255) DEFAULT NULL,
  `ConsumidorFinalDefecto` tinyint(4) NOT NULL,
  `Ats` tinyint(4) NOT NULL DEFAULT 1,
  `Nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `establecimientos`
--

INSERT INTO `establecimientos` (`Id`, `Estab`, `PuntoEmision`, `Direccion`, `SecuenciaAP`, `SecuenciaFC`, `SecuenciaLC`, `SecuenciaNC`, `SecuenciaND`, `SecuenciaGR`, `SecuenciaCR`, `SecuenciaCZ`, `SecuenciaIMP`, `SecuenciaAsiento`, `SecuenciaIngreso`, `SecuenciaEgreso`, `SecuenciaDiario`, `EnviarCorreo`, `ImpresionAutomatica`, `Electronico`, `IdEmpresa`, `IdProvincia`, `IdCiudad`, `RutaLogo`, `ConsumidorFinalDefecto`, `Ats`, `Nombre`) VALUES
(1, '001', '001', 'SAN FRANCISCO / ELOY ALFARO 01-23 Y LIZARDO RUIZ', 0, 6, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 220, 1, 1, 1, 1, 1, 83, 'logoSistfac.jpg', 0, 1, ''),
(2, '001', '002', 'SAN FRANCISCO / ELOY ALFARO 01-23 Y LIZARDO RUIZ', 233, 231, 4, 5, 0, 0, 106, 27, 0, 2, 104, 150, 149, 1, 1, 1, 1, 1, 83, 'logoSistfac.jpg', 1, 1, ''),
(4, '001', '003', 'Cevallos', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 85, 'logoSistfac.jpg', 1, 0, '0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formaspago`
--

CREATE TABLE `formaspago` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Predefinida` tinyint(4) NOT NULL,
  `Vigente` tinyint(4) NOT NULL,
  `CodigoSRI` varchar(2) NOT NULL,
  `TipoPago` varchar(1) NOT NULL,
  `IdEmpresa` bigint(20) UNSIGNED NOT NULL,
  `IdCuenta` bigint(20) UNSIGNED NOT NULL,
  `IdEstablecimiento` bigint(20) UNSIGNED NOT NULL,
  `IdEfectivoEquivalente` bigint(20) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `formaspago`
--

INSERT INTO `formaspago` (`id`, `Nombre`, `Predefinida`, `Vigente`, `CodigoSRI`, `TipoPago`, `IdEmpresa`, `IdCuenta`, `IdEstablecimiento`, `IdEfectivoEquivalente`) VALUES
(1, 'EFECTIVO-SIN UTILIZACION DEL SISTEMA FINANCIERO', 1, 1, '01', 'E', 1, 185, 1, 4),
(2, 'TARJETA DE CRÉDITO', 0, 1, '19', 'C', 1, 5, 1, 1),
(3, 'COMPENSACION DE DEUDAS', 0, 1, '15', 'C', 1, 5, 1, 1),
(4, 'TARJETA DE DEBITO', 0, 1, '16', 'C', 1, 5, 1, 2),
(5, 'DINERO ELECTRONICO', 0, 1, '17', 'E', 1, 5, 1, 4),
(6, 'TARJETA PREPAGO', 0, 1, '18', 'C', 1, 5, 1, 1),
(7, 'OTROS CON UTILIZACION DEL SISTEMA FINANCIERO', 0, 1, '20', 'C', 1, 5, 1, 2),
(8, 'ENDOSOS DE TITULOS', 0, 1, '21', 'C', 1, 5, 1, 1),
(11, 'EFECTIVO-SIN UTILIZACION DEL SISTEMA FINANCIERO', 0, 1, '01', 'E', 1, 185, 2, 4),
(12, 'TARJETA DE CRÉDITO', 0, 1, '19', 'C', 1, 5, 2, 1),
(13, 'COMPENSACION DE DEUDAS', 0, 1, '15', 'C', 1, 5, 2, 1),
(14, 'TARJETA DE DEBITO', 0, 1, '16', 'C', 1, 5, 2, 2),
(15, 'DINERO ELECTRONICO', 0, 1, '17', 'E', 1, 5, 2, 4),
(16, 'TARJETA PREPAGO', 0, 1, '18', 'C', 1, 5, 2, 1),
(17, 'OTROS CON UTILIZACION DEL SISTEMA FINANCIERO', 1, 1, '20', 'C', 1, 5, 2, 2),
(18, 'ENDOSOS DE TITULOS', 0, 1, '21', 'C', 1, 5, 2, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(2, '2023_07_09_021224_create_empresas_table', 1),
(3, '2023_07_10_002354_create_ciudades_table', 2),
(4, '2014_10_12_000000_create_users_table', 3),
(5, '2014_10_12_100000_create_password_resets_table', 3),
(6, '2019_08_19_000000_create_failed_jobs_table', 3),
(7, '2023_07_11_034216_create_provincias_table', 3),
(8, '2023_07_11_040138_create_ciudades_table', 4),
(9, '2023_07_11_041636_create_empresas_table', 5),
(10, '2023_07_11_043031_create_formaspago_table', 6),
(11, '2023_07_11_043954_create_personas_table', 7),
(12, '2023_07_11_045729_create_productos_table', 8),
(13, '2023_07_11_050530_create_ventasmaestro_table', 9),
(14, '2023_07_11_053928_create_ventamaestro_campoadicional_table', 10),
(15, '2023_07_11_054700_create_ventamaestro_formapago_table', 11),
(16, '2023_07_11_055354_create_ventasdetalle_table', 12),
(17, '2023_07_12_213826_create_vendedores_table', 13);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(191) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

CREATE TABLE `personas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `RazonSocial` varchar(255) NOT NULL,
  `NombreComercial` varchar(255) DEFAULT NULL,
  `Identificacion` varchar(20) NOT NULL,
  `Correo` varchar(100) DEFAULT NULL,
  `Direccion` varchar(255) NOT NULL,
  `Telefono` varchar(25) DEFAULT NULL,
  `Celular` varchar(25) DEFAULT NULL,
  `IdRolPersona` bigint(20) UNSIGNED NOT NULL,
  `Rol` varchar(10) NOT NULL,
  `AgenteRetencion` tinyint(1) NOT NULL,
  `Microempresa` tinyint(1) NOT NULL DEFAULT 0,
  `TipoRegimen` varchar(20) NOT NULL,
  `CodigoReferencia` varchar(100) DEFAULT NULL,
  `InfoAdicional` varchar(100) DEFAULT NULL,
  `IdProvincia` bigint(20) UNSIGNED NOT NULL,
  `IdCiudad` bigint(20) UNSIGNED NOT NULL,
  `IdTipoIdentificacion` bigint(20) UNSIGNED NOT NULL,
  `IdEmpresa` bigint(20) UNSIGNED NOT NULL,
  `IdTipoContribuyente` bigint(20) UNSIGNED NOT NULL,
  `IdCuenta` bigint(20) UNSIGNED DEFAULT NULL,
  `IdConceptoRetencionFuente` bigint(20) UNSIGNED DEFAULT NULL,
  `IdConceptoRetencionIva` bigint(20) UNSIGNED DEFAULT NULL,
  `IdCuentaGasto` bigint(20) UNSIGNED DEFAULT NULL,
  `IdCuentaIva` bigint(20) UNSIGNED DEFAULT NULL,
  `IdVendedor` bigint(20) UNSIGNED DEFAULT NULL,
  `IdGrupoPersona` bigint(20) UNSIGNED NOT NULL,
  `ParteRelacional` varchar(2) NOT NULL DEFAULT 'NO',
  `IdTipoPago` bigint(20) UNSIGNED DEFAULT NULL,
  `CodigoTipoPago` varchar(3) DEFAULT NULL,
  `Activo` tinyint(4) NOT NULL DEFAULT 1,
  `FechaInicio` date DEFAULT NULL,
  `FechaFin` date DEFAULT NULL,
  `Membresia` tinyint(4) NOT NULL DEFAULT 0,
  `Periocidad` varchar(13) NOT NULL DEFAULT 'Personalizada',
  `Periodo` int(11) NOT NULL,
  `LimiteCredito` decimal(18,2) NOT NULL DEFAULT 0.00,
  `FechaCreacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `personas`
--

INSERT INTO `personas` (`id`, `RazonSocial`, `NombreComercial`, `Identificacion`, `Correo`, `Direccion`, `Telefono`, `Celular`, `IdRolPersona`, `Rol`, `AgenteRetencion`, `Microempresa`, `TipoRegimen`, `CodigoReferencia`, `InfoAdicional`, `IdProvincia`, `IdCiudad`, `IdTipoIdentificacion`, `IdEmpresa`, `IdTipoContribuyente`, `IdCuenta`, `IdConceptoRetencionFuente`, `IdConceptoRetencionIva`, `IdCuentaGasto`, `IdCuentaIva`, `IdVendedor`, `IdGrupoPersona`, `ParteRelacional`, `IdTipoPago`, `CodigoTipoPago`, `Activo`, `FechaInicio`, `FechaFin`, `Membresia`, `Periocidad`, `Periodo`, `LimiteCredito`, `FechaCreacion`) VALUES
(1, 'Villacres Chico S.A', 'Esthefanias Discoteck', '1804816104', 'esthefaniavillacres@gmail.com', 'Quero', NULL, '0990592339', 1, 'Cliente', 0, 0, 'RG', NULL, NULL, 1, 88, 1, 1, 1, 1, 1, NULL, NULL, NULL, 1, 1, 'NO', NULL, NULL, 1, NULL, NULL, 0, 'Personalizada', 0, 0.00, '2023-07-12 23:47:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `Id` int(10) UNSIGNED NOT NULL,
  `Codigo` varchar(25) NOT NULL,
  `CodigoAuxiliar` varchar(25) DEFAULT NULL,
  `Nombre` varchar(255) NOT NULL,
  `IdUnidadMedida` bigint(20) UNSIGNED NOT NULL,
  `UnidadMedida` varchar(100) DEFAULT NULL,
  `Marca` varchar(100) DEFAULT NULL,
  `Modelo` varchar(100) DEFAULT NULL,
  `Grupo` varchar(100) DEFAULT NULL,
  `Conversion` varchar(50) DEFAULT NULL,
  `InfoAdicional` varchar(255) DEFAULT NULL,
  `Existencia` decimal(18,6) DEFAULT NULL,
  `Precio` double(20,6) NOT NULL,
  `Precio2` double(20,6) DEFAULT NULL,
  `Precio3` double(20,6) DEFAULT NULL,
  `PrecioSinSubsidio` double(20,6) DEFAULT NULL,
  `CostoUnitario` double(20,6) NOT NULL DEFAULT 0.000000,
  `Ubicacion` varchar(100) DEFAULT NULL,
  `RutaImagen` varchar(255) DEFAULT NULL,
  `Activo` int(11) NOT NULL DEFAULT 1,
  `IdCategoria` int(11) NOT NULL,
  `IdBodega` int(11) NOT NULL,
  `IdTarifaImpuestoICE` int(11) DEFAULT NULL,
  `IdTarifaImpuestoIVA` int(11) NOT NULL,
  `IdTarifaImpuestoIVACompra` int(11) NOT NULL,
  `IdTarifaImpuestoIRBPNR` int(11) DEFAULT NULL,
  `IdEmpresa` int(11) NOT NULL,
  `FechaCreacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`Id`, `Codigo`, `CodigoAuxiliar`, `Nombre`, `IdUnidadMedida`, `UnidadMedida`, `Marca`, `Modelo`, `Grupo`, `Conversion`, `InfoAdicional`, `Existencia`, `Precio`, `Precio2`, `Precio3`, `PrecioSinSubsidio`, `CostoUnitario`, `Ubicacion`, `RutaImagen`, `Activo`, `IdCategoria`, `IdBodega`, `IdTarifaImpuestoICE`, `IdTarifaImpuestoIVA`, `IdTarifaImpuestoIVACompra`, `IdTarifaImpuestoIRBPNR`, `IdEmpresa`, `FechaCreacion`) VALUES
(1, 'PR01', '1233231651658', 'Chocolates', 1, 'und', 'Nestle', 'paquete', 'Dulces', NULL, NULL, NULL, 10.500000, NULL, NULL, NULL, 5.000000, NULL, NULL, 1, 1, 1, 1, 2, 1, 1, 1, '2023-07-12 23:16:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provincias`
--

CREATE TABLE `provincias` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `CodigoArea` varchar(2) NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `provincias`
--

INSERT INTO `provincias` (`id`, `CodigoArea`, `Nombre`, `created_at`, `updated_at`) VALUES
(1, '18', 'Tungurahua', NULL, NULL),
(2, '01', 'Azuay', NULL, NULL),
(3, '02', 'Bolívar', NULL, NULL),
(4, '03', 'Cañar', NULL, NULL),
(5, '04', 'Carchi', NULL, NULL),
(6, '05', 'Cotopaxi', NULL, NULL),
(7, '06', 'Chimborazo', NULL, NULL),
(8, '10', 'Imbabura', NULL, NULL),
(9, '11', 'Loja', NULL, NULL),
(10, '17', 'Pichincha', NULL, NULL),
(11, '23', 'Santo Domingo de los Tsachilas', NULL, NULL),
(12, '07', 'El Oro', NULL, NULL),
(13, '08', 'Esmeraldas', NULL, NULL),
(14, '09', 'Guayas', NULL, NULL),
(15, '12', 'Los Ríos', NULL, NULL),
(16, '13', 'Manabí', NULL, NULL),
(17, '24', 'Santa Elena', NULL, NULL),
(18, '14', 'Morona Santiago', NULL, NULL),
(19, '15', 'Napo', NULL, NULL),
(20, '16', 'Pastaza', NULL, NULL),
(21, '19', 'Zamora', NULL, NULL),
(22, '21', 'Sucumbíos', NULL, NULL),
(23, '22', 'Orellana', NULL, NULL),
(24, '20', 'Galápagos', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarifasimpuestoiva`
--

CREATE TABLE `tarifasimpuestoiva` (
  `Id` int(11) NOT NULL,
  `CodigoSRI` varchar(4) NOT NULL,
  `Porcentaje` decimal(18,2) NOT NULL,
  `Descripcion` varchar(100) NOT NULL,
  `Impuesto` varchar(20) NOT NULL,
  `CodigoImpuesto` int(11) NOT NULL,
  `AplicaATransporte` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tarifasimpuestoiva`
--

INSERT INTO `tarifasimpuestoiva` (`Id`, `CodigoSRI`, `Porcentaje`, `Descripcion`, `Impuesto`, `CodigoImpuesto`, `AplicaATransporte`) VALUES
(1, '0', 0.00, 'IVA 0', 'IVA', 2, 1),
(2, '2', 12.00, 'IVA 12', 'IVA', 2, 1),
(3, '3', 14.00, 'IVA 14', 'IVA', 2, 0),
(4, '6', 0.00, 'No Objeto de Impuesto', 'IVA', 2, 0),
(5, '7', 0.00, 'Exento de IVA', 'IVA', 2, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tiposidentificacion`
--

CREATE TABLE `tiposidentificacion` (
  `Id` int(11) NOT NULL,
  `CodigoCompra` varchar(2) NOT NULL,
  `CodigoVenta` varchar(2) NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `ValidaDocumento` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tiposidentificacion`
--

INSERT INTO `tiposidentificacion` (`Id`, `CodigoCompra`, `CodigoVenta`, `Nombre`, `ValidaDocumento`) VALUES
(1, '02', '05', 'Cédula', 1),
(2, '01', '04', 'RUC', 1),
(3, '03', '06', 'Pasaporte', 0),
(4, '00', '07', 'Consumidor Final', 0),
(5, '03', '08', 'Identificación del Exterior', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vendedores`
--

CREATE TABLE `vendedores` (
  `Id` int(10) UNSIGNED NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `Apellido` varchar(255) NOT NULL,
  `Usuario` varchar(255) NOT NULL,
  `Contraseña` varchar(255) NOT NULL,
  `CorreoElectronico` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `vendedores`
--

INSERT INTO `vendedores` (`Id`, `Nombre`, `Apellido`, `Usuario`, `Contraseña`, `CorreoElectronico`) VALUES
(1, 'Esthefania', 'Villacres', 'esthefania', 'Esthefania20', 'esthefaniavillacres@gmail.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventamaestro_campoadicional`
--

CREATE TABLE `ventamaestro_campoadicional` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `Nombre` varchar(45) NOT NULL,
  `Valor` varchar(255) NOT NULL,
  `IdVentaMaestro` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventamaestro_formapago`
--

CREATE TABLE `ventamaestro_formapago` (
  `Id` int(10) UNSIGNED NOT NULL,
  `Valor` decimal(18,2) NOT NULL,
  `Plazo` varchar(255) DEFAULT NULL,
  `Tiempo` varchar(255) DEFAULT NULL,
  `Observacion` varchar(255) DEFAULT NULL,
  `CodigoSRI` varchar(2) NOT NULL,
  `Tarjeta` varchar(255) DEFAULT NULL,
  `TipoTarjeta` varchar(255) DEFAULT NULL,
  `Referencia` varchar(255) DEFAULT NULL,
  `Meses` int(11) DEFAULT NULL,
  `IdVentaMaestro` int(11) NOT NULL,
  `IdVentaFormaPago` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ventamaestro_formapago`
--

INSERT INTO `ventamaestro_formapago` (`Id`, `Valor`, `Plazo`, `Tiempo`, `Observacion`, `CodigoSRI`, `Tarjeta`, `TipoTarjeta`, `Referencia`, `Meses`, `IdVentaMaestro`, `IdVentaFormaPago`) VALUES
(1, 11.76, NULL, NULL, NULL, '20', NULL, NULL, NULL, NULL, 1, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventasdetalle`
--

CREATE TABLE `ventasdetalle` (
  `Id` int(10) UNSIGNED NOT NULL,
  `Cantidad` double(20,6) NOT NULL,
  `ValorUnitario` double(20,6) NOT NULL,
  `Descuento` double(18,2) NOT NULL,
  `PorcentajeDescuento` double(18,4) NOT NULL DEFAULT 0.0000,
  `CodigosSRIICE` varchar(10) NOT NULL,
  `PorcentajeICE` double(18,2) NOT NULL,
  `ValorICE` double(18,2) NOT NULL DEFAULT 0.00,
  `CodigosSRIIVA` varchar(10) NOT NULL,
  `PorcentajeIVA` double(18,2) NOT NULL,
  `ValorIVA` double(18,2) NOT NULL,
  `SubTotalLinea` double(18,2) NOT NULL,
  `CodigosSRIIRBPNR` varchar(10) NOT NULL,
  `PorcentajeIRBPNR` double(18,2) NOT NULL,
  `ValorIRBPNR` double(18,2) NOT NULL DEFAULT 0.00,
  `Estado` varchar(3) NOT NULL DEFAULT 'ACT',
  `VUFinal` double(20,6) NOT NULL,
  `CostoUnitario` double(20,6) NOT NULL DEFAULT 0.000000,
  `CostoTotal` double(18,2) NOT NULL DEFAULT 0.00,
  `SubsidioUnitario` double(20,6) NOT NULL DEFAULT 0.000000,
  `PrecioSinSubsidio` double(20,6) NOT NULL DEFAULT 0.000000,
  `TotalSinSubsidio` double(18,2) NOT NULL DEFAULT 0.00,
  `TotalAhorroSubsidio` double(18,2) NOT NULL DEFAULT 0.00,
  `IdProducto` int(11) NOT NULL,
  `IdVentaMaestro` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ventasdetalle`
--

INSERT INTO `ventasdetalle` (`Id`, `Cantidad`, `ValorUnitario`, `Descuento`, `PorcentajeDescuento`, `CodigosSRIICE`, `PorcentajeICE`, `ValorICE`, `CodigosSRIIVA`, `PorcentajeIVA`, `ValorIVA`, `SubTotalLinea`, `CodigosSRIIRBPNR`, `PorcentajeIRBPNR`, `ValorIRBPNR`, `Estado`, `VUFinal`, `CostoUnitario`, `CostoTotal`, `SubsidioUnitario`, `PrecioSinSubsidio`, `TotalSinSubsidio`, `TotalAhorroSubsidio`, `IdProducto`, `IdVentaMaestro`, `created_at`, `updated_at`) VALUES
(1, 1.000000, 10.500000, 0.00, 0.0000, '1', 0.00, 0.00, '1', 12.00, 1.26, 10.50, '0', 0.00, 0.00, 'ACT', 11.260000, 0.000000, 0.00, 0.000000, 0.000000, 0.00, 0.00, 1, 1, '2023-07-13 04:12:41', '2023-07-13 04:12:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventasmaestro`
--

CREATE TABLE `ventasmaestro` (
  `Id` int(10) UNSIGNED NOT NULL,
  `FechaEmision` date NOT NULL,
  `FechaVencimiento` date NOT NULL,
  `Serie` varchar(6) NOT NULL,
  `Secuencial` int(11) NOT NULL,
  `ClaveAcceso` varchar(49) DEFAULT NULL,
  `BaseIVA0` decimal(18,2) NOT NULL DEFAULT 0.00,
  `BaseIVA` decimal(18,2) NOT NULL DEFAULT 0.00,
  `BaseNoIVA` decimal(18,2) NOT NULL DEFAULT 0.00,
  `MontoICE` decimal(18,2) NOT NULL DEFAULT 0.00,
  `ValorIRBPNR` decimal(18,2) NOT NULL DEFAULT 0.00,
  `ExentoIVA` decimal(18,2) NOT NULL DEFAULT 0.00,
  `Propina` decimal(18,2) NOT NULL DEFAULT 0.00,
  `Descuento` decimal(18,2) NOT NULL DEFAULT 0.00,
  `DescuentoPorcentaje` tinyint(4) NOT NULL,
  `SubTotal` decimal(18,2) NOT NULL,
  `ValorIVA` decimal(18,2) NOT NULL,
  `Total` decimal(18,2) NOT NULL,
  `PorcentajePropina` decimal(18,2) DEFAULT NULL,
  `OtroValor` decimal(18,2) NOT NULL DEFAULT 0.00,
  `Comentario1` varchar(255) DEFAULT NULL,
  `Comentario2` varchar(255) DEFAULT NULL,
  `Comentario3` varchar(255) DEFAULT NULL,
  `XmlOriginal` longtext DEFAULT NULL,
  `EstadoSRI` varchar(255) DEFAULT NULL,
  `NumeroAutorizacion` varchar(49) DEFAULT NULL,
  `MensajeSRI` mediumtext DEFAULT NULL,
  `FechaAutorizacion` datetime DEFAULT NULL,
  `CorreoEnviado` varchar(2) DEFAULT NULL,
  `TipoComprobante` varchar(10) NOT NULL,
  `NumeroComprobante` int(11) NOT NULL,
  `Estado` varchar(3) NOT NULL DEFAULT 'ACT',
  `Electronico` varchar(1) NOT NULL,
  `Ambiente` int(11) NOT NULL DEFAULT 0,
  `IdVentaMaestroRecursiva` int(11) DEFAULT NULL,
  `Motivo` varchar(200) DEFAULT NULL,
  `IdEmpresa` int(11) NOT NULL,
  `IdUsuario` int(11) NOT NULL,
  `IdComprobante` int(11) NOT NULL,
  `IdPersona` int(11) NOT NULL,
  `IdVendedor` bigint(20) NOT NULL,
  `IdGrupoPersona` bigint(20) NOT NULL,
  `IdEstablecimiento` bigint(20) DEFAULT NULL,
  `FechaSistema` timestamp NOT NULL DEFAULT current_timestamp(),
  `XmlProcesado` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ventasmaestro`
--

INSERT INTO `ventasmaestro` (`Id`, `FechaEmision`, `FechaVencimiento`, `Serie`, `Secuencial`, `ClaveAcceso`, `BaseIVA0`, `BaseIVA`, `BaseNoIVA`, `MontoICE`, `ValorIRBPNR`, `ExentoIVA`, `Propina`, `Descuento`, `DescuentoPorcentaje`, `SubTotal`, `ValorIVA`, `Total`, `PorcentajePropina`, `OtroValor`, `Comentario1`, `Comentario2`, `Comentario3`, `XmlOriginal`, `EstadoSRI`, `NumeroAutorizacion`, `MensajeSRI`, `FechaAutorizacion`, `CorreoEnviado`, `TipoComprobante`, `NumeroComprobante`, `Estado`, `Electronico`, `Ambiente`, `IdVentaMaestroRecursiva`, `Motivo`, `IdEmpresa`, `IdUsuario`, `IdComprobante`, `IdPersona`, `IdVendedor`, `IdGrupoPersona`, `IdEstablecimiento`, `FechaSistema`, `XmlProcesado`) VALUES
(1, '2023-07-12', '2023-07-12', '001003', 1, NULL, 0.00, 10.50, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 10.50, 1.26, 11.76, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', 1, 'ACT', '1', 1, NULL, NULL, 1, 1, 1, 1, 1, 1, 4, '2023-07-13 00:07:11', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `ciudades`
--
ALTER TABLE `ciudades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ciudades_idprovincia_foreign` (`IdProvincia`);

--
-- Indices de la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `UK_Comprobantes` (`Identificador`),
  ADD KEY `Fk_IdEmpresaComprobante` (`IdEmpresa`);

--
-- Indices de la tabla `empresas`
--
ALTER TABLE `empresas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `empresas_idprovincia_foreign` (`IdProvincia`),
  ADD KEY `empresas_idciudad_foreign` (`IdCiudad`);

--
-- Indices de la tabla `establecimientos`
--
ALTER TABLE `establecimientos`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IdEmpresaEstablecimiento` (`IdEmpresa`),
  ADD KEY `IdProvinciaEstablecimiento` (`IdProvincia`),
  ADD KEY `IdCiudadEstablecimiento` (`IdCiudad`);

--
-- Indices de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`) USING HASH;

--
-- Indices de la tabla `formaspago`
--
ALTER TABLE `formaspago`
  ADD PRIMARY KEY (`id`),
  ADD KEY `formaspago_idempresa_foreign` (`IdEmpresa`),
  ADD KEY `formaspago_idcuenta_foreign` (`IdCuenta`),
  ADD KEY `formaspago_idestablecimiento_foreign` (`IdEstablecimiento`),
  ADD KEY `formaspago_idefectivoequivalente_foreign` (`IdEfectivoEquivalente`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`(250));

--
-- Indices de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indices de la tabla `personas`
--
ALTER TABLE `personas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `personas_idprovincia_foreign` (`IdProvincia`),
  ADD KEY `personas_idciudad_foreign` (`IdCiudad`),
  ADD KEY `personas_idtipoidentificacion_foreign` (`IdTipoIdentificacion`),
  ADD KEY `personas_idempresa_foreign` (`IdEmpresa`),
  ADD KEY `personas_idtipocontribuyente_foreign` (`IdTipoContribuyente`),
  ADD KEY `personas_idcuenta_foreign` (`IdCuenta`),
  ADD KEY `personas_idconceptoretencionfuente_foreign` (`IdConceptoRetencionFuente`),
  ADD KEY `personas_idconceptoretencioniva_foreign` (`IdConceptoRetencionIva`),
  ADD KEY `personas_idcuentagasto_foreign` (`IdCuentaGasto`),
  ADD KEY `personas_idcuentaiva_foreign` (`IdCuentaIva`),
  ADD KEY `personas_idvendedor_foreign` (`IdVendedor`),
  ADD KEY `personas_idgrupopersona_foreign` (`IdGrupoPersona`),
  ADD KEY `personas_idtipopago_foreign` (`IdTipoPago`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `productos_codigo_unique` (`Codigo`),
  ADD KEY `productos_idunidadmedida_foreign` (`IdUnidadMedida`),
  ADD KEY `productos_idcategoria_foreign` (`IdCategoria`),
  ADD KEY `productos_idbodega_foreign` (`IdBodega`),
  ADD KEY `productos_idtarifaimpuestoice_foreign` (`IdTarifaImpuestoICE`),
  ADD KEY `productos_idtarifaimpuestoiva_foreign` (`IdTarifaImpuestoIVA`),
  ADD KEY `productos_idtarifaimpuestoivacompra_foreign` (`IdTarifaImpuestoIVACompra`),
  ADD KEY `productos_idtarifaimpuestoirbpnr_foreign` (`IdTarifaImpuestoIRBPNR`),
  ADD KEY `productos_idempresa_foreign` (`IdEmpresa`);

--
-- Indices de la tabla `provincias`
--
ALTER TABLE `provincias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tarifasimpuestoiva`
--
ALTER TABLE `tarifasimpuestoiva`
  ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `tiposidentificacion`
--
ALTER TABLE `tiposidentificacion`
  ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`) USING HASH;

--
-- Indices de la tabla `vendedores`
--
ALTER TABLE `vendedores`
  ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `ventamaestro_campoadicional`
--
ALTER TABLE `ventamaestro_campoadicional`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ventamaestro_campoadicional_idventamaestro_foreign` (`IdVentaMaestro`);

--
-- Indices de la tabla `ventamaestro_formapago`
--
ALTER TABLE `ventamaestro_formapago`
  ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `ventasdetalle`
--
ALTER TABLE `ventasdetalle`
  ADD PRIMARY KEY (`Id`);

--
-- Indices de la tabla `ventasmaestro`
--
ALTER TABLE `ventasmaestro`
  ADD PRIMARY KEY (`Id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `ciudades`
--
ALTER TABLE `ciudades`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=231;

--
-- AUTO_INCREMENT de la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `empresas`
--
ALTER TABLE `empresas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `establecimientos`
--
ALTER TABLE `establecimientos`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `formaspago`
--
ALTER TABLE `formaspago`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `personas`
--
ALTER TABLE `personas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `Id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `provincias`
--
ALTER TABLE `provincias`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `tarifasimpuestoiva`
--
ALTER TABLE `tarifasimpuestoiva`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tiposidentificacion`
--
ALTER TABLE `tiposidentificacion`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vendedores`
--
ALTER TABLE `vendedores`
  MODIFY `Id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ventamaestro_campoadicional`
--
ALTER TABLE `ventamaestro_campoadicional`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ventamaestro_formapago`
--
ALTER TABLE `ventamaestro_formapago`
  MODIFY `Id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ventasdetalle`
--
ALTER TABLE `ventasdetalle`
  MODIFY `Id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ventasmaestro`
--
ALTER TABLE `ventasmaestro`
  MODIFY `Id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
