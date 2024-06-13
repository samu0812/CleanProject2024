import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { LoginService } from '../../services/login/login.service';
import { AuthService } from '../../services/auth/auth.service';
import { AlertasService } from '../../services/alertas/alertas.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  FormularioLogin: FormGroup;
  loading: boolean;
  showPassword: boolean = false; // Variable para controlar la visibilidad de la contraseña

  constructor(
    private formBuilder: FormBuilder,
    private loginService: LoginService,
    private authService: AuthService,
    private router: Router,
    private alertasService: AlertasService,
  ) {}

  ngOnInit(): void {
    this.FormularioLogin = this.formBuilder.group({
      Usuario: [''],
      Clave: ['']
    });
  }

  // Función para alternar la visibilidad de la contraseña
  togglePasswordVisibility(): void {
    this.showPassword = !this.showPassword;
  }

  onSubmit(): void {
    if (this.FormularioLogin.valid) {
      this.loading = true;
      const formData = this.FormularioLogin.value;
      this.loginService.login(formData).subscribe(
        (response) => {
          if (response.Status === 200) {
            localStorage.setItem("Token", response.Token);
            console.log(response);
            this.authService.setAuthenticated(true, response); // Pasa la información del usuario
            this.router.navigate(['/home']);
            this.loading = false;
          } else {
            this.alertasService.ErrorAlert('Credenciales incorrectas', 'Por favor intenta de nuevo.');
            this.loading = false;
          }
        },
        (error) => {
          this.alertasService.ErrorAlert('Error al autenticar', 'Por favor intenta de nuevo.');
          this.loading = false;
        }
      );
    } else {
      this.alertasService.ErrorAlert('Error al autenticar', 'Por favor intenta de nuevo.');
    }
  }
}
