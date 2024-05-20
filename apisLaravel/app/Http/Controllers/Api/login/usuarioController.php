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
                'Message' => 'Error en la validacion de los datos',
                'Erros' => $validator->errors(),
                'Status' => 400,
            ];
            return response()->json($data, 400);
        }

        // Ejecutar el procedimiento almacenado
        $usuario = $request->input('Usuario');
        $clave = $request->input('Clave');

        // Ejecutar el procedimiento almacenado y obtener el resultado
        DB::select('CALL SP_ValidarUsuario(?, ?, @resultado)', [$usuario, $clave]);
        $resultado = DB::select('SELECT @resultado as resultado')[0]->resultado;

        //devuelve error
        if (!$resultado) {
            return response()->json([
            'Message' => 'Credenciales incorrectas',
            'Status' => 400
        ], 400);
        }

        // Generar token
        $token = bin2hex(random_bytes(16));
          // Obtener ID de usuario
        $idPersona = $this->obtenerIdPersona($usuario);

        //Almacenar token en la base de datos
        $datosToken  = $this->SPA_UsuarioToken($idPersona, $token);

        return response()->json([
            'Message' => 'OK',
            'Status' => 200,
            'Token' => $token,
            'TiempoCaduca' => $datosToken['TiempoCaduca'],
            'NombrePersonal' => $datosToken['NombrePersonal'],
            'DocumentacionPersonal' => $datosToken['DocumentacionPersonal'],
            'SucursalPersonal' => $datosToken['SucursalPersonal'],
        ], 200);

    }

    private function obtenerIdPersona($usuario) {

        // Consulta SQL para obtener el ID de la persona
        $idPersona = DB::table('Usuario')
          ->join('Persona', 'Usuario.IdPersona', '=', 'Persona.IdPersona')
          ->where('Usuario.Usuario', $usuario)
          ->select('Persona.IdPersona')
          ->first()
          ->IdPersona;

        return $idPersona; // ID de la persona del usuario encontrado
      }



    private function SPA_UsuarioToken($idPersona, $token) {
        // Obtener los resultados
        $resultados = DB::select('CALL SPA_UsuarioToken(?, ?)', [$idPersona, $token]);

        // Extraer los valores de las variables de salida
        $Mensaje = $resultados[0]->Mensaje;
        $TiempoCaduca = $resultados[0]->TiempoCaduca;
        $NombrePersonal = $resultados[0]->NombrePersonal;
        $DocumentacionPersonal = $resultados[0]->DocumentacionPersonal;
        $SucursalPersonal = $resultados[0]->SucursalPersonal;

        // Devolver todos los datos en un array asociativo
        return [
            'Mensaje' => $Mensaje,
            'TiempoCaduca' => $TiempoCaduca,
            'NombrePersonal' => $NombrePersonal,
            'DocumentacionPersonal' => $DocumentacionPersonal,
            'SucursalPersonal' => $SucursalPersonal,
        ];
    }

    public function fnObtenerUsuDesdeBearer(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'Token' => 'required|string',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'Message' => 'Error en la validación de los datos',
                'Errors' => $validator->errors(),
                'Status' => 400,
            ], 400);
        }

        // Obtener el token del cuerpo de la solicitud
        $token = $request->input('Token');

        // Ejecutar la función almacenada y obtener el ID del usuario
        $idUsuario = DB::select('SELECT FN_ObtenerUsuDesdeBearer(?) AS id_usuario', [$token]);

        // Verificar si el ID del usuario está vacío o nulo
        if (empty($idUsuario) || is_null($idUsuario[0]->id_usuario)) {
            return response()->json([
                'Message' => 'El token no corresponde a ningún usuario en el sistema',
                'Status' => 400,
            ], 400);
        }

        // Devolver el ID del usuario como respuesta
        return response()->json([
            'Message' => 'OK',
            'Status' => 200,
            'IdUsuario' => $idUsuario[0]->id_usuario, // Se asume que el resultado es un solo valor
        ], 200);
    }

}