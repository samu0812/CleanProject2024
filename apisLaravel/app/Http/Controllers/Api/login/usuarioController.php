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
        DB::select('CALL SP_ValidarUsuario(?, ?, @resultado)', [$usuario, $clave]);
        $resultado = DB::select('SELECT @resultado as resultado')[0]->resultado;

        //devuelve error
        if (!$resultado) {
            return response()->json([
            'message' => 'Credenciales incorrectas',
            'status' => 400
        ], 400);
        }

        // Generar token
        $token = bin2hex(random_bytes(16));
          // Obtener ID de usuario
        $idPersona = $this->obtenerIdPersona($usuario);

        //Almacenar token en la base de datos
        $datosToken  = $this->SPA_UsuarioToken($idPersona, $token);

        return response()->json([
            'message' => 'OK',
            'status' => 200,
            'token' => $token,
            'tiempoCaduca' => $datosToken['tiempoCaduca'],
            'nombrePersonal' => $datosToken['nombrePersonal'],
            'documentacionPersonal' => $datosToken['documentacionPersonal'],
            'sucursalPersonal' => $datosToken['sucursalPersonal'],
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
        $mensaje = $resultados[0]->Mensaje;
        $tiempoCaduca = $resultados[0]->TiempoCaduca;
        $nombrePersonal = $resultados[0]->NombrePersonal;
        $documentacionPersonal = $resultados[0]->DocumentacionPersonal;
        $sucursalPersonal = $resultados[0]->SucursalPersonal;

        // Devolver todos los datos en un array asociativo
        return [
            'mensaje' => $mensaje,
            'tiempoCaduca' => $tiempoCaduca,
            'nombrePersonal' => $nombrePersonal,
            'documentacionPersonal' => $documentacionPersonal,
            'sucursalPersonal' => $sucursalPersonal,
        ];
    }

    public function fnObtenerUsuDesdeBearer(Request $request) {
        // Validar los datos de entrada
        $validator = Validator::make($request->all(), [
            'token' => 'required|string',
        ]);

        // Si la validación falla, devolver la respuesta correspondiente
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Error en la validación de los datos',
                'errors' => $validator->errors(),
                'status' => 400,
            ], 400);
        }

        // Obtener el token del cuerpo de la solicitud
        $token = $request->input('token');

        // Ejecutar la función almacenada y obtener el ID del usuario
        $idUsuario = DB::select('SELECT FN_ObtenerUsuDesdeBearer(?) AS id_usuario', [$token]);

        // Verificar si el ID del usuario está vacío o nulo
        if (empty($idUsuario) || is_null($idUsuario[0]->id_usuario)) {
            return response()->json([
                'message' => 'El token no corresponde a ningún usuario en el sistema',
                'status' => 400,
            ], 400);
        }

        // Devolver el ID del usuario como respuesta
        return response()->json([
            'message' => 'OK',
            'status' => 200,
            'id_usuario' => $idUsuario[0]->id_usuario, // Se asume que el resultado es un solo valor
        ], 200);
    }

}
