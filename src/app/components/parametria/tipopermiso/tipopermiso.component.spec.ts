import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipopermisoComponent } from './tipopermiso.component';

describe('TipopermisoComponent', () => {
  let component: TipopermisoComponent;
  let fixture: ComponentFixture<TipopermisoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipopermisoComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipopermisoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
