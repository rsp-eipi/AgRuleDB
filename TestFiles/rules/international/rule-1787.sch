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
      <title>Rule 1787</title>      
      <doc:description>If NutrientDetail class is used, then all combinations of nutrientTypeCode and measurementPrecisionCode values SHALL be unique within the same NutrientHeader class.</doc:description>    
      <doc:attribute1>gpcCategoryCode</doc:attribute1> 
      <doc:attribute2>nutrientTypeCode</doc:attribute2>       
   	  <rule context="nutrientHeader">
		    <assert test="if((not (ancestor::tradeItem/gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				    and (not (ancestor::tradeItem/gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code))         				    
        				    and exists(nutrientDetail))	        				          					    					
        					then ((count(nutrientDetail/nutrientTypeCode[.='ENER-']) &lt;= 2 )
            		        and (count(distinct-values(nutrientDetail/nutrientTypeCode[.!='ENER-'])) = 
            		        count(nutrientDetail/nutrientTypeCode[.!='ENER-'])))             												
        							
				          				 else true()">
				          				 
				          				 		<nutrientTypeCode><xsl:value-of select="nutrientDetail/nutrientTypeCode"/></nutrientTypeCode>
				          				 		<measurementPrecisionCode><xsl:value-of select="nutrientDetail/measurementPrecisionCode"/></measurementPrecisionCode>					          		 
				          		 		
							      		 		<errorMessage>For a Nutrient Header class, the Nutrient and Measurement Precision Code must be unique.</errorMessage>
							                
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
