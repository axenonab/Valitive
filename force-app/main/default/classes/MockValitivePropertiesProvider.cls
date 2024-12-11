@IsTest
public class MockValitivePropertiesProvider implements IValitivePropertiesProvider {
    private String baseURL;
    private String tokenEndpoint;
    private String grantType;
    private String username;
    private String password;
    private String privateMonitoringSetId;
    private String organisationMonitoringSetId;

    public MockValitivePropertiesProvider withBaseURL(String baseURL) {
        this.baseURL = baseURL;
        return this;
    }

    public MockValitivePropertiesProvider withTokenEndpoint(String tokenEndpoint) {
        this.tokenEndpoint = tokenEndpoint;
        return this;
    }

    public MockValitivePropertiesProvider withGrantType(String grantType) {
        this.grantType = grantType;
        return this;
    }

    public MockValitivePropertiesProvider withUsername(String username) {
        this.username = username;
        return this;
    }

    public MockValitivePropertiesProvider withPassword(String password) {
        this.password = password;
        return this;
    }

    public MockValitivePropertiesProvider withPrivateMonitoringSetId(String id) {
        this.privateMonitoringSetId = id;
        return this;
    }

    public MockValitivePropertiesProvider withOrganisationMonitoringSetId(String id) {
        this.organisationMonitoringSetId = id;
        return this;
    }

    public String getBaseURL() {
        return baseURL;
    }

    public String getTokenEndpoint() {
        return tokenEndpoint;
    }

    public String getGrantType() {
        return grantType;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getPrivateMonitoringSetId() {
        return privateMonitoringSetId;
    }

    public String getOrganisationMonitoringSetId() {
        return organisationMonitoringSetId;
    }
}
