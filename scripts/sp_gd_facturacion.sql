use cobis 
go

if exists(select 1 from sysobjects where name='sp_gd_facturacion')
	drop procedure sp_gd_facturacion
go

create procedure sp_gd_facturacion
   @s_srv                   varchar(30) = null,
   @s_ssn                   int         = null,
   @s_date                  datetime    = null,
   @s_ofi                   smallint    = null,
   @s_user                  varchar(30) = null,
   @s_rol		            smallint    = null,
   @s_term		            varchar(10) = null,
   @t_file		            varchar(14) = null,
   @t_trn		   	        int			= null,
   @t_debug              	char(1)     = 'N',
   @t_from               	varchar(32) = null,
   @i_cedula_cliente		int 		= null,
   @i_total					money 		= 0,
   @i_estado				varchar(1) 	= 'V',
   @i_operacion				char(1),
   @i_cf_codigo				int 		= null,
   @i_pr_codigo				int 		= null,
   @i_cantidad				int 		= null,
   @o_codigo              	int      	= null out

as
declare
   @w_codigo_cf		int = 0,
   @w_error       	int,
   @w_return      	int,
   @w_sp_name		varchar(30),
   @w_pr_precio		money,
   @w_subtotal 		money,
   @w_total			money
   	
select @w_sp_name = 'sp_gd_facturacion'

--insertar una cabecera de factura

if @i_operacion = 'Q'  
begin
	if @i_cf_codigo is not null
	begin
		delete from gd_detalle_factura where df_codigo_factura = @i_cf_codigo
		delete from gd_cabecera_factura where cf_codigo = @i_cf_codigo
	end
	
	
	select @w_codigo_cf=max(cf_codigo) 
	from gd_cabecera_factura
	
	if @w_codigo_cf is null
		select @w_codigo_cf = 0
	
	select @w_codigo_cf = @w_codigo_cf + 1
	
	
	print '---- Insertando en cabecera_factura '
	insert into gd_cabecera_factura 
		  (cf_codigo, 		cf_total,	cf_estado)
	values					     
		  (@w_codigo_cf, 	0,			@i_estado)	
		
		
	select @o_codigo = @w_codigo_cf
end



---------------------------------------------------------------

if @i_operacion = 'I'
begin
	if exists(select 1 from gd_cliente where cl_cedula = @i_cedula_cliente)
	begin
		print '---- Insertando en cabecera_factura '
		update gd_cabecera_factura 
		set cf_cedula_cliente 	= @i_cedula_cliente
		where 
			cf_codigo 			= @i_cf_codigo
	end
end

--insertar detalles de factura

if @i_operacion = 'D'
begin
  	if @i_pr_codigo is null
    begin
      select @w_error =  1720497 
      goto ERROR_FIN
	end
	
	if @i_cantidad is null
	begin
      select @w_error =  1720609 
      goto ERROR_FIN
	end	
	
	select @i_pr_codigo = pr_secuencia from gd_producto where pr_codigo = @i_pr_codigo
	
	if @i_pr_codigo is not null
	begin
		if exists(select 1 from gd_producto where pr_stock < @i_cantidad and pr_secuencia = @i_pr_codigo)
		begin
	      select @w_error =  1720608 
	      goto ERROR_FIN
		end

		select @w_pr_precio = pr_precio from gd_producto where pr_secuencia = @i_pr_codigo		
		select @w_subtotal = @i_cantidad * @w_pr_precio
		
		if exists(select 1 from gd_detalle_factura where df_codigo_producto = @i_pr_codigo and df_codigo_factura = @i_cf_codigo)
		begin
		
			print '---- actualizando en detalle_factura '
			update gd_detalle_factura
			set 	df_cantidad 		= @i_cantidad,
					df_subtotal 		= @w_subtotal
			where	df_codigo_producto	= @i_pr_codigo
			and		df_codigo_factura 	= @i_cf_codigo
		end
		else
		begin

			print '---- Insertando en detalle_factura '
			insert into gd_detalle_factura 
				  (df_codigo_producto, 	df_codigo_factura, 	df_cantidad, 	df_subtotal)
			values						 
				  (@i_pr_codigo,		@i_cf_codigo, 		@i_cantidad, 	@w_subtotal)		
		end
		
		
		--obteniendo el total de la factura
		select @w_total = sum(df_subtotal)
		from gd_detalle_factura
		where df_codigo_factura = @i_cf_codigo
			
		--Actualizando el  total de la factura
		update gd_cabecera_factura
		set cf_total = @w_total
		where cf_codigo = @i_cf_codigo
		
	end
	else
	begin
      select @w_error =  1720516
      goto ERROR_FIN
	end
end

--consultar detalles de factura
if @i_operacion = 'R'
begin
	select 
	    'codigoProducto' 	= pr_codigo,
	    'Producto'			= pr_nombre,
		'Precio'		 	= pr_precio,
		'Cantidad' 		 	= df_cantidad,
		'SubTotal'			= df_subtotal
		
	from gd_detalle_factura
	inner join gd_producto on gd_detalle_factura.df_codigo_producto = gd_producto.pr_secuencia
	Where df_codigo_factura = @i_cf_codigo
end

return 0
ERROR_FIN:
begin
   exec cobis..sp_cerror
   @t_debug  = @t_debug,
   @t_file   = @t_file,
   @t_from   = @w_sp_name,				
   @i_num    = @w_error 
end
return @w_error