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
   @i_codigo_cliente		int 		= null,
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
    
	
	select @w_codigo_cf=max(cf_codigo) 
	from gd_cabecera_factura
	
	if @w_codigo_cf is null
		select @w_codigo_cf = 0
	
	select @w_codigo_cf = @w_codigo_cf + 1
	
	
  
		print '---- Insertando en cabecera_factura '
		insert into gd_cabecera_factura (cf_codigo)
		values					     (@w_codigo_cf)	

		SELECT 'Codigo factura' = cf_codigo
		from gd_cabecera_factura
		where cf_codigo =  @w_codigo_cf
		
	select @o_codigo = @w_codigo_cf
end



---------------------------------------------------------------

if @i_operacion = 'I'
begin
    
	
	
	if exists(select 1 from gd_cliente where cl_secuencial = @i_codigo_cliente)
	begin
		print '---- Insertando en cabecera_factura '
		update gd_cabecera_factura 
		set cf_codigo_cliente 	= @i_codigo_cliente,
			cf_fecha		  	= getdate(),
			cf_total			= @i_total,
			cf_estado			= @i_estado
			where 
			cf_codigo 			= @i_cf_codigo
	end
		
	select @o_codigo = @w_codigo_cf
end

--insertar detalles de factura

if @i_operacion = 'D'
begin

   			select @w_pr_precio = pr_precio from gd_producto where pr_secuencia = @i_pr_codigo
			select @w_subtotal = @i_cantidad * @w_pr_precio
	 		print '---- Insertando en detalle_factura '
	  		insert into gd_detalle_factura (df_codigo_producto, df_codigo_factura, df_cantidad, df_subtotal)
			values						 (@i_pr_codigo,@i_cf_codigo, @i_cantidad, @w_subtotal)		
   		   	
   		   	--Sumando el subtotal al total de la factura
			select @w_total = sum(df.df_subtotal)
			from gd_detalle_factura df, gd_cabecera_factura cf
			where df.df_codigo_factura = cf.cf_codigo
			
			--Actualizando el  total de la factura
			update gd_cabecera_factura
			set cf_total = @w_total
			where cf_codigo = @i_cf_codigo
			
	select @o_codigo = @w_codigo_cf
end


--consultar factura
if @i_operacion = 'S'
begin
   
	
	SELECT 
	    'Cliente codigo' = cf_codigo_cliente,
	    'Fecha creacion' = cf_fecha,
		'Factura codigo' = cf_codigo,
		'Factura total'  = cf_total
	FROM dbo.gd_cabecera_factura
	Where @i_cf_codigo = cf_codigo

   			
	select @o_codigo = @w_codigo_cf
end
--consultar detalles de factura
if @i_operacion = 'R'
begin
	SELECT 
	    'Producto codigo' 	= df_codigo_producto,
	    'Nombre'			= (select pr_nombre from gd_producto where pr_secuencia = df_codigo_producto),--obtener el nombre del producto
		'Cantidad'		 	= df_cantidad,
		'Subtotal' 		 	= df_subtotal
	FROM gd_detalle_factura 
	Where @i_cf_codigo = df_codigo_factura 
	select @o_codigo = @w_codigo_cf
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