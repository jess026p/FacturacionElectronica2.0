<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProvinciaController;
use App\Http\Controllers\CiudadController;
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
