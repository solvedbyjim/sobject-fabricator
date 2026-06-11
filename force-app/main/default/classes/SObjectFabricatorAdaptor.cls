global class SObjectFabricatorAdaptor implements SObjectBuilder {
    sfab_FabricatedSObject fabricatedRecord;

    global SObjectFabricatorAdaptor build(sObject record){
        build(record.getSObjectType().getDescribe().getName());
        set(record.getPopulatedFieldsAsMap());
        return this;
    }
    global SObjectFabricatorAdaptor build(String objectName){
        build(Type.forName(objectName));
        return this;
    }
    global SObjectFabricatorAdaptor build( Type sType ){
        this.fabricatedRecord = new sfab_FabricatedSObject( sType );
        return this;
    }
    global SObjectFabricatorAdaptor set(String fieldName, Object value){
        try{
            fabricatedRecord.set(fieldName,value);
        } catch(sfab_FabricatedSObject.FieldDoesNotExistException e){
            throw new SObjectBuilderUtilities.FieldDoesNotExistException(e.getMessage(),e);
        }
        
        return this;
    }
    global SObjectFabricatorAdaptor set( Schema.SObjectField field, Object value){
        fabricatedRecord.set(field,value);
        return this;
    }
    global SObjectFabricatorAdaptor set( Map<Schema.SObjectField, Object> fields ){
        fabricatedRecord.set(fields);
        return this;
    }
    global SObjectFabricatorAdaptor set( Map<String, Object> fields){
       
        try{
            fabricatedRecord.set(fields);
        } catch(sfab_FabricatedSObject.FieldDoesNotExistException e){
            throw new SObjectBuilderUtilities.FieldDoesNotExistException(e.getMessage(),e);
        }
        return this;
    }

    global SObjectFabricatorAdaptor setParent( String relationshipName, sObject parent ){
        setParent(relationshipName, new SObjectFabricatorAdaptor().build(parent));
        return this;
    }

    global SObjectFabricatorAdaptor setParent( String relationshipName, SObjectBuilder builtParent ){
        SObjectFabricatorAdaptor parentFacade = (SObjectFabricatorAdaptor)builtParent;
        setParent(relationshipName,parentFacade.getFabricatedRecord());
        return this;
    }

    private SObjectFabricatorAdaptor setParent(String relationshipName,sfab_FabricatedSObject fabricatedParent){
        try{
            fabricatedRecord.set(relationshipName,fabricatedParent);
        }catch(sfab_FabricatedSObject.ParentRelationshipDoesNotExistException e){
            throw new SObjectBuilderUtilities.ParentRelationshipDoesNotExistException(e.getMessage(),e);
        }catch(sfab_FabricatedSObject.FieldIsNotParentRelationshipException e){
            throw new SObjectBuilderUtilities.FieldIsNotParentRelationshipException(e.getMessage(),e);
        }
        
        return this;
    }

    global SObjectFabricatorAdaptor setChildren( String relationshipName, List<SObjectBuilder> builtChildren ){
        list<sfab_FabricatedSObject> fabricatedChildren = new list<sfab_FabricatedSObject>();
        list<SObjectFabricatorAdaptor> childrenFacade = (list<SObjectFabricatorAdaptor>)builtChildren;
        for(SObjectFabricatorAdaptor builtChild:childrenFacade){
            fabricatedChildren.add(builtChild.getFabricatedRecord());
        }
        
        setChildren(relationshipName,fabricatedChildren);
        return this;
    }
    global SObjectFabricatorAdaptor setChildren( String relationshipName, List<sObject> children ){
        list<sfab_FabricatedSObject> fabricatedChildren = new list<sfab_FabricatedSObject>();
        for(sObject child:children){
            fabricatedChildren.add(new SObjectFabricatorAdaptor().build(child).getFabricatedRecord());
        }
        setChildren(relationshipName,fabricatedChildren);
        return this;
    }

    private SObjectFabricatorAdaptor setChildren(string relationshipName,list<sfab_FabricatedSObject> fabricatedChildren){
        try{
            fabricatedRecord.set(relationshipName, fabricatedChildren);
        } catch(sfab_FabricatedSObject.ChildRelationshipDoesNotExistException e){
            throw new SObjectBuilderUtilities.ChildRelationshipDoesNotExistException(e.getMessage(),e);
        }catch(sfab_FabricatedSObject.FieldIsNotChildRelationshipException e){
            throw new SObjectBuilderUtilities.FieldIsNotChildRelationshipException(e.getMessage(),e);
        }

        return this;
    }

    global SObjectFabricatorAdaptor addChildren( String relationshipName,List<SObjectBuilder> builtChildren ){
        list<SObjectFabricatorAdaptor> childrenFacade = (list<SObjectFabricatorAdaptor>)builtChildren;
        for(SObjectFabricatorAdaptor builtChild:childrenFacade){
            addChild(relationshipName,builtChild);
        }
        return this;
    }
    global SObjectFabricatorAdaptor addChildren( String relationshipName, List<sObject> children ){
        for(sObject child:children){
            addChild(relationshipName,child);
        }
        return this;
    }
    global SObjectFabricatorAdaptor addChild( String relationshipName, SObjectBuilder builtChild ){
        SObjectFabricatorAdaptor childFacade = (SObjectFabricatorAdaptor)builtChild;
        addChild(relationshipName, childFacade.getFabricatedRecord());
        return this;
    } 
    global SObjectFabricatorAdaptor addChild( String relationshipName, sObject child ){
        addChild(relationshipName, new SObjectFabricatorAdaptor().build(child).getFabricatedRecord());
        return this;
    }

    private SObjectFabricatorAdaptor addChild(String relationshipName, sfab_FabricatedSObject fabricatedChild){
        try{
            fabricatedRecord.add(relationshipName,fabricatedChild);
        }catch(sfab_FabricatedSObject.ChildRelationshipDoesNotExistException e){
            throw new SObjectBuilderUtilities.ChildRelationshipDoesNotExistException(e.getMessage(),e);
        }catch(sfab_FabricatedSObject.FieldIsNotChildRelationshipException e){
            throw new SObjectBuilderUtilities.FieldIsNotChildRelationshipException(e.getMessage(),e);
        }
        return this;
    }

    global sObject toSObject(){
        return fabricatedRecord.toSObject();
    }

    @testvisible
    private sfab_FabricatedSObject getFabricatedRecord(){
        return this.fabricatedRecord;
    }



}
