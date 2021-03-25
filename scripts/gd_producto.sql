use cobis 
go

if OBJECT_ID('gd_producto') is not null
begin
	drop table gd_producto
	print 'Tabla borrada'
end

create table cobis..gd_producto(
	pr_secuencia	int,
	pr_codigo		varchar(4),
	pr_nombre		varchar(30),
	pr_stock		int,
	pr_precio		money
)

