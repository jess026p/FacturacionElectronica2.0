<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VentasMaestro extends Model
{
     use HasFactory;

    protected $table = 'ventasmaestro';
   public $timestamps = false;
    protected $primaryKey = 'Id';

    protected $fillable = [
        'FechaEmision',
        'FechaVencimiento',
        'Serie',
        'Secuencial',
        'ClaveAcceso',
        'BaseIVA0',
        'BaseIVA',
        'BaseNoIVA',
        'MontoICE',
        'ValorIRBPNR',
        'ExentoIVA',
        'Propina',
        'Descuento',
        'DescuentoPorcentaje',
        'SubTotal',
        'ValorIVA',
        'Total',
        'PorcentajePropina',
        'OtroValor',
        'Comentario1',
        'Comentario2',
        'Comentario3',
        'XmlOriginal',
        'EstadoSRI',
        'NumeroAutorizacion',
        'MensajeSRI',
        'FechaAutorizacion',
        'CorreoEnviado',
        'TipoComprobante',
        'NumeroComprobante',
        'Estado',
        'Electronico',
        'Ambiente',
        'IdVentaMaestroRecursiva',
        'Motivo',
        'IdEmpresa',
        'IdUsuario',
        'IdComprobante',
        'IdPersona',
        'IdVendedor',
        'IdGrupoPersona',
        'IdEstablecimiento',
        'FechaSistema',
        'XmlProcesado',
    ];

}
