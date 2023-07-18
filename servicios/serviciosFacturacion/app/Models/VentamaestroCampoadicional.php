<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VentamaestroCampoadicional extends Model
{
      use HasFactory;

    protected $table = 'ventamaestro_campoadicional';

    protected $primaryKey = 'Id';

    protected $fillable = [
        'Nombre',
        'Valor',
        'IdVentaMaestro',
    ];

    public function ventaMaestro()
    {
        return $this->belongsTo(Ventasmaestro::class, 'IdVentaMaestro');
    }
}
