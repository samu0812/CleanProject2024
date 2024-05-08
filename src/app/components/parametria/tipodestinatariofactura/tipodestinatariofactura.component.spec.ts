import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipodestinatariofacturaComponent } from './tipodestinatariofactura.component';

describe('TipodestinatariofacturaComponent', () => {
  let component: TipodestinatariofacturaComponent;
  let fixture: ComponentFixture<TipodestinatariofacturaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipodestinatariofacturaComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipodestinatariofacturaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
