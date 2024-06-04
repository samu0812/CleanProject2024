import { NgModule } from '@angular/core';
import { BrowserModule, provideClientHydration } from '@angular/platform-browser';
import { RouterModule, Routes } from '@angular/router';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { NavbarComponent } from './components/navbar/navbar.component';
import { LoginComponent } from './components/login/login.component';
import { FooterComponent } from './components/footer/footer.component';
import { HomeComponent } from './components/home/home.component';
import { GestionComponent } from './components/gestion/gestion.component';
import { ReportesComponent } from './components/reportes/reportes.component';
import { UsuariosComponent } from './components/seguridad/usuarios/usuarios.component';
import { TiporolesComponent } from './components/seguridad/tiporoles/tiporoles.component';
import { RolComponent } from './components/seguridad/rol/rol.component';
import { ApisComponent } from './components/seguridad/apis/apis.component';
import { TipopersonaComponent } from './components/parametria/tipopersona/tipopersona.component';
import { TiporolComponent } from './components/parametria/tiporol/tiporol.component';
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


import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { MatMenuModule } from '@angular/material/menu';
import { MatIconModule } from '@angular/material/icon';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatTableModule } from '@angular/material/table';
import { MatPaginatorModule } from '@angular/material/paginator';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { TipomoduloComponent } from './components/parametria/tipomodulo/tipomodulo.component';
import { TipopersonasistemaComponent } from './components/parametria/tipopersonasistema/tipopersonasistema.component';
import { SubmenuComponent } from './components/navbar/submenu/submenu.component';
import { ItemComponent } from './components/navbar/submenu/item/item.component';
import { TipodocumentacionComponent } from './components/parametria/tipodocumentacion/tipodocumentacion.component';
import { TiposucursalComponent } from './components/parametria/tiposucursal/tiposucursal.component';
import { AccesoComponent } from './components/acceso/acceso.component';
import { NgxPaginationModule } from 'ngx-pagination';
import { LoaderComponent } from './components/loader/loader.component';
import { AuthService } from './services/auth/auth.service';
import { BusquedaPipe } from './components/busqueda/busqueda.pipe';

@NgModule({
  declarations: [
    AppComponent,
    NavbarComponent,
    LoginComponent,
    FooterComponent,
    HomeComponent,
    GestionComponent,
    ReportesComponent,
    UsuariosComponent,
    TiporolesComponent,
    RolComponent,
    ApisComponent,
    TipopersonaComponent,
    TiporolComponent,
    TipoproductoComponent,
    TipocategoriaComponent,
    TipomedidaComponent,
    TipodomicilioComponent,
    TipoimpuestoComponent,
    TipofacturaComponent,
    TipodestinatariofacturaComponent,
    TipoformadepagoComponent,
    TipopermisoComponent,
    TipopermisodetalleComponent,
    StockComponent,
    ProveedoresComponent,
    PersonalComponent,
    ClientesComponent,
    RegistrodeventasComponent,
    RealizarpedidosComponent,
    EnviodeinventarioComponent,
    ConfirmacionderecepcionComponent,
    VizualizarfacturasComponent,
    InformesdeventaComponent,
    InformesfinancierosComponent,
    InformesdeabastecimientoComponent,
    InformesdeclientesComponent,
    InformesdeproductosComponent,
    TipomoduloComponent,
    TipopersonasistemaComponent,
    SubmenuComponent,
    ItemComponent,
    TipodocumentacionComponent,
    TiposucursalComponent,
    AccesoComponent,
    LoaderComponent,
    BusquedaPipe
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    MatMenuModule,
    MatIconModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    BrowserAnimationsModule,
    MatTableModule,
    MatPaginatorModule,
    MatFormFieldModule,
    MatInputModule,
    RouterModule,
    NgxPaginationModule,
  ],
  exports:[BusquedaPipe],
  providers: [
    provideClientHydration(),
    provideAnimationsAsync(),
    AuthService
  ],
  bootstrap: [AppComponent]
})

export class AppModule { }
