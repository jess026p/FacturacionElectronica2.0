<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Provincia extends Model
{
    protected $table = 'provincias';
    protected $primaryKey = 'Id';
    public $timestamps = true;

    protected $fillable = [
        'CodigoArea',
        'Nombre',
    ];
}
