<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Ciudad extends Model
{
    protected $table = 'ciudades';
    protected $primaryKey = 'Id';
    public $timestamps = true;

    protected $fillable = [
        'Nombre',
        'IdProvincia',
    ];

    public function provincia()
    {
        return $this->belongsTo(Provincia::class, 'IdProvincia');
    }
}
