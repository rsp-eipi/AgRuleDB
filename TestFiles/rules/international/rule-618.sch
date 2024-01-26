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
      <title>Rule 618</title>
       <doc:description>If target Market equals ('249' (France) or '250' (France)), consumer units for alcoholic beverages (Cls '50202200' , except Brick '10000142') shall have a dutyFeeTaxTypeCode equal to '3001000002541' (Rights on pre-mixes), '3001000002244' (Tax on cider), '3001000002312' (Rights of alcohol) or '3001000002329' (Rights of alcohol).</doc:description>
      <doc:attribute1>DutyFeeTaxInformation/dutyFeeTaxTypeCode</doc:attribute1>
      <doc:attribute2>TradeItem/isTradeItemAConsumerUnit</doc:attribute2>
      <doc:attribute3>GDSNTradeItemClassification/gpcCategoryCode</doc:attribute3>
      <rule context="tradeItem">
          <assert test="if ( (targetMarket/targetMarketCountryCode =  ('250'(: France :) , '249'(: France :) ) ) 
                        and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') 
                        and  (isTradeItemABaseUnit = 'true')  
                        and  (gdsnTradeItemClassification/gpcCategoryCode =  $gpc//*[@code = ('50202200')]/*/@code[not(. = ( ('10000142', '10000143') ))] ) ) 
                        then  exists(tradeItemInformation/extension/*:dutyFeeTaxInformationModule/dutyFeeTaxInformation/dutyFeeTaxTypeCode)
                        and (some $node in (tradeItemInformation/extension/*:dutyFeeTaxInformationModule/dutyFeeTaxInformation/dutyFeeTaxTypeCode)
                        satisfies  $node =  ('3001000002541', '3001000002244', '3001000002312', '3001000002329') )
          
          				else true()">
          				
          						
          								   <errorMessage>If target Market equals '250' (France), consumer units for alcoholic beverages (Cls '50202200' , except Brick '10000142') must have a dutyFeeTaxTypeCode equal to '3001000002541' (Rights on pre-mixes), '3001000002244' (Tax on cider), '3001000002312' (Rights of alcohol) or '3001000002329'.</errorMessage>
				           
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
