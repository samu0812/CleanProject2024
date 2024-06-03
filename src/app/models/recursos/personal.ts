export class Personal{
    public IdTipoPersonaSistema:number;
    public IdPersona: number;
    public IdTipoPersona: number;
    public IdTipoDomicilio: number;
    public Calle: string;
    public Nro: string;
    public Piso: string;
    public IdLocalidad: number;
    public IdTipoDocumentacion: number;
    public Documentacion: string;
    public Nombre: string;
    public Apellido: string;  
    public Mail: string; 
    public FechaNacimiento: Date;
    public Telefono: string;
    public IdProvincia: number;
    public FechaAlta: string;
    public FechaBaja: string;

    constructor() {
      this.IdTipoPersonaSistema = 1;
  }
  }
  