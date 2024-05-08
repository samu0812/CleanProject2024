import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipomoduloComponent } from './tipomodulo.component';

describe('TipomoduloComponent', () => {
  let component: TipomoduloComponent;
  let fixture: ComponentFixture<TipomoduloComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipomoduloComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipomoduloComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
