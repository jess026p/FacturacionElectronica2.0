<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('productos', function (Blueprint $table) {
 $table->increments('Id');
            $table->string('Codigo', 25)->unique();
            $table->string('CodigoAuxiliar', 25)->nullable();
            $table->string('Nombre', 255);
            $table->unsignedBigInteger('IdUnidadMedida');
            $table->string('UnidadMedida', 100)->nullable();
            $table->string('Marca', 100)->nullable();
            $table->string('Modelo', 100)->nullable();
            $table->string('Grupo', 100)->nullable();
            $table->string('Conversion', 50)->nullable();
            $table->string('InfoAdicional', 255)->nullable();
            $table->decimal('Existencia', 18, 6)->nullable();
            $table->double('Precio', 20, 6);
            $table->double('Precio2', 20, 6)->nullable();
            $table->double('Precio3', 20, 6)->nullable();
            $table->double('PrecioSinSubsidio', 20, 6)->nullable();
            $table->double('CostoUnitario', 20, 6)->default(0.000000);
            $table->string('Ubicacion', 100)->nullable();
            $table->string('RutaImagen', 255)->nullable();
            $table->integer('Activo')->default(1);
            $table->integer('IdCategoria');
            $table->integer('IdBodega');
            $table->integer('IdTarifaImpuestoICE')->nullable();
            $table->integer('IdTarifaImpuestoIVA');
            $table->integer('IdTarifaImpuestoIVACompra');
            $table->integer('IdTarifaImpuestoIRBPNR')->nullable();
            $table->integer('IdEmpresa');
            $table->timestamp('FechaCreacion')->default(\Illuminate\Support\Facades\DB::raw('CURRENT_TIMESTAMP'));

            $table->foreign('IdUnidadMedida')->references('Id')->on('unidad_medidas');
            $table->foreign('IdCategoria')->references('Id')->on('categorias');
            $table->foreign('IdBodega')->references('Id')->on('bodegas');
            $table->foreign('IdTarifaImpuestoICE')->references('Id')->on('tarifa_impuestos');
            $table->foreign('IdTarifaImpuestoIVA')->references('Id')->on('tarifa_impuestos');
            $table->foreign('IdTarifaImpuestoIVACompra')->references('Id')->on('tarifa_impuestos');
            $table->foreign('IdTarifaImpuestoIRBPNR')->references('Id')->on('tarifa_impuestos');
            $table->foreign('IdEmpresa')->references('Id')->on('empresas');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('productos');
    }
}
