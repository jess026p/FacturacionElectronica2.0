<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateFormaspagoTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('formaspago', function (Blueprint $table) {
$table->id();
            $table->string('Nombre', 100);
            $table->tinyInteger('Predefinida');
            $table->tinyInteger('Vigente');
            $table->string('CodigoSRI', 2);
            $table->string('TipoPago', 1);
            $table->unsignedBigInteger('IdEmpresa');
            $table->unsignedBigInteger('IdCuenta');
            $table->unsignedBigInteger('IdEstablecimiento');
            $table->unsignedBigInteger('IdEfectivoEquivalente');

            $table->foreign('IdEmpresa')->references('Id')->on('empresas');
            $table->foreign('IdCuenta')->references('Id')->on('cuentas');
            $table->foreign('IdEstablecimiento')->references('Id')->on('establecimientos');
            $table->foreign('IdEfectivoEquivalente')->references('Id')->on('efectivosequivalentes');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('formaspago');
    }
}
