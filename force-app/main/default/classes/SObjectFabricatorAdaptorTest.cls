@istest
public class SObjectFabricatorAdaptorTest {
    @isTest
    private static void toSObject_expectSpecifiedSObjectType() {
        SObject sObj = new SObjectFabricatorAdaptor().build(Account.class).toSObject();
        System.assert(sObj instanceof Account);

        SObject sObj1 = new SObjectFabricatorAdaptor().build('Account').toSObject();
        System.assert(sObj1 instanceof Account);

        Account acct = new Account(Name='test');
        SObject sObj2 = new SObjectFabricatorAdaptor().build(acct).toSObject();
        System.assert(sObj2 instanceof Account);
    }
    
    @isTest
    private static void set_whenField_expectFieldAddedToNodes() {
        SObjectFabricatorAdaptor sObjectBuilder = new SObjectFabricatorAdaptor().build(Account.class);
        sObjectBuilder.set(Account.Id, 'Id-1');
        sfab_FabricatedSObject fabricatedSObject = sObjectBuilder.getFabricatedRecord();
        System.assertEquals(1, fabricatedSObject.getNumberOfNodes());
        System.assertEquals( 'Id-1', fabricatedSObject.getFieldValue( 'Id' ) );
    }

    @isTest
    private static void set_whenStringField_expectFieldAddedToNodes() {
        SObjectFabricatorAdaptor sObjectBuilder = new SObjectFabricatorAdaptor().build(Account.class);
        sObjectBuilder.set('Id', 'Id-1');
        sfab_FabricatedSObject fabricatedSObject = sObjectBuilder.getFabricatedRecord();
        System.assertEquals(1, fabricatedSObject.getNumberOfNodes());
        System.assertEquals( 'Id-1', fabricatedSObject.getFieldValue( 'Id' ) );
    }

    @isTest
    private static void set_whenMapSobjectField_expectFieldsAddedToNodes() {
        SObjectFabricatorAdaptor sObjectBuilder = new SObjectFabricatorAdaptor().build(Account.class);
        Map<Schema.SObjectField, Object> fields = new Map<SObjectField, Object> {
            Account.Id => 'Id-1',
            Account.Name => 'Foo'
        };
        sObjectBuilder.set(fields);
        sfab_FabricatedSObject fabricatedSObject = sObjectBuilder.getFabricatedRecord();
        System.assertEquals( fields.size(), fabricatedSObject.getNumberOfNodes());

        System.assertEquals( 'Id-1', fabricatedSObject.getFieldValue( 'Id' ) );
        System.assertEquals( 'Foo', fabricatedSObject.getFieldValue( 'Name' ) );
    }

    @isTest
    private static void set_whenMapStringField_expectFieldsAddedToNodes() {
        SObjectFabricatorAdaptor sObjectBuilder = new SObjectFabricatorAdaptor().build(Account.class);
        Map<String, Object> fields = new Map<String, Object> {
            'Id' => 'Id-1',
            'Name' => 'Foo'
        };
        sObjectBuilder.set(fields);
        sfab_FabricatedSObject fabricatedSObject = sObjectBuilder.getFabricatedRecord();
        System.assertEquals( fields.size(), fabricatedSObject.getNumberOfNodes());

        System.assertEquals( 'Id-1', fabricatedSObject.getFieldValue( 'Id' ) );
        System.assertEquals( 'Foo', fabricatedSObject.getFieldValue( 'Name' ) );
    }

    @isTest
    private static void set_whenStringFieldForParentWhenParentIsSObject_expectParentAddedToNodes() {
        SObjectFabricatorAdaptor sObjectBuilder = new SObjectFabricatorAdaptor().build(Contact.class);
        Account acct = new Account(Name='test');
        sObjectBuilder.setParent('Account',acct);
        sfab_FabricatedSObject fabricatedSObject = sObjectBuilder.getFabricatedRecord();
        

        sfab_FabricatedSObject fabricatedAccount = fabricatedSObject.getParent( 'Account' );
        System.assertNotEquals(null, fabricatedAccount);
        System.assertEquals( 'test', fabricatedAccount.getFieldValue( 'Name' ) );

    }

