/*
 * Archivo: ProductosQuery_QV_LL78_JDE11.java
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

package com.cobiscorp.cobis.gdfct.customevents.impl.queryview.rowdeleting;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.ReferenceCardinality;
import org.apache.felix.scr.annotations.Service;
import com.cobiscorp.cobis.commons.domains.log.ILogger;
import com.cobiscorp.cobis.commons.log.LogFactory;
import com.cobiscorp.designer.api.DataEntity;
import com.cobiscorp.designer.api.customization.IGridRowDeleting;
import com.cobiscorp.designer.api.customization.arguments.IGridRowActionEventArgs;
import com.cobiscorp.designer.api.managers.DesignerManagerException;
import com.cobiscorp.designer.bli.api.IBLIExecutor;

@Component
@Service({ IGridRowDeleting.class })
@Properties({ @Property(name = "queryView.id", value = "QV_LL78_JDE11"),
 			  @Property(name = "queryView.controlId", value = "QV_LL78_JDE11")})

public class ProductosQuery_QV_LL78_JDE11 implements IGridRowDeleting {
	/**
	 * Instancia de Logger
	 */
	private static final ILogger logger = LogFactory.getLogger(ProductosQuery_QV_LL78_JDE11.class);

	@Reference(bind = "setBliEliminarProducto", 
			unbind = "unsetBliEliminarProducto", 
			cardinality = ReferenceCardinality.MANDATORY_UNARY, 
			target = "(bli.id=BLI6155_bli_borrarproduucto)")
	private IBLIExecutor bliEliminarProductos;

	public void setBliEliminarProducto(IBLIExecutor bliEliminarProductos) {
		this.bliEliminarProductos = bliEliminarProductos;
	}

	public void unsetBliEliminarProducto(IBLIExecutor bliEliminarProductos) {
		this.bliEliminarProductos = null;
	}

	@Override
	public void rowAction(DataEntity arg0, IGridRowActionEventArgs arg1) {
		try {
			if (logger.isDebugEnabled()) {
				logger.logDebug("Start rowAction in ProductosQuery_QV_LL78_JDE11");
		        logger.logDebug("Ejecutando el borrado logico del producto...");
			} 
			
			bliEliminarProductos.execute(arg1.getDynamicRequest());
	      	logger.logDebug("Ejecucion finalizada...");
	      	
		} catch (Exception ex) {
			DesignerManagerException.handleException(arg1.getMessageManager(), ex, logger);
		}
	}

}

