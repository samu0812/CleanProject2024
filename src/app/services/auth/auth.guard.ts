import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, UrlTree, Router, GuardResult, MaybeAsync } from '@angular/router';
import { Observable } from 'rxjs';
import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {

  constructor(
    private authService: AuthService,
    private router: Router
  ) { }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {
    // Comprueba si el usuario está autenticado
    if (this.authService.isAuthenticatedUser()) {
      return true; // Devuelve true si el usuario está autenticado y puede acceder a la ruta protegida
    } else {
      return this.router.createUrlTree(['/login']); // Redirige al usuario a la página de inicio de sesión si no está autenticado
    }
  }
}
