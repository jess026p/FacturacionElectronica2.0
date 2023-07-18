<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Empresa extends Model
{
    protected $table = 'empresas';
    protected $primaryKey = 'Id';
    public $timestamps = true;

    protected $fillable = [
        'RazonSocial',
        'NombreComercial',
        'Identificacion',
        'RutaLogo',
        'FechaIniActividad',
        'Representante',
        'RucRepresentante',
        'Direccion',
        'AgenteRetencion',
        'IvaVigente',
        'ArtesanoCalificado',
        'Microempresa',
        'RegimenRimpe',
        'NegocioPopular',
        'LlevaContabilidad',
        'Correo',
        'Telefono',
        'Celular',
        'Contador',
        'RucContador',
        'Asistente',
        'RucAsistente',
        'TipoControlInventario',
        'Ambiente',
        'TipoEmision',
        'ContribuyenteEspecial',
        'RutaFirma',
        'ContraseniaFirma',
        'CodigoNumerico',
        'SMTPUsuario',
        'SMTPServidor',
        'SMTPContrasenia',
        'SMTPPuerto',
        'CorreoAsunto',
        'CorreoMensajeHTML',
        'IdProvincia',
        'IdCiudad',
        'NumeroAsiento',
    ];

    public function provincia()
    {
        return $this->belongsTo(Provincia::class, 'IdProvincia');
    }

    public function ciudad()
    {
        return $this->belongsTo(Ciudad::class, 'IdCiudad');
    }
}
