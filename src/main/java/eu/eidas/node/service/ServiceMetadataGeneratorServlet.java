/*
 * This work is Open Source and licensed by the European Commission under the
 * conditions of the European Public License v1.1
 *
 * (http://www.osor.eu/eupl/european-union-public-licence-eupl-v.1.1);
 *
 * any use of this file implies acceptance of the conditions of this license.
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,  WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */
package eu.eidas.node.service;

import eu.eidas.node.NodeBeanNames;
import eu.eidas.node.connector.AbstractConnectorServlet;
import eu.eidas.node.utils.EidasNodeMetadataGenerator;
import eu.eidas.node.utils.PropertiesUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * generates metadata used to communicate with the ProxyService.
 */
public class ServiceMetadataGeneratorServlet extends AbstractConnectorServlet{
    /**
     * Logger object.
     */
    private static final Logger LOG = LoggerFactory.getLogger(ServiceMetadataGeneratorServlet.class.getName());
    //TODO: ProxyService requester metadata generator belongs in fact to the Specific module  
    private static final String REQUESTER_METADATA_URL="/ServiceRequesterMetadata";

    @Override
    protected Logger getLogger() {
        return LOG;
    }

    //ProxyService presents itself as both an IdP (to the Connectors) and as an SP (to IdP)

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String generatorName=request.getServletPath().startsWith(REQUESTER_METADATA_URL)?NodeBeanNames.SERVICE_AS_REQUESTER_METADATA_GENERATOR.toString():NodeBeanNames.SERVICE_METADATA_GENERATOR.toString();
        LOG.debug("generator ="+generatorName);
        EidasNodeMetadataGenerator generator = (EidasNodeMetadataGenerator)getApplicationContext().getBean(generatorName);
        boolean proxy = true;
        try {
            PropertiesUtil.checkProxyServiceActive();
        } catch (Exception e) {
            proxy = false;
            LOG.debug("on s'en fout ="+e.getMessage());
        }
        if(PropertiesUtil.isMetadataEnabled()) {
            if(proxy){
                response.getOutputStream().print(generator.generateServiceMetadata());
            }else{
                response.getOutputStream().print(generator.generateConnectorMetadata());
            }
        }else{
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
