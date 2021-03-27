use cobis 
go

if OBJECT_ID('gd_producto') is not null
begin
	drop table gd_producto
	print 'Tabla borrada'
end

create table cobis..gd_producto(
	pr_secuencia	int not null,
	pr_codigo		varchar(4) not null,
	pr_nombre		varchar(30) not null,
	pr_stock		int not null,
	pr_precio		money not null,
	pr_estado		varchar(1) not null
)

--select * from gd_producto