<?php

namespace App\Http\Controllers;

use App\Models\Bus;
use Illuminate\Http\Request;

class BusController extends Controller
{
    function getBus()
    {
        $buses = Bus::all();
        return response()->json(['data' => $buses], 200);
    }

    function UpdateBuses(Request $request, $id)
    {

        $bus = Bus::find($id);
        if ($bus) {
            $bus->latitude = $request->latitude;
            $bus->longitude = $request->longitude;
            $bus->save();
            return response()->json(['data' => "Update Success"], 201);
        } else {
            return response()->json(['data' => "Not Found"], 404);
        }
    }
}
