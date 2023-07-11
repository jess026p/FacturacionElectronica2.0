<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateVentasdetalleTable extends Migration
{
    public function up()
    {
        Schema::create('ventasdetalle', function (Blueprint $table) {
            $table->increments('Id');
            $table->double('Cantidad', 20, 6);
            $table->double('ValorUnitario', 20, 6);
            $table->double('Descuento', 18, 2);
            $table->double('PorcentajeDescuento', 18, 4)->default(0.0000);
            $table->string('CodigosSRIICE', 10);
            $table->double('PorcentajeICE', 18, 2);
            $table->double('ValorICE', 18, 2)->default(0.00);
            $table->string('CodigosSRIIVA', 10);
            $table->double('PorcentajeIVA', 18, 2);
            $table->double('ValorIVA', 18, 2);
            $table->double('SubTotalLinea', 18, 2);
            $table->string('CodigosSRIIRBPNR', 10);
            $table->double('PorcentajeIRBPNR', 18, 2);
            $table->double('ValorIRBPNR', 18, 2)->default(0.00);
            $table->string('Estado', 3)->default('ACT');
            $table->double('VUFinal', 20, 6);
            $table->double('CostoUnitario', 20, 6)->default(0.000000);
            $table->double('CostoTotal', 18, 2)->default(0.00);
            $table->double('SubsidioUnitario', 20, 6)->default(0.000000);
            $table->double('PrecioSinSubsidio', 20, 6)->default(0.000000);
            $table->double('TotalSinSubsidio', 18, 2)->default(0.00);
            $table->double('TotalAhorroSubsidio', 18, 2)->default(0.00);
            $table->integer('IdProducto');
            $table->integer('IdVentaMaestro');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('ventasdetalle');
    }
}
