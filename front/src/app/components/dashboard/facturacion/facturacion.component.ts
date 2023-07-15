import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

interface Firm {
  nComprobante: string;
  fechaE: string;
  Ambiente: string;
  estado: string;
}

@Component({
  selector: 'app-facturacion',
  templateUrl: './facturacion.component.html',
  styleUrls: ['./facturacion.component.scss']
})
export class FacturacionComponent implements OnInit {
  data: Firm[] = [
    { nComprobante: '123456789', fechaE: 'ruc', Ambiente: 'John', estado: 'Doe' }
    // Agrega más objetos de ejemplo para completar la tabla
  ];
  columnas: string[] = ['nComprobante', 'fechaE', 'Ambiente', 'estado','acciones'];

  formulario!: FormGroup;
  mostrarFormulario = false;

  constructor(private formBuilder: FormBuilder) {}

  ngOnInit(): void {
    this.formulario = this.formBuilder.group({
      nComprobante: ['', Validators.required],
      fechaE: ['', Validators.required],
      Ambiente: ['', Validators.required],
      estado: ['', Validators.required]
    });
  }

  imprimirPDF(elemento: Firm) {
    // Lógica para imprimir en PDF
  }

  generarXML(elemento: Firm) {
    // Lógica para generar XML
  }

  enviarCorreo(elemento: Firm) {
    // Lógica para enviar correo electrónico
  }

  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }

  submitForm() {
    if (this.formulario.valid) {
      // Realiza las acciones necesarias al guardar el formulario
      const nuevaFirma: Firm = {
        nComprobante: this.formulario.value.nComprobante,
        fechaE: this.formulario.value.fechaE,
        Ambiente: this.formulario.value.Ambiente,
        estado: this.formulario.value.estado
      };
      this.data.push(nuevaFirma);
      this.formulario.reset();
      this.toggleForm();
    }
  }
}
