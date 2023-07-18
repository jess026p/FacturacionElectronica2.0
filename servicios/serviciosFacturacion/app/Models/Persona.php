<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Persona extends Model
{
      protected $table = 'personas';
    protected $primaryKey = 'Id';
    public $timestamps = false;

    protected $fillable = [
        'RazonSocial',
        'NombreComercial',
        'Identificacion',
        'Correo',
        'Direccion',
        'Telefono',
        'Celular',
        'IdRolPersona',
        'Rol',
        'AgenteRetencion',
        'Microempresa',
        'TipoRegimen',
        'CodigoReferencia',
        'InfoAdicional',
        'IdProvincia',
        'IdCiudad',
        'IdTipoIdentificacion',
        'IdEmpresa',
        'IdTipoContribuyente',
        'IdCuenta',
        'IdConceptoRetencionFuente',
        'IdConceptoRetencionIva',
        'IdCuentaGasto',
        'IdCuentaIva',
        'IdVendedor',
        'IdGrupoPersona',
        'ParteRelacional',
        'IdTipoPago',
        'CodigoTipoPago',
        'Activo',
        'FechaInicio',
        'FechaFin',
        'Membresia',
        'Periocidad',
        'Periodo',
        'LimiteCredito',
        'FechaCreacion',
    ];

    // Relaciones con otras tablas
    public function provincia()
    {
        return $this->belongsTo(Provincia::class, 'IdProvincia', 'Id');
    }

    public function ciudad()
    {
        return $this->belongsTo(Ciudad::class, 'IdCiudad', 'Id');
    }

    public function tipoIdentificacion()
    {
        return $this->belongsTo(TipoIdentificacion::class, 'IdTipoIdentificacion', 'Id');
    }

    public function empresa()
    {
        return $this->belongsTo(Empresa::class, 'IdEmpresa', 'Id');
    }

    public function tipoContribuyente()
    {
        return $this->belongsTo(TipoContribuyente::class, 'IdTipoContribuyente', 'Id');
    }

    public function cuenta()
    {
        return $this->belongsTo(Cuenta::class, 'IdCuenta', 'Id');
    }

    public function conceptoRetencionFuente()
    {
        return $this->belongsTo(ConceptoRetencion::class, 'IdConceptoRetencionFuente', 'Id');
    }

    public function conceptoRetencionIva()
    {
        return $this->belongsTo(ConceptoRetencion::class, 'IdConceptoRetencionIva', 'Id');
    }

    public function cuentaGasto()
    {
        return $this->belongsTo(CuentaGasto::class, 'IdCuentaGasto', 'Id');
    }

    public function cuentaIva()
    {
        return $this->belongsTo(CuentaIva::class, 'IdCuentaIva', 'Id');
    }

    public function vendedor()
    {
        return $this->belongsTo(Vendedor::class, 'IdVendedor', 'Id');
    }

    public function grupoPersona()
    {
        return $this->belongsTo(GrupoPersona::class, 'IdGrupoPersona', 'Id');
    }

    public function tipoPago()
    {
        return $this->belongsTo(TipoPago::class, 'IdTipoPago', 'Id');
    }
}
