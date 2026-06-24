public with sharing class FlexTemplateController {

    @AuraEnabled
    public static String getFlexTemplateResponse(String AccName, String rating) {
        Account acc = [SELECT Id, Name, Rating FROM Account WHERE Name LIKE :AccName LIMIT 1];

        Map<String, ConnectApi.WrappedValue> valueMap = new Map<String, ConnectApi.WrappedValue>();

        if (hasField('Product2', 'Rating__c')) {
            List<Product2> products = [SELECT Id, Name, Rating__c FROM Product2 WHERE Rating__c = :rating LIMIT 2];
            if (!products.isEmpty()) {
                Map<String, String> product1Map = new Map<String, String>{ 'id' => products[0].Id };
                ConnectApi.WrappedValue product1Wrapped = new ConnectApi.WrappedValue();
                product1Wrapped.value = product1Map;
                valueMap.put('Input:Product', product1Wrapped);
            }
            if (products.size() > 1) {
                Map<String, String> product2Map = new Map<String, String>{ 'id' => products[1].Id };
                ConnectApi.WrappedValue product2Wrapped = new ConnectApi.WrappedValue();
                product2Wrapped.value = product2Map;
                valueMap.put('Input:Product_2', product2Wrapped);
            }
        }

        if (hasField('Soft_Drink__c', 'Rating__c')) {
            List<Soft_Drink__c> softDrinks = [SELECT Id, Name, Rating__c FROM Soft_Drink__c WHERE Rating__c = :rating LIMIT 2];
            if (!softDrinks.isEmpty()) {
                Map<String, String> softDrink1Map = new Map<String, String>{ 'id' => softDrinks[0].Id };
                ConnectApi.WrappedValue softDrink1Wrapped = new ConnectApi.WrappedValue();
                softDrink1Wrapped.value = softDrink1Map;
                valueMap.put('Input:Soft_Drink', softDrink1Wrapped);
            }
            if (softDrinks.size() > 1) {
                Map<String, String> softDrink2Map = new Map<String, String>{ 'id' => softDrinks[1].Id };
                ConnectApi.WrappedValue softDrink2Wrapped = new ConnectApi.WrappedValue();
                softDrink2Wrapped.value = softDrink2Map;
                valueMap.put('Input:Soft_Drink2', softDrink2Wrapped);
            }
        }

        Map<String, String> account = new Map<String, String>{ 'id' => acc.Id };
        ConnectApi.WrappedValue accountWrappedValue = new ConnectApi.WrappedValue();
        accountWrappedValue.value = account;
        valueMap.put('Input:Account', accountWrappedValue);

        ConnectApi.EinsteinPromptTemplateGenerationsInput executeTemplateInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        executeTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        executeTemplateInput.additionalConfig.applicationName = 'PromptBuilderPreview';
        executeTemplateInput.isPreview = false;
        executeTemplateInput.inputParams = valueMap;

        try {
            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput =
                ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate('Customer_Pitch', executeTemplateInput);
            System.debug('Prompt Testing: ' + generationsOutput.generations[0].text);
            return generationsOutput.generations[0].text;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw e;
        }
    }

    private static Boolean hasField(String sObjectName, String fieldName) {
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName);
        if (sObjectType == null) {
            return false;
        }
        Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
        return fieldMap.containsKey(fieldName);
    }
}
