<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
   <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3"
       prefix="catalogue_item_confirmation"/>
   <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
       prefix="sh"/>
   <ns uri="http://data" prefix="data"/>
    
   <pattern>
      <title>Rule 1458</title>
      <doc:description>Catalogue Item Notification message shall not be sent using
                       transaction/documentCommand/documentCommandHeader/@type equal to 'DELETE'.
       </doc:description>
       <doc:attribute1>documentCommandHeader/@type</doc:attribute1>
      
       <rule context="*:catalogueItemNotificationMessage">
          <assert test="exists(transaction/documentCommand/documentCommandHeader/@type)
                          and (every $node in (transaction/documentCommand/documentCommandHeader/@type) 
                          satisfies ($node != 'DELETE'))">          		    
            
            			 
				            	   <errorMessage>Invalid command. You shall not send a CIN with 'DELETE' to withdraw an item.
				            	                 You shall use the CatalogueItemHierarchicalWithdrawal message.
            	                   </errorMessage>
								                
				                   <location>
										<messageId><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"/></messageId>
										<messageOwner><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/></messageOwner>
										
								   </location>
						          		 		
          		 		
 		  </assert>
      </rule>
   </pattern>
</schema>
