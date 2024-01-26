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
    <let name="gpc" value="doc('../data/data.xml')//data:gpc"/>   
   <pattern>
      <title>Rule 1742</title>      
      <doc:description>If targetMarketCountryCode equals (528 (Netherlands), 246 (Finland), 208 (Denmark), or 250 (France)) and Packaging class or sub-classes are not empty then packagingTypeCode SHALL be used in each iteration of the class Packaging</doc:description>    
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,packaging</doc:attribute1>   
      <doc:attribute2>packagingTypeCode</doc:attribute2>     
      <rule context="packaging">
     		  <assert test="if ((ancestor::tradeItem/targetMarket/targetMarketCountryCode =  ('250', '528', '246', '208'))	
     		            and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code))) 	    		                               
		                then  exists(packagingTypeCode) 
         			    and (every $node in (packagingTypeCode) 
         			    satisfies  ( $node   != '') )                
           							        							
				          				 else true()">			          		 
				          		 		
							      		 		<errorMessage>If any of the attributes from class Packaging is provided, than attribute packagingTypeCode must be provided (in each iteration of the class).</errorMessage>
							                
								                <location>
													<!-- Fichier SDBH -->
													<messageId><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"/></messageId>
													<messageOwner><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/></messageOwner>
																		
													<transactionId><xsl:value-of select="ancestor::transaction/transactionIdentification/entityIdentification"/></transactionId>
													<transactionOwner><xsl:value-of select="ancestor::transaction/transactionIdentification/contentOwner/gln"/></transactionOwner>
													<commandId><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/entityIdentification"/></commandId>
													<commandOwner><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/contentOwner/gln"/></commandOwner>
													<!-- Fichier CIN -->
													<documentId><xsl:value-of select="ancestor::*:catalogueItemNotification/catalogueItemNotificationIdentification/entityIdentification"/></documentId>
													<documentOwner><xsl:value-of select="ancestor::*:catalogueItemNotification/catalogueItemNotificationIdentification/contentOwner/gln"/></documentOwner>
													<!--  Le 1er tradeItem . 1 seul car les autres sont imbriqués -->
													<gtinHigh><xsl:value-of select="ancestor::*:catalogueItemNotification/catalogueItem/tradeItem/gtin"/></gtinHigh>
													<!-- Context = TradeItem -->
													<gtin><xsl:value-of select="ancestor::tradeItem/gtin"/></gtin>
													<glnProvider><xsl:value-of select="ancestor::tradeItem/informationProviderOfTradeItem/gln"/></glnProvider>
													<targetMarket><xsl:value-of select="ancestor::tradeItem/targetMarket/targetMarketCountryCode"/></targetMarket>	
												</location>
						          		 		
          		 		
 		  </assert>
      </rule>
   </pattern>
</schema>
