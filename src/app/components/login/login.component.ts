import { Usuario } from './../../models/usuario/usuario';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { LoginService } from '../../services/login/login.service';
import { AuthService } from '../../services/auth/auth.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  FormularioLogin: FormGroup;
  Error: string = '';
  datosUsuario: Usuario[] = [];

  constructor(
    private formBuilder: FormBuilder,
    private loginService: LoginService,
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.FormularioLogin = this.formBuilder.group({
      Usuario: [''],
      Clave: ['']
    });
  }

  onSubmit(): void {
    if (this.FormularioLogin.valid) {
      const formData = this.FormularioLogin.value;
      this.loginService.login(formData).subscribe(
        (response) => {
          if (response.Status === 200) {
            localStorage.setItem("Token", response.Token);
            console.log(response);
            this.authService.setAuthenticated(true, response); // Pasa la información del usuario
            this.router.navigate(['/home']);
          } else {
            console.log('Credenciales incorrectas');
            this.Error = 'Credenciales incorrectas, por favor intenta de nuevo.';
          }
        },
        (error) => {
          console.error('Error al autenticar:', error);
          this.Error = 'Error al intentar iniciar sesión, por favor intenta de nuevo más tarde.';
        }
      );
    } else {
      this.Error = 'Por favor ingresa tu usuario y contraseña correctamente.';
    }
  }
}
