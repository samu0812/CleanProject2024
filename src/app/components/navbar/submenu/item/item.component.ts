// item.component.ts
import { Component, Input, OnInit } from '@angular/core';
import { Menu } from '../../../../models/menu/menu';
import { NgbTooltipModule } from '@ng-bootstrap/ng-bootstrap';


@Component({
  selector: 'app-item',
  templateUrl: './item.component.html',
  styleUrls: ['./item.component.css']
})
export class ItemComponent implements OnInit {
  @Input('data') menu: Menu;
  @Input() isDisabled: boolean = false;z
  constructor() {}

  ngOnInit(): void {
    // console.log(this.menu);
  }
}
