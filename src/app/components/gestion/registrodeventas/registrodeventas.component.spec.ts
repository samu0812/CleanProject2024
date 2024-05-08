import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistrodeventasComponent } from './registrodeventas.component';

describe('RegistrodeventasComponent', () => {
  let component: RegistrodeventasComponent;
  let fixture: ComponentFixture<RegistrodeventasComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [RegistrodeventasComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(RegistrodeventasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
