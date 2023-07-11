<?php

namespace App\Http\Controllers;

use App\Models\VentamaestroCampoadicional;
use Illuminate\Http\Request;

class VentamaestroCampoadicionalController extends Controller
{
     public function index()
    {
        $campoadicional = VentamaestroCampoadicional::all();
        return response()->json($campoadicional);
    }

    public function store(Request $request)
    {
        $campoadicional = VentamaestroCampoadicional::create($request->all());
        return response()->json($campoadicional, 201);
    }

    public function show($id)
    {
        $campoadicional = VentamaestroCampoadicional::findOrFail($id);
        return response()->json($campoadicional);
    }

    public function update(Request $request, $id)
    {
        $campoadicional = VentamaestroCampoadicional::findOrFail($id);
        $campoadicional->update($request->all());
        return response()->json($campoadicional, 200);
    }

    public function destroy($id)
    {
        VentamaestroCampoadicional::destroy($id);
        return response()->json(null, 204);
    }
}
