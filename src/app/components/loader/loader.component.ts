import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-loader',
  template: `
    <div *ngIf="isLoading" class="loader-modal">
      <div class="loader-modal-content">
        <i class="fas fa-spinner fa-spin loader-icon"></i>
      </div>
    </div>
  `,
  styleUrls: ['./loader.component.css']
})
export class LoaderComponent {
  @Input() isLoading: boolean;
}
