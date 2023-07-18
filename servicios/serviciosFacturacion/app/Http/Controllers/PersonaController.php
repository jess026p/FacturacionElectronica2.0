<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Persona;
class PersonaController extends Controller
{
   public function index()
    {
        $personas = Persona::all();
        return response()->json($personas);
    }

    public function store(Request $request)
    {
        $persona = Persona::create($request->all());
        return response()->json($persona, 201);
    }

    public function show($id)
    {
        $persona = Persona::find($id);
        return response()->json($persona);
    }

    public function update(Request $request, $id)
    {
        $persona = Persona::find($id);
        $persona->update($request->all());
        return response()->json($persona);
    }

    public function destroy($id)
    {
        Persona::destroy($id);
        return response()->json(null, 204);
    }
}
