/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-14-2022
 * @last modified by  : Ben Learn
**/
public with sharing class Point_Utility {
    public static Map<String, Decimal> activityPointMap;
    public static Map<Id, Activity__c> activityMap;

    static {
        List<Activity__c> activities = [SELECT Name, Points__c FROM Activity__c];

        activityPointMap = new Map<String, Decimal>();

        for(Activity__c activity : activities) {
            activityPointMap.put(activity.Name, activity.Points__c);
        }

        activityMap = new Map<Id, Activity__c>([SELECT Id, Name, Points__c FROM Activity__c]);
    }
    
    public static void assignPoints(List<Associate_Activity__c> associateActivities) {
        for(Associate_Activity__c aa : associateActivities) {
            if(aa.Points__c == null) {
                aa.Points__c = activityMap.get(aa.Activity__c).Points__c;
            }
        }
    }

    public static void totalAssociatePoints(List<Associate_Activity__c> associateActivities) {
        Map<Id, Decimal> associatePointMap = new Map<Id, Decimal>();
        Decimal associatePoints;

        for(Associate_Activity__c aa : associateActivities) {
            associatePoints = associatePointMap.get(aa.Associate__c);

            if(associatePoints == null) {
                associatePoints = aa.Points__c;
            } else {
                associatePoints += aa.Points__c;
            }

            associatePointMap.put(aa.Associate__c, associatePoints);
        }

        List<Associate__c> associatesToUpdate = [SELECT Id, Total_Points__c FROM Associate__c WHERE Id IN :associatePointMap.keySet()];

        for(Associate__c associate : associatesToUpdate) {
            if(associate.Total_Points__c == null) {
                associate.Total_Points__c = associatePointMap.get(associate.Id);
            } else {
                associate.Total_Points__c += associatePointMap.get(associate.Id);
            }
        }

        update associatesToUpdate;
    }

    public static void totalTeamPoints(List<Associate__c> associates) {
        Set<Id> teamIdsToUpdate = new Set<Id>();

        for(Associate__c associate : associates) {
            if(associate.Team__c != null) {
                teamIdsToUpdate.add(associate.Team__c);
            }
        }

        List<AggregateResult> associatesOnTeamsToUpdate = [SELECT SUM(Total_Points__c) totalPoints, Team__c team FROM Associate__c WHERE Team__c IN :teamIdsToUpdate AND Total_Points__c > 0 GROUP BY Team__c];
        
        Map<Id, Team__c> teamsToUpdateMap = new Map<Id, Team__c>([SELECT Total_Points__c FROM Team__c WHERE Id IN :teamIdsToUpdate]);

        for(AggregateResult ar : associatesOnTeamsToUpdate) {
            teamsToUpdateMap.get(String.valueOf(ar.get('team'))).Total_Points__c = Decimal.valueOf(String.valueOf(ar.get('totalPoints')));
        }

        update teamsToUpdateMap.values();
    }
}