<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\VentamaestroFormapago;
class VentamaestroFormapagoController extends Controller
{
public function index()
    {
        $formasPago = VentamaestroFormapago::all();
        return response()->json($formasPago);
    }

    public function store(Request $request)
    {
        $formapago = VentamaestroFormapago::create($request->all());
        return response()->json($formapago, 201);
    }

    public function show($id)
    {
        $formapago = VentamaestroFormapago::findOrFail($id);
        return response()->json($formapago);
    }

    public function update(Request $request, $id)
    {
        $formapago = VentamaestroFormapago::findOrFail($id);
        $formapago->update($request->all());
        return response()->json($formapago, 200);
    }

    public function destroy($id)
    {
        VentamaestroFormapago::findOrFail($id)->delete();
        return response()->json(null, 204);
    }
}
