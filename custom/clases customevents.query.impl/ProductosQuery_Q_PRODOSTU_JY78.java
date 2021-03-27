/*
 * Archivo: ProductosQuery_Q_PRODOSTU_JY78.java
 *
 * Esta aplicacion es parte de los paquetes bancarios propiedad de COBISCORP.
 * Su uso no autorizado queda expresamente prohibido asi como cualquier
 * alteracion o agregado hecho por alguno de sus usuarios sin el debido
 * consentimiento por escrito de COBISCORP.
 * Este programa esta protegido por la ley de derechos de autor y por las
 * convenciones internacionales de propiedad intelectual. Su uso no
 * autorizado dara derecho a COBISCORP para obtener ordenes de secuestro
 * o retencion y para perseguir penalmente a los autores de cualquier infraccion.
 */

package com.cobiscorp.cobis.gdfct.customevents.impl.query.executequery;

import java.util.List;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.ReferenceCardinality;
import org.apache.felix.scr.annotations.Service;

import com.cobiscorp.cobis.commons.domains.log.ILogger;
import com.cobiscorp.cobis.commons.log.LogFactory;
import com.cobiscorp.cobis.gdfct.model.Productos;
import com.cobiscorp.designer.api.DynamicRequest;
import com.cobiscorp.designer.api.customization.IExecuteQuery;
import com.cobiscorp.designer.api.customization.arguments.IExecuteQueryEventArgs;
import com.cobiscorp.designer.api.managers.DesignerManagerException;
import com.cobiscorp.designer.bli.api.IBLIExecutor;

@Component
@Service({ IExecuteQuery.class })
@Properties(value = { @Property(name = "query.id", value = "Q_PRODOSTU_JY78"),
		@Property(name = "query.version", value = "1.0.0") })

public class ProductosQuery_Q_PRODOSTU_JY78 implements IExecuteQuery {
	/**
	 * Instancia de Logger
	 */
	private static final ILogger logger = LogFactory.getLogger(ProductosQuery_Q_PRODOSTU_JY78.class);

	@Reference(bind = "setBliListaProducto", unbind = "unsetBliListaProducto", cardinality = ReferenceCardinality.MANDATORY_UNARY, target = "(bli.id=BLI1890_bli_listarproductos)")
	private IBLIExecutor bliListaProductos;

	public void setBliListaProducto(IBLIExecutor bliListaProductos) {
		this.bliListaProductos = bliListaProductos;
	}

	public void unsetBliListaProducto(IBLIExecutor bliListaProductos) {
		this.bliListaProductos = null;
	}

	@Override
	public List<?> executeDataEvent(DynamicRequest arg0, IExecuteQueryEventArgs arg1) {
		try {
			if (logger.isDebugEnabled()) {
				logger.logDebug("Start executeDataEvent in ProductosQuery_Q_PRODOSTU_JY78");
				logger.logDebug("Obteniendo los registros de la consulta...");
			}
			
			bliListaProductos.execute(arg0);
			
			logger.logDebug("Registros obtenidos...");
		} catch (Exception ex) {
			DesignerManagerException.handleException(arg1.getMessageManager(), ex, logger);
		}

		return arg0.getEntityList(Productos.ENTITY_NAME).getDataList();
	}

}
