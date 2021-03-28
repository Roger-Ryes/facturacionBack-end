use cobis 
go
--select * from sysobjects where name='sp_sem_cliente'

if exists(select 1 from sysobjects where name='sp_cliente_gd')
	drop procedure sp_cliente_gd
go

create procedure sp_cliente_gd
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
   @i_cl_cedula				varchar(10)  = null,
   @i_cl_nombre				varchar(30)  = null,
   @i_cl_apellido			varchar(30)  = null,
   @i_cl_telefono			char(10)	 = null,
   @i_cl_direccion			varchar(200) = null,
   @i_cl_estado				char(1)	 	 = 'V',
   @i_buscar_cli			varchar(30)	 = null
as
declare
   @w_secuencia_inc	int,
   @w_error       	int,
   @w_return       	int,
   @w_sp_name		varchar(30)
   
select @w_sp_name = 'sp_cliente_gd'


--INSERTAR
if @i_operacion = 'I'
begin
  	if @i_cl_cedula is null
    begin
      select @w_error =  1720368 
      goto ERROR_FIN
	end
	if @i_cl_nombre is null
    begin
      select @w_error =  1720369 
      goto ERROR_FIN
	end
	if @i_cl_apellido is null
    begin
      select @w_error =  1720370 
      goto ERROR_FIN
	end
	if @i_cl_telefono is null
	begin
      select @w_error =  1720383 
      goto ERROR_FIN
	end
	if @i_cl_direccion is null
   	begin
      select @w_error =  1720385 
      goto ERROR_FIN
	end

   	select @w_secuencia_inc = max(cl_secuencial) 
	from gd_cliente
	
	if @w_secuencia_inc is null
		select @w_secuencia_inc = 0
	
	select @w_secuencia_inc = @w_secuencia_inc + 1
   	
   	insert into cobis..gd_cliente(
   		cl_secuencial,		cl_cedula,		cl_nombre,		cl_apellido,		cl_telefono, 
   		cl_direccion, 		cl_estado)
   	values(
   		@w_secuencia_inc, 	@i_cl_cedula, 	@i_cl_nombre, 	@i_cl_apellido, 	@i_cl_telefono,   
   		@i_cl_direccion,	@i_cl_estado)
end
	


--ACTUALIZAR
if @i_operacion = 'U'
begin
  	if @i_cl_cedula is null
    begin
      select @w_error =  1720368 
      goto ERROR_FIN
	end
	if @i_cl_nombre is null
    begin
      select @w_error =  1720369 
      goto ERROR_FIN
	end
	if @i_cl_apellido is null
    begin
      select @w_error =  1720370 
      goto ERROR_FIN
	end
	if @i_cl_telefono is null
	begin
      select @w_error =  1720383 
      goto ERROR_FIN
	end
	if @i_cl_direccion is null
   	begin
      select @w_error =  1720385 
      goto ERROR_FIN
	end  
   
   if exists(select cl_cedula from gd_cliente where cl_cedula = @i_cl_cedula)
   begin
   		update gd_cliente 
   		set	cl_nombre = @i_cl_nombre,
   			cl_apellido = @i_cl_apellido,
   			cl_telefono = @i_cl_telefono,
   			cl_direccion = @i_cl_direccion
   		where cl_cedula = @i_cl_cedula   			
   end
end

--BORRAR
if @i_operacion = 'D'
begin
	if @i_cl_cedula is null
    begin
      select @w_error =  1720368 
      goto ERROR_FIN
	end
	
	if exists(select cl_cedula from gd_cliente where cl_cedula = @i_cl_cedula )
   begin
   		update gd_cliente
   		set	cl_estado = 'D'
   		where cl_cedula = @i_cl_cedula 
   end
	select 
	'cedula' 	= cl_cedula,
   	'nombre' 	= cl_nombre,
   	'apellido' 	= cl_apellido,
   	'telefono' 	= cl_telefono,
   	'direccion'	= cl_direccion,
   	'estado'	= cl_estado
	from gd_cliente
end


--CONSULTA POR NOMBRE O APELLIDO
if @i_operacion = 'Q'
begin
  	if @i_cl_cedula is null
    begin
      select @w_error =  1720368 
      goto ERROR_FIN
	end
	
   	select 
	'cedula' 	= cl_cedula,
   	'nombre' 	= cl_nombre,
   	'apellido' 	= cl_apellido,
   	'telefono' 	= cl_telefono,
   	'direccion'	= cl_direccion
	from gd_cliente
	where 	cl_nombre 	= '%'+@i_buscar_cli+'%'
	or		cl_apellido	= '%'+@i_buscar_cli+'%'
end

--CONSULTAR TODO
if @i_operacion = 'S'
begin
  	select 
	'cedula' 	= cl_cedula,
   	'nombre' 	= cl_nombre,
   	'apellido' 	= cl_apellido,
   	'telefono' 	= cl_telefono,
   	'direccion'	= cl_direccion,
   	'estado'	= cl_estado
	from gd_cliente
	where cl_estado like 'V'
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
