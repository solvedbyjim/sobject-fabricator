global class SObjectFabricatorFacade implements I_SObjectBuilder {
    sfab_FabricatedSObject fabricatedRecord;

    global SObjectFabricatorFacade build(sObject record){
        build(record.getSObjectType().getDescribe().getName());
        set(record.getPopulatedFieldsAsMap());
        return this;
    }
    global SObjectFabricatorFacade build(String objectName){
        build(Type.forName(objectName));
        return this;
    }
    global SObjectFabricatorFacade build( Type sType ){
        this.fabricatedRecord = new sfab_FabricatedSObject( sType );
        return this;
    }
    global SObjectFabricatorFacade set(String fieldName, Object value){
        try{
            fabricatedRecord.set(fieldName,value);
        } catch(sfab_FabricatedSObject.FieldDoesNotExistException e){
            throw new SObjectBuilderUtilities.FieldDoesNotExistException(e.getMessage(),e);
        }
        
        return this;
    }
    global SObjectFabricatorFacade set( Schema.SObjectField field, Object value){
        fabricatedRecord.set(field,value);
        return this;
    }
    global SObjectFabricatorFacade set( Map<Schema.SObjectField, Object> fields ){
        fabricatedRecord.set(fields);
        return this;
    }
    global SObjectFabricatorFacade set( Map<String, Object> fields){
       
        try{
            fabricatedRecord.set(fields);
        } catch(sfab_FabricatedSObject.FieldDoesNotExistException e){
            throw new SObjectBuilderUtilities.FieldDoesNotExistException(e.getMessage(),e);
        }
        return this;
    }

    global SObjectFabricatorFacade setParent( String relationshipName, sObject parent ){
        setParent(relationshipName, new SObjectFabricatorFacade().build(parent));
        return this;
    }

    global SObjectFabricatorFacade setParent( String relationshipName, I_SObjectBuilder builtParent ){
        SObjectFabricatorFacade parentFacade = (SObjectFabricatorFacade)builtParent;
        setParent(relationshipName,parentFacade.getFabricatedRecord());
        return this;
    }

    private SObjectFabricatorFacade setParent(String relationshipName,sfab_FabricatedSObject fabricatedParent){
        try{
            fabricatedRecord.set(relationshipName,fabricatedParent);
        }catch(sfab_FabricatedSObject.ParentRelationshipDoesNotExistException e){
            throw new SObjectBuilderUtilities.ParentRelationshipDoesNotExistException(e.getMessage(),e);
        }catch(sfab_FabricatedSObject.FieldIsNotParentRelationshipException e){
            throw new SObjectBuilderUtilities.FieldIsNotParentRelationshipException(e.getMessage(),e);
        }
        
        return this;
    }

    global SObjectFabricatorFacade setChildren( String relationshipName, List<I_SObjectBuilder> builtChildren ){
        list<sfab_FabricatedSObject> fabricatedChildren = new list<sfab_FabricatedSObject>();
        list<SObjectFabricatorFacade> childrenFacade = (list<SObjectFabricatorFacade>)builtChildren;
        for(SObjectFabricatorFacade builtChild:childrenFacade){
            fabricatedChildren.add(builtChild.getFabricatedRecord());
        }
        
        setChildren(relationshipName,fabricatedChildren);
        return this;
    }
    global SObjectFabricatorFacade setChildren( String relationshipName, List<sObject> children ){
        list<sfab_FabricatedSObject> fabricatedChildren = new list<sfab_FabricatedSObject>();
        for(sObject child:children){
            fabricatedChildren.add(new SObjectFabricatorFacade().build(child).getFabricatedRecord());
        }
        setChildren(relationshipName,fabricatedChildren);
        return this;
    }

    private SObjectFabricatorFacade setChildren(string relationshipName,list<sfab_FabricatedSObject> fabricatedChildren){
        try{
            fabricatedRecord.set(relationshipName, fabricatedChildren);
        } catch(sfab_FabricatedSObject.ChildRelationshipDoesNotExistException e){
            throw new SObjectBuilderUtilities.ChildRelationshipDoesNotExistException(e.getMessage(),e);
        }catch(sfab_FabricatedSObject.FieldIsNotChildRelationshipException e){
            throw new SObjectBuilderUtilities.FieldIsNotChildRelationshipException(e.getMessage(),e);
        }

        return this;
    }

    global SObjectFabricatorFacade addChildren( String relationshipName,List<I_SObjectBuilder> builtChildren ){
        list<SObjectFabricatorFacade> childrenFacade = (list<SObjectFabricatorFacade>)builtChildren;
        for(SObjectFabricatorFacade builtChild:childrenFacade){
            addChild(relationshipName,builtChild);
        }
        return this;
    }
    global SObjectFabricatorFacade addChildren( String relationshipName, List<sObject> children ){
        for(sObject child:children){
            addChild(relationshipName,child);
        }
        return this;
    }
    global SObjectFabricatorFacade addChild( String relationshipName, I_SObjectBuilder builtChild ){
        SObjectFabricatorFacade childFacade = (SObjectFabricatorFacade)builtChild;
        addChild(relationshipName, childFacade.getFabricatedRecord());
        return this;
    } 
    global SObjectFabricatorFacade addChild( String relationshipName, sObject child ){
        addChild(relationshipName, new SObjectFabricatorFacade().build(child).getFabricatedRecord());
        return this;
    }

    private SObjectFabricatorFacade addChild(String relationshipName, sfab_FabricatedSObject fabricatedChild){
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
