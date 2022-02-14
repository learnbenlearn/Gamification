/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-13-2022
 * @last modified by  : Ben Learn
**/
trigger AssociateTrigger on Associate__c (after update) {
    switch on Trigger.operationType {
        when AFTER_UPDATE {
            Point_Utility.totalTeamPoints(Trigger.new);
        }
    }
}