import { Component, OnInit, OnDestroy } from '@angular/core';
import { AuthService } from './../../services/auth/auth.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'] // Corregido 'styleUrl' a 'styleUrls'
})
export class HomeComponent implements OnInit, OnDestroy {

  constructor(private authService: AuthService) {}

  ngOnInit() {
    this.authService.iniciarSeguimientoInactividad();
  }

  ngOnDestroy() {
    this.authService.detenerSeguimientoInactividad();
  }
}
  