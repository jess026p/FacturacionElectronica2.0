<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Vendedor;

class VendedorController extends Controller
{
     public function index()
    {
        $vendedores = Vendedor::all();
        return response()->json($vendedores);
    }

    public function store(Request $request)
    {
        $vendedor = Vendedor::create($request->all());
        return response()->json($vendedor, 201);
    }

    public function show($id)
    {
        $vendedor = Vendedor::findOrFail($id);
        return response()->json($vendedor);
    }

    public function update(Request $request, $id)
    {
        $vendedor = Vendedor::findOrFail($id);
        $vendedor->update($request->all());
        return response()->json($vendedor, 200);
    }

    public function destroy($id)
    {
        $vendedor = Vendedor::findOrFail($id);
        $vendedor->delete();
        return response()->json(null, 204);
    }
}
