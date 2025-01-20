public class MultiRequestMock implements HttpCalloutMock {
    Map<String, HttpCalloutMock> requests;

    public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    public HTTPResponse respond(HTTPRequest req) {
	HttpCalloutMock mock = requests.get(req.getEndpoint());
	    if (mock != null) {
            String endpoint = req.getEndpoint();

	        return mock.respond(req);
        } 
        CalloutException e = new CalloutException();
        e.setMessage('Request not supported: ' + req.getEndpoint());
        throw e;
	}

    public void addRequestMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }
    

    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}