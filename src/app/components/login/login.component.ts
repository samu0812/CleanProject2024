import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { LoginService } from '../../services/login/login.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  FormularioLogin: FormGroup = this.formBuilder.group({
    Usuario: [''],
    Clave: ['']
  });
  Error: string = '';

  constructor(
    private formBuilder: FormBuilder,
    private loginService: LoginService,
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
      // Obtener valores del formulario
      const formData = this.FormularioLogin.value;
      // Mostrar usuario y contraseña en la consola
      console.log(formData);
      // Llamar al servicio de inicio de sesión
      this.loginService.login(formData).subscribe(
        (response) => {
          if (response.status === 200) {
            localStorage.setItem("token", response.token)
            console.log('Autenticación exitosa');
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
