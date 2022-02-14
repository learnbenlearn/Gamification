/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-13-2022
 * @last modified by  : Ben Learn
**/
trigger AssociateActivityTrigger on Associate_Activity__c (before insert, after insert) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            Point_Utility.assignPoints(Trigger.new);
        }
        when AFTER_INSERT {
            Point_Utility.totalAssociatePoints(Trigger.new);
        }
    }
}