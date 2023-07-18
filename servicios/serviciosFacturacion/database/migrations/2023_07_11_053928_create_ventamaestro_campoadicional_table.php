<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateVentamaestroCampoadicionalTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('ventamaestro_campoadicional', function (Blueprint $table) {
            $table->id();
            $table->string('Nombre', 45);
            $table->string('Valor', 255);
            $table->unsignedBigInteger('IdVentaMaestro');
            $table->timestamps();

            $table->foreign('IdVentaMaestro')->references('Id')->on('ventasmaestro')->onDelete('cascade');
        });
    }


    

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('ventamaestro_campoadicional');
    }
}
