<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Ciudad;
class CiudadController extends Controller
{
    public function index()
    {
        $ciudades = Ciudad::all();
        return response()->json($ciudades);
    }

    public function store(Request $request)
    {
        $ciudad = Ciudad::create($request->all());
        return response()->json($ciudad, 201);
    }

    public function show($id)
    {
        $ciudad = Ciudad::find($id);
        return response()->json($ciudad);
    }

    public function update(Request $request, $id)
    {
        $ciudad = Ciudad::find($id);
        $ciudad->update($request->all());
        return response()->json($ciudad);
    }

    public function destroy($id)
    {
        Ciudad::destroy($id);
        return response()->json(null, 204);
    }
}
