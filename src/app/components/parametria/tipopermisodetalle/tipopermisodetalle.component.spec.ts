import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipopermisodetalleComponent } from './tipopermisodetalle.component';

describe('TipopermisodetalleComponent', () => {
  let component: TipopermisodetalleComponent;
  let fixture: ComponentFixture<TipopermisodetalleComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipopermisodetalleComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipopermisodetalleComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