    @isTest
    private static void set_whenStringFieldForParentWhenParentIsBuilder_expectParentAddedToNodes() {
        SObjectFabricatorAdaptor contactBuilder = new SObjectFabricatorAdaptor().build(Contact.class);
        SObjectFabricatorAdaptor accountBuilder = new SObjectFabricatorAdaptor().build(Account.class);
        accountBuilder.set('Name','test');
        contactBuilder.setParent('Account',accountBuilder);
        sfab_FabricatedSObject fabricatedSObject = contactBuilder.getFabricatedRecord();
        

        sfab_FabricatedSObject fabricatedAccount = fabricatedSObject.getParent( 'Account' );
        System.assertNotEquals(null, fabricatedAccount);
        System.assertEquals( 'test', fabricatedAccount.getFieldValue( 'Name' ) );

    }

    @isTest
    private static void set_whenChildrenIsListOfSObjects_expectChildSet() {
        SObjectFabricatorAdaptor accountBuilder = new SObjectFabricatorAdaptor().build(Account.class);
        accountBuilder.set('Name','test');
        accountBuilder.setChildren('Contacts',new List<Contact>{
                                                        new Contact(LastName='test1'),
                                                        new Contact(LastName='test2') } );

        sfab_FabricatedSObject fabricatedSObject = accountBuilder.getFabricatedRecord();   
        system.debug(fabricatedSObject);     
        system.debug(fabricatedSObject.toSObject()); 
        system.debug(fabricatedSObject.toSObject().getSObjects('Contacts'));                  
        System.assertEquals( 2, fabricatedSObject.getNumberOfChildren('Contacts') );
    }

    @isTest
    private static void set_whenChildrenIsListOfBuilders_expectChildSet() {
        SObjectFabricatorAdaptor accountBuilder = new SObjectFabricatorAdaptor().build(Account.class);
        accountBuilder.setChildren('Contacts',new List<SObjectFabricatorAdaptor>{
                                                        new SObjectFabricatorAdaptor().build(Contact.class).set('LastName','test1'),
                                                        new SObjectFabricatorAdaptor().build(Contact.class).set('LastName','test2') } );

        sfab_FabricatedSObject fabricatedSObject = accountBuilder.getFabricatedRecord(); 
        system.debug(fabricatedSObject);     
        system.debug(fabricatedSObject.toSObject());                 
        System.assertEquals( 2, fabricatedSObject.getNumberOfChildren('Contacts') );
    }


    @isTest
    private static void add_whenChildrenIsSObject_expectChildSet() {
        SObjectFabricatorAdaptor accountBuilder = new SObjectFabricatorAdaptor().build(Account.class);
        accountBuilder.set('Name','test');
        accountBuilder.addChild('Contacts',new Contact(LastName='test1'));

        sfab_FabricatedSObject fabricatedSObject = accountBuilder.getFabricatedRecord();   
                
        System.assertEquals( 1, fabricatedSObject.getNumberOfChildren('Contacts') );
    }

    @isTest
    private static void add_whenChildrenIsListOfSObjects_expectChildSet() {
        SObjectFabricatorAdaptor accountBuilder = new SObjectFabricatorAdaptor().build(Account.class);
        accountBuilder.addChildren('Contacts',new List<Contact>{new Contact(LastName='test1')} );

        sfab_FabricatedSObject fabricatedSObject = accountBuilder.getFabricatedRecord(); 
                 
        System.assertEquals( 1, fabricatedSObject.getNumberOfChildren('Contacts') );
    }

    @isTest
    private static void add_whenChildIsBuilder_expectChildSet() {
        SObjectFabricatorAdaptor accountBuilder = new SObjectFabricatorAdaptor().build(Account.class);
        accountBuilder.set('Name','test');
        accountBuilder.addChild('Contacts',new SObjectFabricatorAdaptor().build(Contact.class).set('LastName','test1'));

        sfab_FabricatedSObject fabricatedSObject = accountBuilder.getFabricatedRecord();   
                
        System.assertEquals( 1, fabricatedSObject.getNumberOfChildren('Contacts') );
    }

    @isTest
    private static void add_whenChildrenIsListOfBuilders_expectChildSet() {
        SObjectFabricatorAdaptor accountBuilder = new SObjectFabricatorAdaptor().build(Account.class);
        accountBuilder.addChildren('Contacts',new List<SObjectFabricatorAdaptor>{
                                            new SObjectFabricatorAdaptor().build(Contact.class).set('LastName','test1'),
                                            new SObjectFabricatorAdaptor().build(Contact.class).set('LastName','test2') } );
        sfab_FabricatedSObject fabricatedSObject = accountBuilder.getFabricatedRecord(); 
                 
        System.assertEquals( 2, fabricatedSObject.getNumberOfChildren('Contacts') );
    }
}
