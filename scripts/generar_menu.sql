use cobis
go

declare @w_id_menu 		int,
		@w_id_producto 	int,
		@w_id_url 		varchar(300),
		@w_id_rol 		int

-- modificar direccion
select @w_id_url = 'views/FCTRC/FCTRS/T_FCTRCDNPYMMXS_543/1.0.0/VC_LISTACLINE_718543_TASK.html'


-- obtengo el id_menu en caso de que exista
select @w_id_menu = me_id from cew_menu where me_url = @w_id_url


-- obtengo el id_rol (es posible que deba cambiar la descripcion)
select @w_id_rol = ro_rol
from ad_rol
where ro_descripcion = 'SEMILLERO'


-- borro la asociacion del rol al menu en caso de existir 
if @w_id_menu is not null and exists(select 1 from cew_menu_role where mro_id_menu = @w_id_menu and mro_id_role = @w_id_rol)
begin
	print 'borrando...'
	delete from cew_menu_role where mro_id_menu = @w_id_menu and mro_id_role = @w_id_rol
end


-- borro el menu en caso de existir de lo contrario obtengo el maximo id_menu y aumento 1
if exists(select 1 from cew_menu where me_url = @w_id_url)
begin
	print 'borrando...'
	delete from cew_menu where me_url = @w_id_url
end
else
begin
	-- obtengo el maximo id_menu y aumento 1
	select @w_id_menu = max(me_id)
	from cew_menu
	
	select @w_id_menu = @w_id_menu + 1
end


-- obtengo el id_producto de cobis
select @w_id_producto = pd_producto
from cl_producto
where pd_descripcion = 'CLIENTES'


-- imprimo para ver si la ejecucion va bien hasta aca
print 'id menu: '+convert(varchar(10), @w_id_menu)
print 'id producto: '+convert(varchar(10), @w_id_producto)


-- inserto el menu en la tabla cew_menu 
-- me_id_parent hace refente al menu padre y puede cambiar
-- modificar me_name (nombre del menu)
-- modificar me_descripcion (una breve explicacion de que hace el menu)
insert into dbo.cew_menu (
		me_id,						me_id_parent,			me_name,						me_visible,
		me_url,						me_order,				me_id_cobis_product,			me_option,
		me_description,				me_version,				me_container)
values (
		@w_id_menu,					2895,					'MNU_JCRR_GRID_CLIENTE',		1,
		@w_id_url,					1,						@w_id_producto,					0,
		'JCRR listado clientes',	null,					'CWC')


-- inserto la asociacion del rol al menu en la tabla cew_menu_role
insert into cew_menu_role (
		mro_id_menu,	mro_id_role)
values (
		@w_id_menu,		@w_id_rol)
		

select * from cew_menu where me_name = 'MNU_JEAN_RAVE' --2895
