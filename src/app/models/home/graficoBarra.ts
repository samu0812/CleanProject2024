export class GraficoBarra {
    view: [number, number] = [650, 400];
    showXAxis = true;
    showYAxis = true;
    gradient = false;
    showLegend = false;
    showXAxisLabel = true;
    showYAxisLabel = true;
    xAxisLabel = '';
    yAxisLabel = '';
    barChartcustomColors: any[] = [];
    single: any[] = [];
    animations = true;
    activeEntries: any[] = [];
    exitAnimation = true;
    valueFormattingAnimation = true;
  
    constructor(config: any) {
      this.xAxisLabel = config.xAxisLabel;
      this.yAxisLabel = config.yAxisLabel;
    }
  
    actualizarDatos(datos: any[], coloresPersonalizados: any[]) {
      this.single = datos;
      this.barChartcustomColors = coloresPersonalizados;
    }
  }
  