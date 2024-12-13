@IsTest
public class MockValitivePropertiesProvider implements IValitivePropertiesProvider {
    private String baseURL;
    private String tokenEndpoint;
    private String grantType;
    private String username;
    private String password;
    private String privateMonitoringSetId;
    private String organisationMonitoringSetId;
    private String clientId;
    private String clientSecret;
    private String apiVersion;

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

    public MockValitivePropertiesProvider withClientId(String clientId) {
        this.clientId = clientId;
        return this;
    }

    public MockValitivePropertiesProvider withClientSecret(String clientSecret) {
        this.clientSecret = clientSecret;
        return this;
    }

    public MockValitivePropertiesProvider withApiVersion(String apiVersion) {
        this.apiVersion = apiVersion;
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

    public String getClientId() {
        return clientId;
    }

    public String getClientSecret() {
        return clientSecret;
    }

    public String getApiVersion() {
        return apiVersion;
    }
}
