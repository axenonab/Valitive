
public interface IValitivePropertiesProvider {
    String getBaseURL();
    String getTokenEndpoint();
    String getGrantType();
    String getUsername();
    String getPassword();
    String getPrivateMonitoringSetId();
    String getOrganisationMonitoringSetId();
}