<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateEstablecimientosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('establecimientos', function (Blueprint $table) {
$table->increments('Id');
            $table->string('Estab', 3);
            $table->string('PuntoEmision', 3);
            $table->string('Direccion', 255);
            $table->bigInteger('SecuenciaAP');
            $table->integer('SecuenciaFC');
            $table->integer('SecuenciaLC');
            $table->integer('SecuenciaNC');
            $table->integer('SecuenciaND');
            $table->integer('SecuenciaGR');
            $table->integer('SecuenciaCR');
            $table->integer('SecuenciaCZ');
            $table->bigInteger('SecuenciaIMP')->default(0);
            $table->integer('SecuenciaAsiento');
            $table->integer('SecuenciaIngreso');
            $table->integer('SecuenciaEgreso');
            $table->integer('SecuenciaDiario');
            $table->tinyInteger('EnviarCorreo');
            $table->tinyInteger('ImpresionAutomatica');
            $table->tinyInteger('Electronico');
            $table->integer('IdEmpresa');
            $table->integer('IdProvincia');
            $table->integer('IdCiudad');
            $table->string('RutaLogo', 255)->nullable();
            $table->tinyInteger('ConsumidorFinalDefecto');
            $table->tinyInteger('Ats')->default(1);
            $table->string('Nombre', 100);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('establecimientos');
    }
}
