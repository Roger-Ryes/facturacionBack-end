/*
 * Archivo: ClienteQuery_QV_ZT86_IDY87.java
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
@Properties({ @Property(name = "queryView.id", value = "QV_ZT86_IDY87"),
 			  @Property(name = "queryView.controlId", value = "QV_ZT86_IDY87")})

public class ClienteQuery_QV_ZT86_IDY87 implements IGridRowDeleting {
	/**
	 * Instancia de Logger
	 */
	private static final ILogger logger = LogFactory.getLogger(ClienteQuery_QV_ZT86_IDY87.class);

	//OSGI
		//Para cargar en memoria
		//Rference de apache felix
		@Reference(
				bind="setBliBorrCliente",
				unbind="unsetBliBorrCliente",
				cardinality = ReferenceCardinality.MANDATORY_UNARY, //ReferenceCardinality de apache felix
				target = "(bli.id=BLI9415_bli_clientefactura_borrar)" //colocar el id de la bli (aqui se atan con el bli)
				)
		private IBLIExecutor bliBorrCliente; // la bli.id se instancia en esta variable (bliCrearEmpresa)
		
		//Metho set and unset
		//OSGI llama estos metodos 
		public void setBliBorrCliente(IBLIExecutor bliBorrCliente){
			this.bliBorrCliente = bliBorrCliente;
		}
		public void unsetBliBorrCliente(IBLIExecutor bliBorrCliente){
			this.bliBorrCliente = null;
		}

	
	@Override
	public void rowAction(DataEntity arg0, IGridRowActionEventArgs arg1) {
		// TODO Auto-generated method stub
		try {
			if (logger.isDebugEnabled()) {
				logger.logDebug("Start rowAction in ClienteQuery_QV_ZT86_IDY87");
			}
			this.bliBorrCliente.execute(arg1.getDynamicRequest());
						
			
			
		} catch (Exception ex) {
			DesignerManagerException.handleException(arg1.getMessageManager(), ex, logger);
		}
	}

}

