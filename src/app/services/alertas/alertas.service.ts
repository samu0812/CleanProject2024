import { Injectable } from '@angular/core';
import Swal from 'sweetalert2';

@Injectable({
  providedIn: 'root'
})
export class AlertasService {

  constructor() { }

  ErrorAlert(title: string, message: string) {
    Swal.fire({
      icon: 'error',
      title: title,
      text: message,
      toast: true,
      position: 'top-end',
      showConfirmButton: false,
      timer: 3000,
      background: '#ffcccc'
    });
  }

  OkAlert(title: string, message: string) {
    Swal.fire({
      icon: 'success',
      title: title,
      text: message,
      toast: true,
      position: 'top-end',
      showConfirmButton: false,
      timer: 3000,
      background: '#ccffcc'
    });
  }
  
  WarningAlert(title: string, message: string) {
    Swal.fire({
      icon: 'warning',
      title: title,
      text: message,
      toast: true,
      position: 'top-end',
      showConfirmButton: false,
      timer: 3000,
      background: '#ffffcc'
    });
  }
}
