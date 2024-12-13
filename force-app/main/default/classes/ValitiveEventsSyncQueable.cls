public class ValitiveEventsSyncQueable implements Queueable, Database.AllowsCallouts {
    
    private String entity;
    private Map<String, Object> params;

    public ValitiveEventsSyncQueable(String entity, Map<String, Object> params){
        this.entity = entity;
        this.params = params;
    }

    public ValitiveEventsSyncQueable(String entity){
        this.entity = entity;
    }

    public ValitiveEventsSyncQueable(){
    }

    public void setEntity(String entity){
        this.entity = entity;
    }

    public void setParams(Map<String, Object> params){
        this.params = params;
    }

    public void execute(QueueableContext context){
        HttpResponse response = ValitiveEventsSync.syncEvents(entity, params);
        
    }
}

