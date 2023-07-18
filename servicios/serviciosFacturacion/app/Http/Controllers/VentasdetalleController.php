<?php

namespace App\Http\Controllers;

use App\Models\Ventasdetalle;
use Illuminate\Http\Request;

class VentasdetalleController extends Controller
{
   public function index()
    {
        $ventasdetalle = Ventasdetalle::all();
        return response()->json($ventasdetalle);
    }

    public function show($id)
    {
        $ventasdetalle = Ventasdetalle::find($id);
        return response()->json($ventasdetalle);
    }

    public function store(Request $request)
    {
        $ventasdetalle = Ventasdetalle::create($request->all());
        return response()->json($ventasdetalle, 201);
    }

    public function update(Request $request, $id)
    {
        $ventasdetalle = Ventasdetalle::findOrFail($id);
        $ventasdetalle->update($request->all());
        return response()->json($ventasdetalle, 200);
    }

    public function destroy($id)
    {
        $ventasdetalle = Ventasdetalle::findOrFail($id);
        $ventasdetalle->delete();
        return response()->json(null, 204);
    }
}
