import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EnviodeinventarioComponent } from './enviodeinventario.component';

describe('EnviodeinventarioComponent', () => {
  let component: EnviodeinventarioComponent;
  let fixture: ComponentFixture<EnviodeinventarioComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [EnviodeinventarioComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(EnviodeinventarioComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
