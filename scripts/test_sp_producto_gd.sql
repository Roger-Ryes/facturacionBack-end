--INSERTAR
exec sp_producto_gd 
	@i_operacion = 'I',
	@i_pr_codigo ='BBBB',
	@i_pr_nombre ='testing4',
   	@i_pr_stock	 =20,
   	@i_pr_precio =4.23

--ACTUALIZAR
exec sp_producto_gd 
	@i_operacion = 'U',
	@i_pr_codigo ='aaaa',
	@i_pr_nombre ='testing1',
   	@i_pr_stock	 =50,
   	@i_pr_precio =30.5


--BORRAR
exec sp_producto_gd 
	@i_operacion = 'D',
	@i_pr_codigo ='aaaa'


--MOSTRAR TODO
exec sp_producto_gd 
	@i_operacion = 'S'
