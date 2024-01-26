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
      <title>Rule 1696</title>
      <doc:description>If targetMarket/countryCode in ('276' Germany or '040' Austria) and catchAreaCode is used then catchAreaCode SHALL NOT be in ('27', '37').</doc:description>
      <doc:avenant>Modif. 3.1.25 La règle ne s'applique plus sur le marché cible Suisse</doc:avenant>
      <doc:attribute1>targetMarketCountryCode,catchAreaCode</doc:attribute1>
      <doc:attribute2>catchAreaCode</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if (targetMarket/targetMarketCountryCode =  ('276', '040')
		  				and ( exists(tradeItemInformation/extension/*:dairyFishMeatPoultryItemModule/dairyFishMeatPoultryInformation/fishReportingInformation/fishCatchInformation/catchAreaCode)))		  				              	               	               
		                then (exists(tradeItemInformation/extension/*:dairyFishMeatPoultryItemModule/dairyFishMeatPoultryInformation/fishReportingInformation/fishCatchInformation/catchAreaCode) 
    					and (every $node in (tradeItemInformation/extension/*:dairyFishMeatPoultryItemModule/dairyFishMeatPoultryInformation/fishReportingInformation/fishCatchInformation/catchAreaCode)
		                satisfies ($node != '27' and $node != '37' ) ) )           							
        												
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>For DE, AT the FAO catch zones of 27, 37 are not valid, please use the sub areas or divisions for these zones.</errorMessage>
							                
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
