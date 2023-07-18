<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateVentasmaestroTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('ventasmaestro', function (Blueprint $table) {
                       $table->increments('Id');
            $table->date('FechaEmision');
            $table->date('FechaVencimiento');
            $table->string('Serie', 6);
            $table->integer('Secuencial');
            $table->string('ClaveAcceso', 49)->nullable();
            $table->decimal('BaseIVA0', 18, 2)->default(0.00);
            $table->decimal('BaseIVA', 18, 2)->default(0.00);
            $table->decimal('BaseNoIVA', 18, 2)->default(0.00);
            $table->decimal('MontoICE', 18, 2)->default(0.00);
            $table->decimal('ValorIRBPNR', 18, 2)->default(0.00);
            $table->decimal('ExentoIVA', 18, 2)->default(0.00);
            $table->decimal('Propina', 18, 2)->default(0.00);
            $table->decimal('Descuento', 18, 2)->default(0.00);
            $table->tinyInteger('DescuentoPorcentaje');
            $table->decimal('SubTotal', 18, 2);
            $table->decimal('ValorIVA', 18, 2);
            $table->decimal('Total', 18, 2);
            $table->decimal('PorcentajePropina', 18, 2)->nullable();
            $table->decimal('OtroValor', 18, 2)->default(0.00);
            $table->string('Comentario1', 255)->nullable();
            $table->string('Comentario2', 255)->nullable();
            $table->string('Comentario3', 255)->nullable();
            $table->longText('XmlOriginal');
            $table->string('EstadoSRI', 255)->nullable();
            $table->string('NumeroAutorizacion', 49)->nullable();
            $table->mediumText('MensajeSRI')->nullable();
            $table->dateTime('FechaAutorizacion')->nullable();
            $table->string('CorreoEnviado', 2)->nullable();
            $table->string('TipoComprobante', 10);
            $table->integer('NumeroComprobante');
            $table->string('Estado', 3)->default('ACT');
            $table->string('Electronico', 1);
            $table->integer('Ambiente')->default(0);
            $table->integer('IdVentaMaestroRecursiva')->nullable();
            $table->string('Motivo', 200)->nullable();
            $table->integer('IdEmpresa');
            $table->integer('IdUsuario');
            $table->integer('IdComprobante');
            $table->integer('IdPersona');
            $table->bigInteger('IdVendedor');
            $table->bigInteger('IdGrupoPersona');
            $table->bigInteger('IdCotizacion')->nullable();
            $table->timestamp('FechaSistema')->default(\Illuminate\Support\Facades\DB::raw('current_timestamp()'));
            $table->text('XmlProcesado')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('ventasmaestro');
    }
}
