package eu.eidas.node.security;

import eu.eidas.auth.commons.EIDASErrors;
import eu.eidas.auth.commons.EIDASUtil;
import eu.eidas.auth.commons.EIDASValues;
import eu.eidas.auth.commons.exceptions.SecurityEIDASException;
import eu.eidas.node.ApplicationContextProvider;
import eu.eidas.node.NodeBeanNames;
import eu.eidas.node.logging.LoggingMarkerMDC;
import eu.eidas.node.utils.CountrySpecificUtil;
import eu.eidas.node.utils.SessionHolder;

import org.apache.commons.lang.StringUtils;
import org.owasp.esapi.StringUtilities;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * @author vanegdi
 */
public class SecurityRequestFilter  extends AbstractSecurityRequest implements Filter {

    /**
     * Logger object.
     */
    private static final Logger LOG = LoggerFactory.getLogger(SecurityRequestFilter.class.getName());
    /**
     * Configured on the web.xml
     * Servlets to which apply this filter
     * Its a kind of interceptor as how was with struts
     */
    private String includedServlets;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOG.info(LoggingMarkerMDC.SYSTEM_EVENT, "Init of SecurityRequestFilter filter");
        this.includedServlets = filterConfig.getInitParameter("includedServlets");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        LOG.trace("Execution Of filter");
        servletRequest.setCharacterEncoding("UTF-8");
        final HttpServletRequest request = (HttpServletRequest) servletRequest;
        ApplicationContext context = ApplicationContextProvider.getApplicationContext();
        this.setConfigurationSecurityBean((ConfigurationSecurityBean) context.getBean(NodeBeanNames.SECURITY_CONFIG.toString()));

        // Class Name of the Action being invoked
        final String pathInvoked = StringUtils.remove(request.getServletPath(),"/");
        
        if (!matchIncludedServlets(pathInvoked)) {
            LOG.debug("Not filtered path="+pathInvoked);
            filterChain.doFilter(servletRequest, servletResponse);
            return;
        }

        // get domain
        String domain = request.getHeader(EIDASValues.REFERER.toString());

        boolean performDomainCheck = !getConfigurationSecurityBean().getBypassValidation();

        if("ColleagueResponse".equals(pathInvoked)){
            if(CountrySpecificUtil.isRequestAllowed((HttpServletRequest)servletRequest)) {
                performDomainCheck = false;
            }
        }else if("cspReportHandler".equals(pathInvoked)) {
            performDomainCheck = false;
        }
        if (performDomainCheck) {
            LOG.debug("Performing domain check");
            if (domain == null) {
                LOG.info(LoggingMarkerMDC.SECURITY_WARNING, "Domain is null");
                final String errorCode = EIDASUtil.getConfig(EIDASErrors.DOMAIN.errorCode(pathInvoked));
                final String errorMsg = EIDASUtil.getConfig(EIDASErrors.DOMAIN.errorMessage(pathInvoked));
                throw new SecurityEIDASException(errorCode, errorMsg);
            }

            domain = domain.substring(domain.indexOf("://") + this.THREE);
            // Validate if URL ends with "/"
            final int indexStr = domain.indexOf('/');
            if (indexStr > 0) {
                domain = domain.substring(0, indexStr);
            }
            // ***CHECK DOMAIN**/
            if (this.getConfigurationSecurityBean().getValidationMethod().equalsIgnoreCase(EIDASValues.DOMAIN.toString())) {
                this.checkDomain(domain, pathInvoked, request);
            }
            // ***CHECK IPS**/

            if (this.getConfigurationSecurityBean().getIpMaxRequests() != -1) {
                this.checkRequest(request.getRemoteAddr(), this.getConfigurationSecurityBean().getIpMaxTime(), this.getConfigurationSecurityBean().getIpMaxRequests(), pathInvoked, this.spIps);
            }

            // ***CHECK SP**/

            if (this.getConfigurationSecurityBean().getSpMaxRequests() != -1) {
                this.checkRequest(domain, this.getConfigurationSecurityBean().getSpMaxTime(), this.getConfigurationSecurityBean().getSpMaxRequests(), pathInvoked, this.spRequests);
            }

        }
        filterChain.doFilter(servletRequest, servletResponse);
        SessionHolder.clear();
    }

    private boolean matchIncludedServlets(String url) {
        if(!StringUtilities.isEmpty(url) && !StringUtilities.isEmpty(this.includedServlets)){
            List<String> servlets = Arrays.asList(this.includedServlets.split("\\s*,\\s*"));
            if(servlets.contains(url)){
                return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {
        LOG.info(LoggingMarkerMDC.SYSTEM_EVENT, "Destroy of SecurityRequestFilter filter");
    }
}
