import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipoimpuestoComponent } from './tipoimpuesto.component';

describe('TipoimpuestoComponent', () => {
  let component: TipoimpuestoComponent;
  let fixture: ComponentFixture<TipoimpuestoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipoimpuestoComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipoimpuestoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
