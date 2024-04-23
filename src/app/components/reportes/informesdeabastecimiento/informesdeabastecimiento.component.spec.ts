import { ComponentFixture, TestBed } from '@angular/core/testing';

import { InformesdeabastecimientoComponent } from './informesdeabastecimiento.component';

describe('InformesdeabastecimientoComponent', () => {
  let component: InformesdeabastecimientoComponent;
  let fixture: ComponentFixture<InformesdeabastecimientoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [InformesdeabastecimientoComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(InformesdeabastecimientoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
