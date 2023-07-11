<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Producto extends Model
{
     protected $table = 'productos';
    protected $primaryKey = 'Id';
    public $timestamps = false;

    protected $fillable = [
        'Codigo',
        'CodigoAuxiliar',
        'Nombre',
        'IdUnidadMedida',
        'UnidadMedida',
        'Marca',
        'Modelo',
        'Grupo',
        'Conversion',
        'InfoAdicional',
        'Existencia',
        'Precio',
        'Precio2',
        'Precio3',
        'PrecioSinSubsidio',
        'CostoUnitario',
        'Ubicacion',
        'RutaImagen',
        'Activo',
        'IdCategoria',
        'IdBodega',
        'IdTarifaImpuestoICE',
        'IdTarifaImpuestoIVA',
        'IdTarifaImpuestoIVACompra',
        'IdTarifaImpuestoIRBPNR',
        'IdEmpresa',
        'FechaCreacion',
    ];

    // Relaciones con otras tablas
    public function unidadMedida()
    {
        return $this->belongsTo(UnidadMedida::class, 'IdUnidadMedida', 'Id');
    }

    public function categoria()
    {
        return $this->belongsTo(Categoria::class, 'IdCategoria', 'Id');
    }

    public function bodega()
    {
        return $this->belongsTo(Bodega::class, 'IdBodega', 'Id');
    }

    public function tarifaImpuestoICE()
    {
        return $this->belongsTo(TarifaImpuesto::class, 'IdTarifaImpuestoICE', 'Id');
    }

    public function tarifaImpuestoIVA()
    {
        return $this->belongsTo(TarifaImpuesto::class, 'IdTarifaImpuestoIVA', 'Id');
    }

    public function tarifaImpuestoIVACompra()
    {
        return $this->belongsTo(TarifaImpuesto::class, 'IdTarifaImpuestoIVACompra', 'Id');
    }

    public function tarifaImpuestoIRBPNR()
    {
        return $this->belongsTo(TarifaImpuesto::class, 'IdTarifaImpuestoIRBPNR', 'Id');
    }

    public function empresa()
    {
        return $this->belongsTo(Empresa::class, 'IdEmpresa', 'Id');
    }
}
