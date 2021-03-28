/*
 * Archivo: VA_VABUTTONPKAEMEM_461220.java
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

package com.cobiscorp.cobis.gdfct.customevents.impl.view.executecommand;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.ReferenceCardinality;
import org.apache.felix.scr.annotations.Service;
import com.cobiscorp.cobis.commons.domains.log.ILogger;
import com.cobiscorp.cobis.commons.log.LogFactory;
import com.cobiscorp.designer.api.DynamicRequest;
import com.cobiscorp.designer.api.customization.IExecuteCommand;
import com.cobiscorp.designer.api.customization.arguments.IExecuteCommandEventArgs;
import com.cobiscorp.designer.api.managers.DesignerManagerException;
import com.cobiscorp.designer.bli.api.IBLIExecutor;

@Component
@Service({ IExecuteCommand.class })
@Properties(value={
		@Property(name = "view.id", value = "VW_CLIENTEJHW_220"),
		@Property(name = "view.version", value = "1.0.0"),
		@Property(name = "view.controlId", value = "VA_VABUTTONPKAEMEM_461220")})

public class VA_VABUTTONPKAEMEM_461220 implements IExecuteCommand {
	/**
	 * Instancia de Logger
	 */
	private static final ILogger logger = LogFactory.getLogger(VA_VABUTTONPKAEMEM_461220.class);

	//OSGI
			//Para cargar en memoria
			//Rference de apache felix
			@Reference(
					bind="setBliActuaCliente",
					unbind="unsetBliActuaCliente",
					cardinality = ReferenceCardinality.MANDATORY_UNARY, //ReferenceCardinality de apache felix
					target = "(bli.id=BLI1616_bli_clientefactura_actualizar)" //colocar el id de la bli (aqui se atan con el bli)
					)
			private IBLIExecutor bliActuaCliente; // la bli.id se instancia en esta variable (bliCrearEmpresa)
			
			//Metho set and unset
			//OSGI llama estos metodos 
			public void setBliActuaCliente(IBLIExecutor bliActuaCliente){
				this.bliActuaCliente = bliActuaCliente;
			}
			public void unsetBliActuaCliente(IBLIExecutor bliActuaCliente){
				this.bliActuaCliente = null;
			}
		
	
	@Override
	public void executeCommand(DynamicRequest arg0, IExecuteCommandEventArgs arg1) {
		// TODO Auto-generated method stub
		try {
			if (logger.isDebugEnabled()) {
				logger.logDebug("Start executeCommand in VA_VABUTTONPKAEMEM_461220");
				logger.logDebug("RSRM ejecutando bli....");
			}
			
			bliActuaCliente.execute(arg0);
			logger.logDebug("RSRM termino de ejecutar bli!!");
			
		} catch (Exception ex) {
			DesignerManagerException.handleException(arg1.getMessageManager(), ex, logger);
		}
	}

}

