<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Establecimiento;
class EstablecimientoController extends Controller
{
 public function index()
    {
        $establecimientos = Establecimiento::all();
        return response()->json($establecimientos);
    }

    public function store(Request $request)
    {
        $establecimiento = Establecimiento::create($request->all());
        return response()->json($establecimiento, 201);
    }

    public function show($id)
    {
        $establecimiento = Establecimiento::findOrFail($id);
        return response()->json($establecimiento);
    }

    public function update(Request $request, $id)
    {
        $establecimiento = Establecimiento::findOrFail($id);
        $establecimiento->update($request->all());
        return response()->json($establecimiento, 200);
    }

    public function destroy($id)
    {
        $establecimiento = Establecimiento::findOrFail($id);
        $establecimiento->delete();
        return response()->json(null, 204);
    }
}
