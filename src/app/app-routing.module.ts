import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import {HomeComponent} from './components/home/home.component';
import { UsuariosComponent } from './components/seguridad/usuarios/usuarios.component';
import { TiporolesComponent } from './components/seguridad/tiporoles/tiporoles.component';
import { RolComponent } from './components/seguridad/rol/rol.component';
import { ApisComponent } from './components/seguridad/apis/apis.component';
import { TipopersonaComponent } from './components/parametria/tipopersona/tipopersona.component';
import { TiporolComponent } from './components/parametria/tiporol/tiporol.component';
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
import { TipopermisodetalleComponent } from './components/parametria/tipopermisodetalle/tipopermisodetalle.component';
import { TiposucursalComponent } from './components/parametria/tiposucursal/tiposucursal.component';
import { StockComponent } from './components/recursos/stock/stock.component';
import { ProveedoresComponent } from './components/recursos/proveedores/proveedores.component';
import { PersonalComponent } from './components/recursos/personal/personal.component';
import { ClientesComponent } from './components/recursos/clientes/clientes.component';
import { RegistrodeventasComponent } from './components/gestion/registrodeventas/registrodeventas.component';
import { RealizarpedidosComponent } from './components/gestion/realizarpedidos/realizarpedidos.component';
import { EnviodeinventarioComponent } from './components/gestion/enviodeinventario/enviodeinventario.component';
import { ConfirmacionderecepcionComponent } from './components/gestion/confirmacionderecepcion/confirmacionderecepcion.component';
import { VizualizarfacturasComponent } from './components/gestion/vizualizarfacturas/vizualizarfacturas.component';
import { InformesdeventaComponent } from './components/reportes/informesdeventas/informesdeventa.component';
import { InformesfinancierosComponent } from './components/reportes/informesfinancieros/informesfinancieros.component';
import { InformesdeabastecimientoComponent } from './components/reportes/informesdeabastecimiento/informesdeabastecimiento.component';
import { InformesdeclientesComponent } from './components/reportes/informesdeclientes/informesdeclientes.component';
import { InformesdeproductosComponent } from './components/reportes/informesdeproductos/informesdeproductos.component';
import { SubmenuComponent } from './components/navbar/submenu/submenu.component';
import { AccesoComponent } from './components/acceso/acceso.component';
import { TipomoduloComponent } from './components/parametria/tipomodulo/tipomodulo.component';
import { AuthGuard } from './services/auth/auth.guard';
const routes: Routes = [
  {path: 'login', component: LoginComponent},
  {path: 'home', component: HomeComponent, canActivate: [AuthGuard]},
  {path: ':id/submenu', component: SubmenuComponent},

  {path: 'seguridad/usuarios', component: UsuariosComponent , canActivate: [AuthGuard]},
  {path: 'seguridad/tiporoles', component: TiporolesComponent, canActivate: [AuthGuard]},
  {path: 'seguridad/rolmodulos', component: RolComponent, canActivate: [AuthGuard]},
  {path: 'seguridad/apispormodulo', component: ApisComponent, canActivate: [AuthGuard]},

  {path: 'parametria/tipopersona', component: TipopersonaComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tiporol', component: TiporolComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipodocumentacion', component: TipodocumentacionComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipoproducto', component: TipoproductoComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipocategoria', component: TipocategoriaComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipomedida', component: TipomedidaComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipodomicilio', component: TipodomicilioComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipoimpuesto', component: TipoimpuestoComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipofactura', component: TipofacturaComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipodestinatariofactura', component: TipodestinatariofacturaComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipoformadepago', component: TipoformadepagoComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipopermiso', component: TipopermisoComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipopermisodetalle', component: TipopermisodetalleComponent, canActivate: [AuthGuard]},
  {path: 'parametria/sucursal', component: TiposucursalComponent, canActivate: [AuthGuard]},
  {path: 'parametria/tipomodulo', component: TipomoduloComponent, canActivate: [AuthGuard]},

  {path: 'recursos/inventario', component:StockComponent, canActivate: [AuthGuard]},
  {path: 'recursos/proveedores', component: ProveedoresComponent, canActivate: [AuthGuard]},
  {path: 'recursos/personal', component: PersonalComponent, canActivate: [AuthGuard]},
  {path: 'recursos/clientes', component:ClientesComponent , canActivate: [AuthGuard]},

  {path: 'gestion/registrodeventas', component:RegistrodeventasComponent, canActivate: [AuthGuard]},
  {path: 'gestion/realizarpedidos', component:RealizarpedidosComponent , canActivate: [AuthGuard]},
  {path: 'gestion/enviodeinventario', component: EnviodeinventarioComponent, canActivate: [AuthGuard]},
  {path: 'gestion/confirmacionderecepcion', component: ConfirmacionderecepcionComponent, canActivate: [AuthGuard]},
  {path: 'gestion/vizualizarfacturas', component: VizualizarfacturasComponent, canActivate: [AuthGuard]},

  {path: 'reportes/informesdeventa', component:InformesdeventaComponent, canActivate: [AuthGuard]},
  {path: 'reportes/informesfinancieros', component: InformesfinancierosComponent, canActivate: [AuthGuard]},
  {path: 'reportes/informesdeabastecimiento', component: InformesdeabastecimientoComponent, canActivate: [AuthGuard]},
  {path: 'reportes/informesdeclientes', component:InformesdeclientesComponent, canActivate: [AuthGuard]},
  {path: 'reportes/informesdeproductos', component: InformesdeproductosComponent, canActivate: [AuthGuard]},

  {path: 'acceso', component: AccesoComponent, canActivate: [AuthGuard]},
  { path: '**', redirectTo: '/login' }, // Ruta wildcard para manejar rutas no encontradas

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
