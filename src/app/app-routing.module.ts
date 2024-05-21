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

const routes: Routes = [
  {path: 'login', component: LoginComponent},
  {path: 'home', component: HomeComponent},
  {path: ':id/submenu', component: SubmenuComponent},

  {path: 'seguridad/usuarios', component: UsuariosComponent},
  {path: 'seguridad/tiporoles', component: TiporolesComponent},
  {path: 'seguridad/rol', component: RolComponent},
  {path: 'seguridad/apis', component: ApisComponent},

  {path: 'parametria/tipopersona', component: TipopersonaComponent},
  {path: 'parametria/tiporol', component: TiporolComponent},
  {path: 'parametria/tipodocumentacion', component: TipodocumentacionComponent},
  {path: 'parametria/tipoproducto', component: TipoproductoComponent},
  {path: 'parametria/tipocategoria', component: TipocategoriaComponent},
  {path: 'parametria/tipomedida', component: TipomedidaComponent},
  {path: 'parametria/tipodomicilio', component: TipodomicilioComponent},
  {path: 'parametria/tipoimpuesto', component: TipoimpuestoComponent},
  {path: 'parametria/tipofactura', component: TipofacturaComponent},
  {path: 'parametria/tipodestinatariofactura', component: TipodestinatariofacturaComponent},
  {path: 'parametria/tipoformadepago', component: TipoformadepagoComponent},
  {path: 'parametria/tipopermiso', component: TipopermisoComponent},
  {path: 'parametria/tipopermisodetalle', component: TipopermisodetalleComponent},
  {path: 'parametria/tiposucursal', component: TiposucursalComponent},

  {path: 'recursos/stock', component:StockComponent},
  {path: 'recursos/proveedores', component: ProveedoresComponent},
  {path: 'recursos/personal', component: PersonalComponent},
  {path: 'recursos/clientes', component:ClientesComponent },

  {path: 'gestion/registrodeventas', component:RegistrodeventasComponent},
  {path: 'gestion/realizarpedidos', component:RealizarpedidosComponent },
  {path: 'gestion/enviodeinventario', component: EnviodeinventarioComponent},
  {path: 'gestion/confirmacionderecepcion', component: ConfirmacionderecepcionComponent},
  {path: 'gestion/vizualizarfacturas', component: VizualizarfacturasComponent},

  {path: 'reportes/informesdeventa', component:InformesdeventaComponent},
  {path: 'reportes/informesfinancieros', component: InformesfinancierosComponent},
  {path: 'reportes/informesdeabastecimiento', component: InformesdeabastecimientoComponent},
  {path: 'reportes/informesdeclientes', component:InformesdeclientesComponent},
  {path: 'reportes/informesdeproductos', component: InformesdeproductosComponent},

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
