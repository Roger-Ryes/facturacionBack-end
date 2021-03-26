use cobis 
go

declare @w_pd_procedure 	int,
		@w_pt_transaccion 	int,
		@w_id_rol			int,
		@w_id_producto		int


-- obtengo el pd_procedure (es posible que deba cambiar la pd_stored_procedure)
select @w_pd_procedure = pd_procedure 
from ad_procedure where 
pd_stored_procedure ='sp_producto_gd'


-- obtengo el id_rol (es posible que deba cambiar la descripcion)
select @w_id_rol = ro_rol
from ad_rol
where ro_descripcion = 'CAPACITACION'


-- obtengo el id_producto de cobis
select @w_id_producto = pd_producto
from cl_producto
where pd_descripcion = 'CLIENTES'


-- Eliminos los permisos y el sp
if @w_pd_procedure is not null
begin	
	if exists(select 1 from ad_pro_transaccion where pt_procedure = @w_pd_procedure)
	begin
		select @w_pt_transaccion = 1
		from ad_pro_transaccion
		where pt_procedure = @w_pd_procedure

		if @w_pt_transaccion is not null
			begin
				delete ad_tr_autorizada 
				where ta_transaccion in (
					select pt_transaccion
					from ad_pro_transaccion
					where pt_procedure = @w_pd_procedure
				)						
			end
			
		delete ad_pro_transaccion 
		where pt_procedure = @w_pd_procedure
	end
	
	delete ad_procedure 
	where pd_stored_procedure='sp_producto_gd'
end

-- obtengo el maximo pd_proceduro y aumento en 1
select @w_pd_procedure = max(pd_procedure) + 1
from ad_procedure
where pd_procedure between (@w_id_producto * 1000) and ((@w_id_producto + 1) * 1000)


-- inserto el sp
insert into ad_procedure
	(pd_procedure, 		pd_stored_procedure, 	pd_base_datos, 	pd_estado,
	 pd_fecha_ult_mod, 	pd_archivo)
values	
	(@w_pd_procedure, 	'sp_producto_gd', 		'cobis', 		'V', 		
	 getdate(), 		'sp_producto.sp')
	 

-- obtengo el maximo pt_transaccion y aumento en 1
select @w_pt_transaccion = max(pt_transaccion) + 1 
from ad_pro_transaccion
where pt_producto = @w_id_producto


-- inserto la relacion producto - sp
insert into ad_pro_transaccion 
	(pt_producto,		pt_tipo, 			pt_moneda, 			pt_transaccion, 	
	 pt_estado, 		pt_fecha_ult_mod, 	pt_procedure, 		pt_especial)
values 	
	(@w_id_producto, 	'R', 				0, 					@w_pt_transaccion, 	
	 'V', 				getdate(), 			@w_pd_procedure, 	NULL)


-- inserto la autorizacion
insert into ad_tr_autorizada 
	(ta_producto, 		ta_tipo, 		ta_moneda, 		ta_transaccion, 
	 ta_rol, 			ta_fecha_aut, 	ta_autorizante, ta_estado, 
	 ta_fecha_ult_mod)
VALUES 
	(@w_id_producto, 	'R', 			0, 				@w_pt_transaccion, 
	 @w_id_rol, 		getdate(), 		@w_id_producto, 'V', 
	 getdate())


select @w_pd_procedure --172101

select @w_pt_transaccion --7067




