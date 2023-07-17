<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Ventasdetalle extends Model
{
    use HasFactory;

    protected $table = 'ventasdetalle';
    protected $primaryKey = 'Id';
    protected $fillable = [
        'Cantidad',
        'ValorUnitario',
        'Descuento',
        'PorcentajeDescuento',
        'CodigosSRIICE',
        'PorcentajeICE',
        'ValorICE',
        'CodigosSRIIVA',
        'PorcentajeIVA',
        'ValorIVA',
        'SubTotalLinea',
        'CodigosSRIIRBPNR',
        'PorcentajeIRBPNR',
        'ValorIRBPNR',
        'Estado',
        'VUFinal',
        'CostoUnitario',
        'CostoTotal',
        'SubsidioUnitario',
        'PrecioSinSubsidio',
        'TotalSinSubsidio',
        'TotalAhorroSubsidio',
        'IdProducto',
        'IdVentaMaestro',
    ];
}
