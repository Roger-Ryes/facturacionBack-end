use cobis
go

if object_id('gd_cliente') is not null
	drop table gd_cliente
go

create table gd_cliente(
	cl_secuencial      	int 		 	not null,
	cl_cedula       	char	(10) 	not null,
	cl_nombre			varchar	(30) 	not null,
	cl_apellido 		varchar	(30) 	not null,
	cl_telefono			char	(10) 	not null,
	cl_direccion		varchar	(200),
	cl_estado          	char 	(1)  	not null
)

