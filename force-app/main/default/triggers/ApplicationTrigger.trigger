trigger ApplicationTrigger on Application__c (before insert, before update, after delete, after undelete) {
    List<Room__c> roomsToUpdate = new List<Room__c>();
    if(trigger.isBefore) {
        List<Room__c> rooms = [select id,Building__r.Name , name,Room_Number__c from Room__c where is_Available__c=true order by Building__r.Name, Room_Number__c];
        if(trigger.isInsert) {
            if(!rooms.isEmpty() && rooms.size() >= trigger.new.size()) {
                Integer counter = 0;
                for(Application__c app : trigger.new) {
                    app.room__c = rooms[counter].Id;
                    Room__c roomins = new Room__c(Id=rooms[counter].Id,is_Available__c=false);
                    roomsToUpdate.add(roomins);
                    counter +=1 ;
                }
            }
        }
        if(trigger.isUpdate) {
            for(Application__c app : trigger.new) {
                if(app.room__c != trigger.oldMap.get(app.id).room__c && trigger.oldMap.get(app.id).room__c!=null) {//updating room directly, and prev one was not null.
                    if(app.room__c != null) {
                        Room__c roomNew = new Room__c(Id=app.room__c,is_Available__c=false);
                        roomsToUpdate.add(roomNew);
                    }
                    if(trigger.oldMap.get(app.id).room__c!=null) {
                        Room__c roomOld = new Room__c(Id=trigger.oldMap.get(app.id).room__c,is_Available__c=true);
                        roomsToUpdate.add(roomOld);
                    }
                }
            }
        }
    }
    if(trigger.IsAfter) {
        if(trigger.isDelete) {
            for(Application__c app : trigger.old) {
                Room__c roomNew = new Room__c(Id=app.room__c,is_Available__c=true);
                roomsToUpdate.add(roomNew);
            }
        }
        if(trigger.isUndelete) {
            for(Application__c app : trigger.new) {
                Room__c roomNew = new Room__c(Id=app.room__c,is_Available__c=false);
                roomsToUpdate.add(roomNew);
            }
        }
    }
    update roomsToUpdate;
}