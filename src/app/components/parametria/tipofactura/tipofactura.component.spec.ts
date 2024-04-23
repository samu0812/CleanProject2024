import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipofacturaComponent } from './tipofactura.component';

describe('TipofacturaComponent', () => {
  let component: TipofacturaComponent;
  let fixture: ComponentFixture<TipofacturaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipofacturaComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipofacturaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
