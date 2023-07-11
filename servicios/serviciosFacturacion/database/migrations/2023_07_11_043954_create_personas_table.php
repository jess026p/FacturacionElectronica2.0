<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;
class CreatePersonasTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('personas', function (Blueprint $table) {
 $table->id();
            $table->string('RazonSocial', 255);
            $table->string('NombreComercial', 255)->nullable();
            $table->string('Identificacion', 20);
            $table->string('Correo', 100)->nullable();
            $table->string('Direccion', 255);
            $table->string('Telefono', 25)->nullable();
            $table->string('Celular', 25)->nullable();
            $table->unsignedBigInteger('IdRolPersona');
            $table->string('Rol', 10);
            $table->boolean('AgenteRetencion');
            $table->boolean('Microempresa')->default(0);
            $table->string('TipoRegimen', 20);
            $table->string('CodigoReferencia', 100)->nullable();
            $table->string('InfoAdicional', 100)->nullable();
            $table->unsignedBigInteger('IdProvincia');
            $table->unsignedBigInteger('IdCiudad');
            $table->unsignedBigInteger('IdTipoIdentificacion');
            $table->unsignedBigInteger('IdEmpresa');
            $table->unsignedBigInteger('IdTipoContribuyente');
            $table->unsignedBigInteger('IdCuenta')->nullable();
            $table->unsignedBigInteger('IdConceptoRetencionFuente')->nullable();
            $table->unsignedBigInteger('IdConceptoRetencionIva')->nullable();
            $table->unsignedBigInteger('IdCuentaGasto')->nullable();
            $table->unsignedBigInteger('IdCuentaIva')->nullable();
            $table->unsignedBigInteger('IdVendedor')->nullable();
            $table->unsignedBigInteger('IdGrupoPersona');
            $table->string('ParteRelacional', 2)->default('NO');
            $table->unsignedBigInteger('IdTipoPago')->nullable();
            $table->string('CodigoTipoPago', 3)->nullable();
            $table->tinyInteger('Activo')->default(1);
            $table->date('FechaInicio')->nullable();
            $table->date('FechaFin')->nullable();
            $table->tinyInteger('Membresia')->default(0);
            $table->string('Periocidad', 13)->default('Personalizada');
            $table->integer('Periodo');
            $table->decimal('LimiteCredito', 18, 2)->default(0.00);
            $table->timestamp('FechaCreacion')->default(DB::raw('CURRENT_TIMESTAMP'));

            $table->foreign('IdProvincia')->references('Id')->on('provincias');
            $table->foreign('IdCiudad')->references('Id')->on('ciudades');
            $table->foreign('IdTipoIdentificacion')->references('Id')->on('tiposidentificacion');
            $table->foreign('IdEmpresa')->references('Id')->on('empresas');
            $table->foreign('IdTipoContribuyente')->references('Id')->on('tiposcontribuyente');
            $table->foreign('IdCuenta')->references('Id')->on('cuentas');
            $table->foreign('IdConceptoRetencionFuente')->references('Id')->on('conceptosretencion');
            $table->foreign('IdConceptoRetencionIva')->references('Id')->on('conceptosretencion');
            $table->foreign('IdCuentaGasto')->references('Id')->on('cuentasgasto');
            $table->foreign('IdCuentaIva')->references('Id')->on('cuentasiva');
            $table->foreign('IdVendedor')->references('Id')->on('vendedores');
            $table->foreign('IdGrupoPersona')->references('Id')->on('grupospersonas');
            $table->foreign('IdTipoPago')->references('Id')->on('tipospago');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('personas');
    }
}
