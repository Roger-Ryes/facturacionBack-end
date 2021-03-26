--INSERTAR
exec sp_cliente_gd
	@i_operacion	= 'I',
	@i_cl_cedula 	= '1725430139',
	@i_cl_nombre 	= 'Roberto',
	@i_cl_apellido 	= 'Perez',
	@i_cl_telefono 	= '0987281242',
	@i_cl_direccion = 'Carcelen'


--ACTUALIZAR
exec sp_cliente_gd
	@i_operacion	= 'U',
	@i_cl_cedula 	= '1725430139',
	@i_cl_nombre 	= 'Marta',
	@i_cl_apellido 	= 'Perez',
	@i_cl_telefono 	= '0987283476',
	@i_cl_direccion = 'Ajavi'


--BORRAR
exec sp_cliente_gd
	@i_operacion	= 'D',
	@i_cl_cedula 	= '1725430139'
	
	
--CONSULTA POR CODIGO
exec sp_cliente_gd
	@i_operacion	= 'Q',
	@i_cl_cedula 	= '1725430139'

--MOSTRAR TODO
exec sp_cliente_gd
	@i_operacion='S'
