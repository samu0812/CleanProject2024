<?php

namespace App\Http\Controllers\Api\login;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Usuario;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class usuarioController extends Controller
{
    public function index() {
        return Usuario::all();

    }

    public function spValidarUsuario(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(),[
            'Usuario' => 'required',
            'Clave' => 'required',
        ]);

        // Si hay errores de validación, devolver la respuesta correspondiente
        if($validator->fails()) {
            $data = [
                'message' => 'Error en la validacion de los datos',
                'erros' => $validator->errors(),
                'status' => 400,
            ];
            return response()->json($data, 400);
        }

        // Ejecutar el procedimiento almacenado
        $usuario = $request->input('Usuario');
        $clave = $request->input('Clave');

        // Ejecutar el procedimiento almacenado y obtener el resultado
        DB::select('CALL ValidarUsuario(?, ?, @resultado)', [$usuario, $clave]);
        $resultado = DB::select('SELECT @resultado as resultado')[0]->resultado;


        // Crear la respuesta
        $status = $resultado ? 200 : 401;
        $message = $resultado ? 'OK' : 'Credenciales incorrectas';

        return response()->json([
            'message' => $message,
            'status' => $status,
        ], $status);

    }
}
