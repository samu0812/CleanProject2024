import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ConfirmacionderecepcionComponent } from './confirmacionderecepcion.component';

describe('ConfirmacionderecepcionComponent', () => {
  let component: ConfirmacionderecepcionComponent;
  let fixture: ComponentFixture<ConfirmacionderecepcionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ConfirmacionderecepcionComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ConfirmacionderecepcionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
