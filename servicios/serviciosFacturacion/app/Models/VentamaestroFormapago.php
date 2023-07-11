<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VentamaestroFormapago extends Model
{
    protected $table = 'ventamaestro_formapago';
    protected $primaryKey = 'Id';
    public $timestamps = false;

    protected $fillable = [
        'Valor',
        'Plazo',
        'Tiempo',
        'Observacion',
        'CodigoSRI',
        'Tarjeta',
        'TipoTarjeta',
        'Referencia',
        'Meses',
        'IdVentaMaestro',
        'IdVentaFormaPago'
    ];
}
