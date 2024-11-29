<?php

use App\Http\Controllers\BikeController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('/getBikes', [BikeController::class, 'getBikes']);
Route::put('/update/{id}', [BikeController::class, 'UpdateBikes']);
Route::get('/getBikeById/{id}', [BikeController::class, 'getBikeById']);
Route::delete('/DeleteBike/{id}', [BikeController::class, 'DeleteBike']);
Route::put('/UpdateReserved/{id}', [BikeController::class, 'UpdateReserved']);
Route::get('/GetBikesByNbrLocation', [BikeController::class, 'GetBikesByNbrLocation']);
Route::post('/AddBike', [BikeController::class, 'AddBike']);
