use cobis 
go

if exists(select 1 from sysobjects where name='gd_detalle_factura')
	drop table gd_detalle_factura
GO


CREATE TABLE gd_detalle_factura(

	fr_codigo       int NOT NULL primary key,
	pr_codigo		int,
	pr_nombre		varchar(100),
	pr_precio		money,
	fr_cantidad		int,
	fr_subtotal		money,
	fr_total		money
);



