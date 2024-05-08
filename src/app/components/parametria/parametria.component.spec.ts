import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ParametriaComponent } from './parametria.component';

describe('ParametriaComponent', () => {
  let component: ParametriaComponent;
  let fixture: ComponentFixture<ParametriaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ParametriaComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ParametriaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
