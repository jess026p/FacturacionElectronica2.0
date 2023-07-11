<?php

namespace App\Http\Controllers;

use App\Models\VentasMaestro;
use Illuminate\Http\Request;

class VentasMaestroController extends Controller
{
     public function index()
    {
        $ventasMaestro = VentasMaestro::all();
        return response()->json($ventasMaestro);
    }

    public function store(Request $request)
    {
        $ventasMaestro = VentasMaestro::create($request->all());
        return response()->json($ventasMaestro, 201);
    }

    public function show($id)
    {
        $ventasMaestro = VentasMaestro::findOrFail($id);
        return response()->json($ventasMaestro);
    }

    public function update(Request $request, $id)
    {
        $ventasMaestro = VentasMaestro::findOrFail($id);
        $ventasMaestro->update($request->all());
        return response()->json($ventasMaestro, 200);
    }

    public function destroy($id)
    {
        VentasMaestro::destroy($id);
        return response()->json(null, 204);
    }
}
