<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateEmpresasTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('empresas', function (Blueprint $table) {
 $table->id();
            $table->string('RazonSocial', 255);
            $table->string('NombreComercial', 255)->nullable();
            $table->string('Identificacion', 20);
            $table->string('RutaLogo', 255)->nullable();
            $table->date('FechaIniActividad')->nullable();
            $table->string('Representante', 100)->nullable();
            $table->string('RucRepresentante', 13)->nullable();
            $table->string('Direccion', 255);
            $table->string('AgenteRetencion', 30)->nullable();
            $table->double('IvaVigente')->default(12);
            $table->string('ArtesanoCalificado', 20)->nullable();
            $table->string('Microempresa', 2);
            $table->string('RegimenRimpe', 2);
            $table->string('NegocioPopular', 2);
            $table->string('LlevaContabilidad', 2);
            $table->string('Correo', 60);
            $table->string('Telefono', 35)->nullable();
            $table->string('Celular', 35)->nullable();
            $table->string('Contador', 100)->nullable();
            $table->string('RucContador', 13)->nullable();
            $table->string('Asistente', 100)->nullable();
            $table->string('RucAsistente', 13)->nullable();
            $table->string('TipoControlInventario', 10)->default('Periódico');
            $table->string('Ambiente', 1);
            $table->string('TipoEmision', 1);
            $table->string('ContribuyenteEspecial', 13)->nullable();
            $table->string('RutaFirma', 255)->nullable();
            $table->string('ContraseniaFirma', 255)->nullable();
            $table->string('CodigoNumerico', 8)->nullable();
            $table->string('SMTPUsuario', 80)->nullable();
            $table->string('SMTPServidor', 100)->nullable();
            $table->string('SMTPContrasenia', 100)->nullable();
            $table->string('SMTPPuerto', 5)->nullable();
            $table->string('CorreoAsunto', 255)->nullable();
            $table->mediumText('CorreoMensajeHTML')->nullable();
            $table->unsignedBigInteger('IdProvincia');
            $table->unsignedBigInteger('IdCiudad');
            $table->unsignedBigInteger('NumeroAsiento');

            $table->foreign('IdProvincia')->references('Id')->on('provincias');
            $table->foreign('IdCiudad')->references('Id')->on('ciudades');
        });
       
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('empresas');
    }
}
