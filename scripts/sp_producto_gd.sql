use cobis 
go
--select * from sysobjects where name='sp_sem_cliente'

if exists(select 1 from sysobjects where name='sp_producto_gd')
	drop procedure sp_producto_gd
go

create procedure sp_producto_gd
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
   --OPERACION
   @i_operacion	   	        char(1),
   --VARIABLES
   @i_pr_codigo				varchar(4) 	= null,
   @i_pr_nombre				varchar(30) = null,
   @i_pr_stock				int			= null,
   @i_pr_precio				money		= null,
   @i_pr_estado				varchar(1)	='V'
as
declare
   @w_secuencia_inc	int,
   @w_error       	int,
   @w_return       	int,
   @w_sp_name		varchar(30)
   
select @w_sp_name = 'sp_producto_gd'


--INSERTAR
if @i_operacion = 'I'
begin
  	if @i_pr_codigo is null
    begin
      select @w_error =  1720497 
      goto ERROR_FIN
	end
	if @i_pr_nombre is null
    begin
      select @w_error =  1720498 
      goto ERROR_FIN
	end
	if @i_pr_stock is null
    begin
      select @w_error =  1720577 
      goto ERROR_FIN
	end
	if @i_pr_precio is null
    begin
      select @w_error =  1720499 
      goto ERROR_FIN
	end
   
   	select @w_secuencia_inc=max(pr_secuencia) 
	from gd_producto
	
	if @w_secuencia_inc is null
		select @w_secuencia_inc = 0
	
	select @w_secuencia_inc = @w_secuencia_inc + 1
   
   	insert into gd_producto(
   		pr_secuencia,	pr_codigo,	pr_nombre,	pr_stock,	pr_precio	)
   	values(
   		@w_secuencia_inc, @i_pr_codigo, @i_pr_nombre, @i_pr_stock, 	@i_pr_precio)
end



--ACTUALIZAR
if @i_operacion = 'U'
begin
  	if @i_pr_codigo is null
    begin
      select @w_error =  1720497 
      goto ERROR_FIN
	end
	if @i_pr_nombre is null
    begin
      select @w_error =  1720498 
      goto ERROR_FIN
	end
	if @i_pr_stock is null
    begin
      select @w_error =  1720577 
      goto ERROR_FIN
	end
	if @i_pr_precio is null
    begin
      select @w_error =  1720499 
      goto ERROR_FIN
   	end
   
   if exists(select pr_codigo from gd_producto where pr_codigo = @i_pr_codigo)
   begin
   		update gd_producto 
   		set	pr_nombre = @i_pr_nombre,
   			pr_stock = @i_pr_stock,
   			pr_precio = @i_pr_precio
   		where pr_codigo = @i_pr_codigo   			
   end
end



--BORRAR
if @i_operacion = 'D'
begin
	if @i_pr_codigo is null
    begin
      select @w_error =  1720497 
      goto ERROR_FIN
	end
	
	if exists(select pr_codigo from gd_producto where pr_codigo = @i_pr_codigo)
   begin
   		update gd_producto 
   		set	pr_estado = 'D'
   		where pr_codigo = @i_pr_codigo   			
   end
	select * from gd_producto
	
end


--CONSULTA
if @i_operacion = 'Q'
begin
  	if @i_pr_codigo is null
    begin
      select @w_error =  1720497 
      goto ERROR_FIN
	end
	

   select 
   	'codigo' 	= pr_codigo,
   	'nombre' 	= pr_nombre,
   	'stock' 	= pr_stock,
   	'precio' 	= pr_precio,
   	'estado'	= pr_estado
	from gd_producto
	where pr_codigo = @i_pr_codigo
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

--select * from cl_errores where mensaje  like '%ingresar%'
