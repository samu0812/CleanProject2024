import { Injectable } from '@angular/core';
import { MatSnackBar, MatSnackBarConfig } from '@angular/material/snack-bar';
import { SnackbarComponent } from '../../components/snackbar/snackbar.component';

@Injectable({
  providedIn: 'root'
})
export class SnackbarService {

  constructor(private snackBar: MatSnackBar) { }

  openSnackbar(message: string, action: string, duration: number) {
    const config = new MatSnackBarConfig();
    config.duration = duration;
    config.panelClass = ['snackbar-custom'];
    config.data = { message: message };

    const snackBarRef = this.snackBar.openFromComponent(SnackbarComponent, config);

    return snackBarRef;
  }
}
