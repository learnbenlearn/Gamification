public class AssociateTeamAssignment_Utility {    
    @InvocableMethod(label='Get Selected Associates By Id' description='Retrieves all associates whose Id is in provided list of Ids.')
    public static List<List<Associate__c>> getSelectedAssociatesById(List<List<String>> nestedAssociateIds) {
        List<List<Associate__c>> retrievedAssociateList = new List<List<Associate__c>>();
        
        List<String> associateIds = nestedAssociateIds[0][0].split('; ');
        
        retrievedAssociateList.add([SELECT Id, Team__c FROM Associate__c WHERE Id IN :associateIds]);
        
        return retrievedAssociateList;
    }
}