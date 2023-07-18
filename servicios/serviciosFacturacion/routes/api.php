<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProvinciaController;
use App\Http\Controllers\CiudadController;
use App\Http\Controllers\EmpresaController;
use App\Http\Controllers\FormaPagoController;
use App\Http\Controllers\PersonaController;
use App\Http\Controllers\ProductoController;
use App\Http\Controllers\VentasMaestroController;
use App\Http\Controllers\VentamaestroCampoadicionalController;
use App\Http\Controllers\VentamaestroFormapagoController;
use App\Http\Controllers\VentasdetalleController;
use App\Http\Controllers\EstablecimientoController;
use App\Http\Controllers\VendedorController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

//
//Rutas de provincias
//

Route::get('/provincias', [ProvinciaController::class, 'index']);
Route::post('/provincias', [ProvinciaController::class, 'store']);
Route::get('/provincias/{id}', [ProvinciaController::class, 'show']);
Route::put('/provincias/{id}', [ProvinciaController::class, 'update']);
Route::delete('/provincias/{id}', [ProvinciaController::class, 'destroy']);

//
//Rutas de ciudades
//
Route::get('/ciudades', [CiudadController::class, 'index']);
Route::post('/ciudades', [CiudadController::class, 'store']);
Route::get('/ciudades/{id}', [CiudadController::class, 'show']);
Route::put('/ciudades/{id}', [CiudadController::class, 'update']);
Route::delete('/ciudades/{id}', [CiudadController::class, 'destroy']);
//
//Rutas de empresas
//
Route::get('/empresas', [EmpresaController::class, 'index']);
Route::post('/empresas', [EmpresaController::class, 'store']);
Route::get('/empresas/{id}', [EmpresaController::class, 'show']);
Route::put('/empresas/{id}', [EmpresaController::class, 'update']);
Route::delete('/empresas/{id}', [EmpresaController::class, 'destroy']);

//
//Rutas de formaspago
//
Route::get('/formaspago', [FormaPagoController::class, 'index']);
Route::post('/formaspago', [FormaPagoController::class, 'store']);
Route::get('/formaspago/{id}', [FormaPagoController::class, 'show']);
Route::put('/formaspago/{id}', [FormaPagoController::class, 'update']);
Route::delete('/formaspago/{id}', [FormaPagoController::class, 'destroy']);
//
//Rutas de Personas
//
Route::get('/personas', [PersonaController::class, 'index']);
Route::post('/personas', [PersonaController::class, 'store']);
Route::get('/personas/{id}', [PersonaController::class, 'show']);
Route::put('/personas/{id}', [PersonaController::class, 'update']);
Route::delete('/personas/{id}', [PersonaController::class, 'destroy']);
//
//Rutas de Productos
//
Route::get('/productos', [ProductoController::class, 'index']);
Route::post('/productos', [ProductoController::class, 'store']);
Route::get('/productos/{id}', [ProductoController::class, 'show']);
Route::put('/productos/{id}', [ProductoController::class, 'update']);
Route::delete('/productos/{id}', [ProductoController::class, 'destroy']);
//
//Rutas de Ventas Maestro
//
Route::get('/ventasmaestro', [VentasMaestroController::class, 'index']);
Route::post('/ventasmaestro', [VentasMaestroController::class, 'store']);
Route::get('/ventasmaestro/{id}', [VentasMaestroController::class, 'show']);
Route::put('/ventasmaestro/{id}', [VentasMaestroController::class, 'update']);
Route::delete('/ventasmaestro/{id}', [VentasMaestroController::class, 'destroy']);
//
//Rutas de Ventas Maestro campo adicional
//
Route::get('ventamaestro_campoadicional', [VentamaestroCampoadicionalController::class, 'index']);
Route::post('ventamaestro_campoadicional', [VentamaestroCampoadicionalController::class, 'store']);
Route::get('ventamaestro_campoadicional/{id}', [VentamaestroCampoadicionalController::class, 'show']);
Route::put('ventamaestro_campoadicional/{id}', [VentamaestroCampoadicionalController::class, 'update']);
Route::delete('ventamaestro_campoadicional/{id}', [VentamaestroCampoadicionalController::class, 'destroy']);
//
//Rutas de Ventas Maestro forma pago
//
Route::get('/ventamaestro_formapago', [VentamaestroFormapagoController::class, 'index']);
Route::get('/ventamaestro_formapago/{id}', [VentamaestroFormapagoController::class, 'show']);
Route::post('/ventamaestro_formapago', [VentamaestroFormapagoController::class, 'store']);
Route::put('/ventamaestro_formapago/{id}', [VentamaestroFormapagoController::class, 'update']);
Route::delete('/ventamaestro_formapago/{id}', [VentamaestroFormapagoController::class, 'destroy']);
//
//Rutas de Ventas Detalle
//
// Rutas para obtener todos los registros de la tabla
Route::get('/ventasdetalle', [VentasdetalleController::class, 'index']);

// Ruta para obtener un registro específico por su ID
Route::get('/ventasdetalle/{id}', [VentasdetalleController::class, 'show']);

// Ruta para crear un nuevo registro
Route::post('/ventasdetalle', [VentasdetalleController::class, 'store']);

// Ruta para actualizar un registro existente por su ID
Route::put('/ventasdetalle/{id}', [VentasdetalleController::class, 'update']);

// Ruta para eliminar un registro por su ID
Route::delete('/ventasdetalle/{id}', [VentasdetalleController::class, 'destroy']);

//
//Rutas de Establecimiento
//

Route::get('establecimientos', [EstablecimientoController::class, 'index']);
Route::post('establecimientos', [EstablecimientoController::class, 'store']);
Route::get('establecimientos/{id}', [EstablecimientoController::class, 'show']);
Route::put('establecimientos/{id}', [EstablecimientoController::class, 'update']);
Route::delete('establecimientos/{id}', [EstablecimientoController::class, 'destroy']);

//
//Rutas de Vendedores
//

Route::get('vendedores', [VendedorController::class, 'index']);
Route::post('vendedores', [VendedorController::class, 'store']);
Route::get('vendedores/{id}', [VendedorController::class, 'show']);
Route::put('vendedores/{id}', [VendedorController::class, 'update']);
Route::delete('vendedores/{id}', [VendedorController::class, 'destroy']);
