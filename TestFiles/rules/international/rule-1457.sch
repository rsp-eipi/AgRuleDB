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
      <title>Rule 1457</title>
      <doc:description>If message type is CatalogueItemHierarchicalWithdrawal
                       then documentCommand/documentCommandHeader/@type shall equal 'DELETE'.
       </doc:description>
       <doc:attribute1>documentCommandHeader/@type</doc:attribute1>
      
       <rule context="*:catalogueItemHierarchicalWithdrawalMessage">
          <assert test="exists(transaction/documentCommand/documentCommandHeader/@type)
                          and (every $node in (transaction/documentCommand/documentCommandHeader/@type) 
                          satisfies ($node = 'DELETE'))">          		    
            
            			 
				            	   <errorMessage>Invalid document command. The CatalogueItemHierarchicalWithdrawal message shall have a document command of ‘DELETE’. 
				            	                 No other document commands are valid for this message
            	                   </errorMessage>
								                
				                   <location>
										<!-- Fichier SDBH -->
										<messageId><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"/></messageId>
										<messageOwner><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/></messageOwner>
															
										<transactionId><xsl:value-of select="ancestor::transaction/transactionIdentification/entityIdentification"/></transactionId>
										<transactionOwner><xsl:value-of select="ancestor::transaction/transactionIdentification/contentOwner/gln"/></transactionOwner>
										<commandId><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/entityIdentification"/></commandId>
										<commandOwner><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/contentOwner/gln"/></commandOwner>
										<!-- Fichier CIHW -->
										<documentId><xsl:value-of select="ancestor::*:catalogueItemHierarchicalWithdrawal/catalogueItemHierarchicalWithdrawalIdentification/entityIdentification"/></documentId>
										<documentOwner><xsl:value-of select="ancestor::*:catalogueItemHierarchicalWithdrawal/catalogueItemHierarchicalWithdrawalIdentification/contentOwner/gln"/></documentOwner>
										
										
								   </location>
						          		 		
          		 		
 		  </assert>
      </rule>
   </pattern>
</schema>
