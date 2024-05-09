# Aplicación web - Facturación Electrónica
Es un sistema web que gestiona todo lo referente a la facturacion electrónica los módulos que comprenden este proyecto son: proveedores, clientes, gestión de roles de usuarios,productos,compras, ventas.

## 👣 Primeros Pasos

Estas instrucciones te guiarán en la configuración y ejecución de la aplicación en tu entorno local para propósitos de desarrollo y pruebas.

### ✔ Prerrequisitos
### Aplicación con Angular (Frontend) y Laravel (Backend)

Asegúrate de tener instalados los siguientes componentes:

#### Frontend (Angular):

1. *Node.js y npm:*
   - [Descargar e instalar Node.js](https://nodejs.org/)
   - npm se instalará automáticamente con Node.js.

2. *Angular CLI:*
   - Instalar Angular CLI globalmente usando el siguiente comando:
     bash
     npm install -g @angular/cli
     

#### Backend (Laravel):

1. *Composer:*
   - [Instalar Composer](https://getcomposer.org/download/).
   - Composer se utiliza para gestionar las dependencias de Laravel.

2. *PHP:*
   - Asegurarse de tener PHP instalado en tu sistema. Puedes instalarlo desde [php.net](https://www.php.net/).

3. *Laravel:*
   - Instalar Laravel utilizando Composer:
     bash
     composer create-project --prefer-dist laravel/laravel nombre-del-proyecto
     
   - Donde nombre-del-proyecto es el nombre de tu proyecto.

4. *Servidor Web:*
   - Puedes utilizar el servidor web incorporado de PHP para desarrollo o configurar un servidor web como Nginx o Apache para producción.

#### Configuración del Entorno:

1. *Configuración de Laravel:*
   - Configurar el archivo .env en tu proyecto Laravel con la información de la base de datos y otros ajustes necesarios.

2. *Configuración de Angular:*
   - Configurar las URLs de API en tu aplicación Angular, asegurándote de que coincidan con las rutas del backend de Laravel.

#### Iniciar Servidores:

1. *Servidor Laravel:*
   - Ejecutar el servidor de desarrollo de Laravel usando el siguiente comando:
     bash
     php artisan serve
     

2. *Servidor Angular:*
   - Moverte al directorio del proyecto Angular y ejecutar el siguiente comando:
     bash
     ng serve
     

#### Notas Adicionales:

- *Base de Datos:*
  - Configurar y migrar la base de datos de Laravel según sea necesario.

- *CORS (Cross-Origin Resource Sharing):*
  - Configurar CORS en Laravel si el frontend y el backend se ejecutan en dominios diferentes.

  
### ⚙ Instalación


## 1. Clonar el Repositorio:

bash
git clone git@github.com:jess026p/FacturacionElectronica2.0.git

## 2. Instalar Dependencias de Laravel:
bash
cd FacturacionElectronica2.0/laravel
composer install

## 3. Configurar el Archivo .env de Laravel:
Copia el archivo .env.example y renómbralo a .env.
Configura las variables de entorno en el archivo .env según tu entorno local (base de datos, URL, etc.).
## 4. Migrar la Base de Datos de Laravel:
bash
php artisan migrate

## 5. Instalar Dependencias de Angular:
bash
cd FacturacionElectronica2.0/angular
npm install

## 6. Configurar la URL del Backend en Angular:
Abre el archivo environment.ts en el directorio src/environments/ de tu proyecto Angular.
Asegúrate de que la variable apiUrl coincida con la URL de tu backend Laravel.
## 7. Iniciar los Servidores:
Inicia el servidor de Laravel:

 bash

php artisan serve

Inicia el servidor de desarrollo de Angular:
bash

ng serve

## 8. Verificar el Funcionamiento:
Accede a la aplicación a través de localhost en tu navegador web.
## 💻 Uso

#### Login
Te permitirá ingresar como administrador y como cliente de acuerdo a las credenciales que te proporcione el administrador ya que es el uniuco que podra crear nuevos usuarios como vendedore.
![Localhost](https://github.com/jess026p/FacturacionElectronica2.0/blob/EsthefaniaVillacres-patch-2/imgFLogin.png)
#### Gestión de ventas
En esta ventana se realizará la creación de una nueva factura que se emitirá como usuario vendedor las funciones principales serán crear clientes si no estan registrados en el sistema o buscar para que se complete los datos, asignar el nombre del trabajador que lo atendió, buscar productos y guardarlos y generar el valor total a a pagar.
![Localhost](https://github.com/jess026p/FacturacionElectronica2.0/blob/EsthefaniaVillacres-patch-2/imgFVentas.jpg)

#### Firma Electrónica
La firma electronica será ingresada al sistema en la siguiente ventana siempre y cuando tenga todas las validaciones legales.
![Localhost](https://github.com/jess026p/FacturacionElectronica2.0/blob/EsthefaniaVillacres-patch-2/imgFFirmaElectronica.jpg)

#### Gestión Vendedores
  Los vendedores serán ingresados únicamente por el admistrador del sistema en la siguiente ventana. 
![Localhost](https://github.com/jess026p/FacturacionElectronica2.0/blob/EsthefaniaVillacres-patch-2/imgFVendedorA.jpg)

#### Gestión surcusales
Las sucursales serán creadas al igual que los vendedores solo por el administrador.
![Localhost](https://github.com/jess026p/FacturacionElectronica2.0/blob/EsthefaniaVillacres-patch-2/imgFSucursalesA.jpg)
#### Gestión de productos
Los productos serán creados por el administrados en la siguiente ventana así como se podrán visualizar en la tabla los productos ya registrados.
![Localhost](https://github.com/jess026p/FacturacionElectronica2.0/blob/EsthefaniaVillacres-patch-2/imgFProductosA.jpg)
#### Gestión facturas
La administración se encargará de la revision de las facturas emitidas, asi como las exportaciones a xml y el envio al correo de los usuarios.
![Localhost](https://github.com/jess026p/FacturacionElectronica2.0/blob/EsthefaniaVillacres-patch-2/imgFFacturasA.jpg)

## 🤝 Contribución
Si deseas contribuir a este proyecto, sigue los siguientes pasos:

1. Haz un fork del repositorio.
2. Crea una nueva rama:
bash
git checkout -b nombre-de-la-rama

3. Realiza los cambios y haz commit:
bash
git commit -m "Descripción de los cambios"

4. Envía los cambios a tu fork:
bash
git push origin nombre-de-la-rama

5. Crea una pull request en este repositorio.

## © Licencia
Este proyecto académico no tiene una licencia específica asignada. Todos los derechos de autor pertenecen a los miembros del equipo de desarrollo. Ten en cuenta que esto significa que no se otorgan permisos explícitos para utilizar, modificar o distribuir el código fuente o los archivos relacionados. Cualquier uso, reproducción o distribución del proyecto debe obtener permiso previo.
## 📧 Contacto
Si tienes alguna pregunta o comentario, puedes contactarte con los miembros del equipo de desarrollo:

* dpinchao9519@uta.edu.ec
* jtituana8324@uta.edu.ec
* svillacres6104@uta.edu.ec
* anaranjo4578@uta.edu.ec
