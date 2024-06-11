import { Component, Inject, OnDestroy } from '@angular/core';
import { MatSnackBarRef, MAT_SNACK_BAR_DATA } from '@angular/material/snack-bar';
import { Subscription, timer } from 'rxjs';

@Component({
  selector: 'app-snackbar',
  template: `
<div class="snackbar-content">
  <div class="message">{{ data.message }}</div>
  <div class="cancel-button-container">
    <button mat-raised-button color="warn" (click)="cancelVenta()" id="cancelar">Cancelar Venta</button>
  </div>
  <div class="progress-bar" [style.width.%]="progress"></div>
  <button type="button" class="btn-close" aria-label="Close" id="cerrar" (click)="closeSnackbar()"></button>
</div>
  `,
  styles: [`
.snackbar-content {
  display: flex; /* Utilizar flexbox */
  align-items: center; /* Centrar verticalmente los elementos */
  position: relative;
}
.message {
  margin-right: 10px;
  padding: 8px;
  color: #fff;
}
.cancel-button-container {
  margin-right: 8px; /* Espacio entre el mensaje y el botón */
  width: auto; /* Ancho automático para adaptarse al texto */
  white-space: nowrap; /* Evita que el texto se divida en varias líneas */
}

#cancelar {
  height: 25px;
  padding: 5px 10px; /* Ajusta el espaciado interno del botón */
  font-size: 14px; /* Tamaño de la fuente */
}

.progress-bar {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 3px;
  background-color: #FF8C00;
  transition: width linear {{ duration }}ms;
}

  `]
})
export class SnackbarComponent implements OnDestroy {
  progress: number = 0;
  duration: number;

  private progressSubscription: Subscription;

  constructor(
    public snackBarRef: MatSnackBarRef<SnackbarComponent>,
    @Inject(MAT_SNACK_BAR_DATA) public data: any
  ) {
    this.duration = this.snackBarRef.containerInstance.snackBarConfig.duration;
    this.progressSubscription = timer(0, 10).subscribe(() => {
      this.progress += 100 / this.duration * 10;
    });
  }

  ngOnDestroy() {
    this.progressSubscription.unsubscribe();
  }

  closeSnackbar(): void {
    this.snackBarRef.dismiss();
  }

  cancelVenta(): void {
    console.log('Hola');
    this.closeSnackbar(); // Opcional: cierra el Snackbar después de imprimir "Hola"
  }
}
