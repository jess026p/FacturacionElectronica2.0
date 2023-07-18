<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateVentamaestroFormapagoTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('ventamaestro_formapago', function (Blueprint $table) {
            $table->increments('Id');
            $table->decimal('Valor', 18, 2);
            $table->string('Plazo')->nullable();
            $table->string('Tiempo')->nullable();
            $table->string('Observacion')->nullable();
            $table->string('CodigoSRI', 2);
            $table->string('Tarjeta')->nullable();
            $table->string('TipoTarjeta')->nullable();
            $table->string('Referencia')->nullable();
            $table->integer('Meses')->nullable();
            $table->integer('IdVentaMaestro');
            $table->integer('IdVentaFormaPago');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('ventamaestro_formapago');
    }
}
