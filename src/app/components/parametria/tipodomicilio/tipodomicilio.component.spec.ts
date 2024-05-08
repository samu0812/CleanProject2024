import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipodomicilioComponent } from './tipodomicilio.component';

describe('TipodomicilioComponent', () => {
  let component: TipodomicilioComponent;
  let fixture: ComponentFixture<TipodomicilioComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipodomicilioComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipodomicilioComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
