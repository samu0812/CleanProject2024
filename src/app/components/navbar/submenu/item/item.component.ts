// item.component.ts
import { Component, Input, OnInit } from '@angular/core';
import { Menu } from '../../../../models/menu/menu';

@Component({
  selector: 'app-item',
  templateUrl: './item.component.html',
  styleUrls: ['./item.component.css']
})
export class ItemComponent implements OnInit {
  @Input('data') menu: Menu;

  constructor() {}

  ngOnInit(): void {
  }
}
