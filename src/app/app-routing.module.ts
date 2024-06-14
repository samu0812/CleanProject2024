import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import {HomeComponent} from './components/home/home.component';
import { UsuariosComponent } from './components/seguridad/usuarios/usuarios.component';
import { TiporolesComponent } from './components/seguridad/tiporoles/tiporoles.component';
import { RolComponent } from './components/seguridad/rol/rol.component';
import { ApisComponent } from './components/seguridad/apis/apis.component';
import { TipopersonaComponent } from './components/parametria/tipopersona/tipopersona.component';
import { TipodocumentacionComponent } from './components/parametria/tipodocumentacion/tipodocumentacion.component';
import { TipoproductoComponent } from './components/parametria/tipoproducto/tipoproducto.component';
import { TipocategoriaComponent } from './components/parametria/tipocategoria/tipocategoria.component';
import { TipomedidaComponent } from './components/parametria/tipomedida/tipomedida.component';
import { TipodomicilioComponent } from './components/parametria/tipodomicilio/tipodomicilio.component';
import { TipoimpuestoComponent } from './components/parametria/tipoimpuesto/tipoimpuesto.component';
import { TipofacturaComponent } from './components/parametria/tipofactura/tipofactura.component';
import { TipodestinatariofacturaComponent } from './components/parametria/tipodestinatariofactura/tipodestinatariofactura.component';
import { TipoformadepagoComponent } from './components/parametria/tipoformadepago/tipoformadepago.component';
import { TipopermisoComponent } from './components/parametria/tipopermiso/tipopermiso.component';
import { TiposucursalComponent } from './components/parametria/tiposucursal/tiposucursal.component';
import { StockComponent } from './components/recursos/stock/stock.component';
import { ProveedoresComponent } from './components/recursos/proveedores/proveedores.component';
import { PersonalComponent } from './components/recursos/personal/personal.component';
import { ClientesComponent } from './components/recursos/clientes/clientes.component';
import { SubmenuComponent } from './components/navbar/submenu/submenu.component';
import { AccesoComponent } from './components/acceso/acceso.component';
import { TipomoduloComponent } from './components/parametria/tipomodulo/tipomodulo.component';
import { AuthGuard } from './services/auth/auth.guard';
import { RealizarventaComponent } from './components/gestion/realizarventa/realizarventa.component';
import { ConstruccionComponent } from './components/construccion/construccion.component';
const routes: Routes = [
  { path: '', redirectTo: '/login', pathMatch: 'full' },
  {path: 'login', component: LoginComponent},
  {path: 'home', component: HomeComponent, canActivate: [AuthGuard]},
  {path: ':id/submenu', component: SubmenuComponent},

  {path: 'seguridad/usuarios', component: UsuariosComponent, canActivate: [AuthGuard]},
  {path: 'seguridad/tiporoles', component: TiporolesComponent,  canActivate: [AuthGuard]},
  {path: 'seguridad/rolmodulos', component: RolComponent,  canActivate: [AuthGuard]},
  {path: 'seguridad/apispormodulo', component: ApisComponent,  canActivate: [AuthGuard]},

  {path: 'parametria/tipopersona', component: TipopersonaComponent,  canActivate: [AuthGuard]},

  {path: 'parametria/tipodocumentacion', component: TipodocumentacionComponent,  canActivate: [AuthGuard]},
  {path: 'parametria/tipoproducto', component: TipoproductoComponent,  canActivate: [AuthGuard]},
  {path: 'parametria/tipocategoria', component: TipocategoriaComponent,  canActivate: [AuthGuard]},
  {path: 'parametria/tipomedida', component: TipomedidaComponent,  canActivate: [AuthGuard]},
  {path: 'parametria/tipodomicilio', component: TipodomicilioComponent,  canActivate: [AuthGuard]},
  {path: 'parametria/tipoimpuesto', component: TipoimpuestoComponent,  canActivate: [AuthGuard]},
  {path: 'parametria/tipofactura', component: TipofacturaComponent,  canActivate: [AuthGuard]},
  {path: 'parametria/tipodestinatariofactura', component: TipodestinatariofacturaComponent,  canActivate: [AuthGuard]},
  {path: 'parametria/tipoformadepago', component: TipoformadepagoComponent,  canActivate: [AuthGuard]},
  {path: 'parametria/tipopermiso', component: TipopermisoComponent,  canActivate: [AuthGuard]},
  {path: 'parametria/sucursal', component: TiposucursalComponent,  canActivate: [AuthGuard]},
  {path: 'parametria/tipomodulo', component: TipomoduloComponent,  canActivate: [AuthGuard]},

  {path: 'recursos/inventario', component:StockComponent ,  canActivate: [AuthGuard]},
  {path: 'recursos/proveedores', component: ProveedoresComponent,  canActivate: [AuthGuard]},
  {path: 'recursos/personal', component: PersonalComponent,  canActivate: [AuthGuard]},
  {path: 'recursos/clientes', component:ClientesComponent ,  canActivate: [AuthGuard]},

  {path: 'gestion/realizarventa', component:RealizarventaComponent ,  canActivate: [AuthGuard]},
  {path: 'gestion/realizarpedido', component:ConstruccionComponent ,canActivate: [AuthGuard]},
  {path: 'gestion/enviarinventario', component: ConstruccionComponent,canActivate: [AuthGuard]},
  {path: 'gestion/confirmarrecepcion', component: ConstruccionComponent,canActivate: [AuthGuard]},

  {path: 'reportes/ventas', component:ConstruccionComponent,  canActivate: [AuthGuard]},
  {path: 'reportes/finanzas', component: ConstruccionComponent,  canActivate: [AuthGuard]},
  {path: 'reportes/abastecimiento', component: ConstruccionComponent,  canActivate: [AuthGuard]},
  {path: 'reportes/clientes', component:ConstruccionComponent,  canActivate: [AuthGuard]},
  {path: 'reportes/inventario', component: ConstruccionComponent,  canActivate: [AuthGuard]},

  {path: 'acceso', component: AccesoComponent,  },
  { path: '**', redirectTo: '/acceso' }, 

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }