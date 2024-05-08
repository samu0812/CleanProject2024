import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TiporolesComponent } from './tiporoles.component';

describe('TiporolesComponent', () => {
  let component: TiporolesComponent;
  let fixture: ComponentFixture<TiporolesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TiporolesComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TiporolesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
