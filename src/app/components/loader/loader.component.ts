import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-loader',
  template: `
    <div class="loader-modal" *ngIf="isLoading">
        <div class="loader-icon">
          <div class="spinner-border" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
        </div>
    </div>
  `,
  styleUrls: ['./loader.component.css']
})
export class LoaderComponent {
  @Input() isLoading: boolean;
}
