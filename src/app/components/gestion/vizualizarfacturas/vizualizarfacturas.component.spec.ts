import { ComponentFixture, TestBed } from '@angular/core/testing';

import { VizualizarfacturasComponent } from './vizualizarfacturas.component';

describe('VizualizarfacturasComponent', () => {
  let component: VizualizarfacturasComponent;
  let fixture: ComponentFixture<VizualizarfacturasComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [VizualizarfacturasComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(VizualizarfacturasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
