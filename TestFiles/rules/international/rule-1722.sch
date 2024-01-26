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
      <title>Rule 1722</title>
      <doc:description>If additionalTradeItemClassificationSystemCode equals '85' then additionalTradeItemClassificationCodeValue SHALL equal (‘EU_CLASS_I’, ‘EU_CLASS_IIA’, ‘EU_CLASS_IIB’, ‘EU_CLASS_III’, ‘IVDD_ANNEX_II_LIST_A’, ‘IVDD_ANNEX_II_LIST_B’, ‘IVDD_DEVICES_SELF_TESTING’, ‘IVDD_GENERAL’, or 'AIMDD')</doc:description>
      <doc:avenant>Modif. 3.1.21 Changed structured rule and error message.</doc:avenant>      
      <doc:attribute1>additionalTradeItemClassificationSystemCode</doc:attribute1>
      <doc:attribute2>additionalTradeItemClassificationCodeValue</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if( (exists (gdsnTradeItemClassification/additionalTradeItemClassification/additionalTradeItemClassificationSystemCode)
        					and (gdsnTradeItemClassification/additionalTradeItemClassification/additionalTradeItemClassificationSystemCode = '85'))) 
        					then (every $node in (gdsnTradeItemClassification/additionalTradeItemClassification/additionalTradeItemClassificationValue/additionalTradeItemClassificationCodeValue) 
        					satisfies ($node = ('EU_CLASS_I', 'EU_CLASS_IIA', 'EU_CLASS_IIB', 'EU_CLASS_III', 'IVDD_ANNEX_II_LIST_A', 'IVDD_ANNEX_II_LIST_B', 'IVDD_DEVICES_SELF_TESTING', 'IVDD_GENERAL' ,  'AIMDD')  )  )           												
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>additionalTradeItemClassificationCodeValue is incorrect. For additionalTradeItemClassificationSystemCode '85' shall be one of these values (‘EU_CLASS_I’, ‘EU_CLASS_IIA’, ‘EU_CLASS_IIB’, ‘EU_CLASS_III’, ‘IVDD_ANNEX_II_LIST_A’, ‘IVDD_ANNEX_II_LIST_B’, ‘IVDD_DEVICES_SELF_TESTING’, ‘IVDD_GENERAL’, 'AIMDD').
	                                            </errorMessage>
							                
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
														<gtin><xsl:value-of select="gtin"/></gtin>
														<glnProvider><xsl:value-of select="informationProviderOfTradeItem/gln"/></glnProvider>
														<targetMarket><xsl:value-of select="targetMarket/targetMarketCountryCode"/></targetMarket>	
														
												</location>
						          		 		
          		 		
 		  </assert>
      </rule>
   </pattern>
</schema>
