import { Injectable } from '@angular/core';
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private temporizadorInactividad: any;
  private TIEMPO_INACTIVIDAD_MS: number = 3600000; // 1 hora en milisegundos

  constructor(private router: Router) {}

  iniciarSeguimientoInactividad() {
    this.inicializarTemporizadorInactividad();

    // Escucha eventos de interacción del usuario para resetear el temporizador
    document.addEventListener('mousemove', this.resetearTemporizadorInactividad.bind(this));
    document.addEventListener('keypress', this.resetearTemporizadorInactividad.bind(this));
  }

  detenerSeguimientoInactividad() {
    clearTimeout(this.temporizadorInactividad);

    // Remueve los event listeners cuando la inactividad ya no necesita ser rastreada
    document.removeEventListener('mousemove', this.resetearTemporizadorInactividad.bind(this));
    document.removeEventListener('keypress', this.resetearTemporizadorInactividad.bind(this));

    // Llama a la función para limpiar el token cuando se detiene el seguimiento de inactividad

  }

  private inicializarTemporizadorInactividad() {
    this.temporizadorInactividad = setTimeout(() => {
      this.router.navigate(['/login']);
    }, this.TIEMPO_INACTIVIDAD_MS);
  }

  private resetearTemporizadorInactividad() {
    clearTimeout(this.temporizadorInactividad);
    this.inicializarTemporizadorInactividad();
  }


}
