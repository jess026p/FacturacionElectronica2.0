<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Establecimiento extends Model
{
    protected $table = 'establecimientos';
    public $timestamps = false;
    protected $fillable = [
        'Estab',
        'PuntoEmision',
        'Direccion',
        'SecuenciaAP',
        'SecuenciaFC',
        'SecuenciaLC',
        'SecuenciaNC',
        'SecuenciaND',
        'SecuenciaGR',
        'SecuenciaCR',
        'SecuenciaCZ',
        'SecuenciaIMP',
        'SecuenciaAsiento',
        'SecuenciaIngreso',
        'SecuenciaEgreso',
        'SecuenciaDiario',
        'EnviarCorreo',
        'ImpresionAutomatica',
        'Electronico',
        'IdEmpresa',
        'IdProvincia',
        'IdCiudad',
        'RutaLogo',
        'ConsumidorFinalDefecto',
        'Ats',
        'Nombre',
    ];
}
