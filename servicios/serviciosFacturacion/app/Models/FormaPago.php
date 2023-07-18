<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FormaPago extends Model
{
   protected $table = 'formaspago';
    protected $primaryKey = 'Id';
    public $timestamps = false;

    protected $fillable = [
        'Nombre',
        'Predefinida',
        'Vigente',
        'CodigoSRI',
        'TipoPago',
        'IdEmpresa',
        'IdCuenta',
        'IdEstablecimiento',
        'IdEfectivoEquivalente',
    ];

    public function empresa()
    {
        return $this->belongsTo(Empresa::class, 'IdEmpresa');
    }

    public function cuenta()
    {
        return $this->belongsTo(Cuenta::class, 'IdCuenta');
    }

    public function establecimiento()
    {
        return $this->belongsTo(Establecimiento::class, 'IdEstablecimiento');
    }

    public function efectivoEquivalente()
    {
        return $this->belongsTo(EfectivoEquivalente::class, 'IdEfectivoEquivalente');
    }
}
