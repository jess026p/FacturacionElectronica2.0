<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\FormaPago;
class FormaPagoController extends Controller
{
     public function index()
    {
        $formasPago = FormaPago::all();
        return response()->json($formasPago);
    }

    public function store(Request $request)
    {
        $formaPago = FormaPago::create($request->all());
        return response()->json($formaPago, 201);
    }

    public function show($id)
    {
        $formaPago = FormaPago::find($id);
        return response()->json($formaPago);
    }

    public function update(Request $request, $id)
    {
        $formaPago = FormaPago::find($id);
        $formaPago->update($request->all());
        return response()->json($formaPago);
    }

    public function destroy($id)
    {
        FormaPago::destroy($id);
        return response()->json(null, 204);
    }
}
