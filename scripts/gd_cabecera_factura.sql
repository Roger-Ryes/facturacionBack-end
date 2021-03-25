use cobis 
go

if exists(select 1 from sysobjects where name='gd_cabecera_factura')
	drop table gd_cabecera_factura
GO

CREATE TABLE gd_cabecera_factura(

	fr_codigo_secuencial 		 	int not null,
	fr_total						money,
	fr_fecha						datetime,
	cl_codigo						int	
);





