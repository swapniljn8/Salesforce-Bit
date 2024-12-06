//Three objects : Vehicle, Car, Bike. 
//Vehicle : No_veh, No_car, No_bike
//on insert car and bike it should increase count on the vehicle 

//bike : trigger : after insert, after update, 


trigger Car on Car__c(after insert, after delete, after undelete) {
    VehicleHelper.updateCount(trigger.New, trigger.oldMap, trigger.newMap, 'Car');
}
trigger Vehicle on Vehicle`__c(after insert, after delete, after undelete) {
    VehicleHelper.updateCount(trigger.New, trigger.oldMap, trigger.newMap, 'Bike');
}
public class VehicleHelper {
    public static void updateCount(List<sObejct> newList, Map<Id,sObject> oldMap, String vehicleType) {
        Map<Id, Integer> carVehicleCountMap = new Map<Id, Integer>();
        Map<Id, Integer> bikeVehicleCountMap = new Map<Id, Integer>();
        if(!newList.isEmpty()) {
            for(sObject sob : newList) {
                if(sob.get('Vehicle__c')!=null) {//check whether it is already linked or not
                    if(vehicleCountMap.containsKey(Id.valueOf(sob.get('Vehicle__c'))) && vehicleType=='CAR') {
                        carVehicleCountMap[Id.valueOf(sob.get('Vehicle__c'))] = carVehicleCountMap.get(Id.valueOf(sob.get('Vehicle__c')))+1;
                    }
                    if(vehicleCountMap.containsKey(Id.valueOf(sob.get('Vehicle__c'))) && vehicleType=='BIKE') {
                        bikeVehicleCountMap[Id.valueOf(sob.get('Vehicle__c'))] = bikeVehicleCountMap.get(Id.valueOf(sob.get('Vehicle__c')))+1;
                    }
                }
            }
        }
        else if(!oldMap.isEmpty()) {
            for(Id vehId : oldMap.keySet()) {
                sObject sob = oldMap.get(vehId);
                if(sob.get('Vehicle__c')!=null) {//check whether it is already linked or not
                    if(vehicleCountMap.containsKey(Id.valueOf(sob.get('Vehicle__c'))) && vehicleType=='CAR') {
                        carVehicleCountMap[Id.valueOf(sob.get('Vehicle__c'))] = carVehicleCountMap.get(Id.valueOf(sob.get('Vehicle__c')))-1;
                    }
                    if(vehicleCountMap.containsKey(Id.valueOf(sob.get('Vehicle__c'))) && vehicleType=='BIKE') {
                        bikeVehicleCountMap[Id.valueOf(sob.get('Vehicle__c'))] = bikeVehicleCountMap.get(Id.valueOf(sob.get('Vehicle__c')))-1;
                    }

                }
            }
        }
        Set<Id> allIds = new Set<Id>();
        allIds.addAll(carVehicleCountMap.keySet());
        List<Vehicle__c> lstToUpdate = [select id,num_cars,num_bikes from Vehicle__c id IN: allIds];
        for(Vehicle__c veh : lstToUpdate) {
            veh.num_cars = veh.num_cars + carVehicleCountMap.get(veh.id);
            veh.num_bikes = veh.num_bikes + bikeVehicleCountMap.get(veh.id);
        }
    }
}
