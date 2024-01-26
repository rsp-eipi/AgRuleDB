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
      <title>Rule 1804</title>
       <doc:description>If targetMarketCountryCode equals '752' (Sweden) and isTradeItemAConsumerUnit equals 'true' and gpcCategoryCode is in: family '50210000' (Tobacco/Cannabis/Smoking Accessories) and gpcCategoryCode is not in: (brick '10000303' (Smoking Accessories) or brick '10006730' (Electronic Cigarette Accessories)) then consumerSalesConditionTypeCode SHALL be used.</doc:description>
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,isTradeItemAConsumerUnit</doc:attribute1>
      <doc:attribute2>consumerSalesConditionTypeCode</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if ( (targetMarket/targetMarketCountryCode =  ('752'(: Sweden :) ) ) 
                        and  (isTradeItemABaseUnit = 'true')  
                        and  (gdsnTradeItemClassification/gpcCategoryCode = ('10000134' , '10000185' , '10000186' , '10000267' , '10000268' , '10000584' , '10000620' , '10006313' ,
                                                                             '10006729' , '10006992' , '10006993' , '10006994' , '10008070' , '10008071' , '10008072' , '10008073' ,
                                                                             '10008074' , '10008075' , '10008076' , '10008077' , '10008078' , '10008079' , '10008080' , '10008081' ,
                                                                             '10008082' , '10008083' , '10008084' , '10008085' , '10008086' , '10008087' , '10008088' , '10008089' ,
                                                                             '10008090' , '10008091' , '10008092' , '10008093' , '10008094' , '10008095' , '10008096' , '10008097' ,
                                                                             '10008098' , '10008099' , '10008100' , '10008101' , '10008102') ) ) 
                        then  exists(tradeItemInformation/extension/*:salesInformationModule/salesInformation/consumerSalesConditionCode)
                        and (every $node in (tradeItemInformation/extension/*:salesInformationModule/salesInformation/consumerSalesConditionCode)
                        satisfies  $node !=  '' )
          
          				else true()">
          				
          						
          								   <errorMessage>Missing consumerSalesConditionTypeCode. For Country of Sale Code (Sweden), the attribute is required for tobacco products.</errorMessage>
				           
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
