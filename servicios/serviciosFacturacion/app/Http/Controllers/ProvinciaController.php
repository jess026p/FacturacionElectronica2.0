<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Provincia;

class ProvinciaController extends Controller
{
    public function index()
    {
        $provincias = Provincia::all();
        return response()->json($provincias);
    }

    public function store(Request $request)
    {
        $provincia = Provincia::create($request->all());
        return response()->json($provincia, 201);
    }

    public function show($id)
    {
        $provincia = Provincia::find($id);
        return response()->json($provincia);
    }

    public function update(Request $request, $id)
    {
        $provincia = Provincia::find($id);
        $provincia->update($request->all());
        return response()->json($provincia);
    }

    public function destroy($id)
    {
        Provincia::destroy($id);
        return response()->json(null, 204);
    }
}
