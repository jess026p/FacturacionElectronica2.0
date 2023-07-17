<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Empresa;

class EmpresaController extends Controller
{
    public function index()
    {
        $empresas = Empresa::all();
        return response()->json($empresas);
    }

    public function store(Request $request)
    {
        $empresa = Empresa::create($request->all());
        return response()->json($empresa, 201);
    }

    public function show($id)
    {
        $empresa = Empresa::find($id);
        return response()->json($empresa);
    }

    public function update(Request $request, $id)
    {
        $empresa = Empresa::find($id);
        $empresa->update($request->all());
        return response()->json($empresa);
    }

    public function destroy($id)
    {
        Empresa::destroy($id);
        return response()->json(null, 204);
    }
}
