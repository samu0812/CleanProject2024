import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, timer } from 'rxjs';
import { switchMap } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private tiempoExpiracionToken = 3600000; // 1 hora en milisegundos
  private ultimaInteracción: number;

  constructor(private http: HttpClient) {
    this.ultimaInteracción = Date.now();

    // Verificar cada 5 segundos si el usuario ha estado inactivo
    timer(0, 5000).pipe(
      switchMap(() => {
        const tiempoActual = Date.now();
        console.log(tiempoActual)
        const tiempoUltimaInteraccion = tiempoActual - this.ultimaInteracción;
        console.log(tiempoUltimaInteraccion)
        if (tiempoUltimaInteraccion > this.tiempoExpiracionToken) {
          return this.logout();
        }
        return new Observable(); // No hacer nada si no se ha excedido el tiempo
      })
    ).subscribe();
  }

  // Método para actualizar el tiempo de última interacción del usuario
  updateUltimaInteracción() {
    this.ultimaInteracción = Date.now();
  }

  // Método para desloguear al usuario
  logout(): Observable<any> {
    return this.http.post<any>('/api/logout', null);
  }
}
