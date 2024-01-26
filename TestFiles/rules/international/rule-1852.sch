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
      <title>Rule 1852</title>      
      <doc:description>If initialSterilisationPriorToUseCode and/or manufacturerSpecifiedAcceptableResterilisationCode is used then initialSterilisationPriorToUseCode and/or manufacturerSpecifiedAcceptableResterilisationCode SHALL NOT equal "NOT_STERILISED".</doc:description>       
      <doc:attribute1>nitialSterilisationPriorToUseCode,manufacturerSpecifiedAcceptableResterilisationCode</doc:attribute1> 
      
      <rule context="tradeItem">     
          <assert test="if ((exists(tradeItemInformation/extension/*:medicalDeviceTradeItemModule/medicalDeviceInformation/tradeItemSterilityInformation/initialSterilisationPriorToUseCode))
                        or (exists(tradeItemInformation/extension/*:medicalDeviceTradeItemModule/medicalDeviceInformation/tradeItemSterilityInformation/manufacturerSpecifiedAcceptableResterilisationCode)))
     		            then (every $node in (tradeItemInformation/extension/*:medicalDeviceTradeItemModule/medicalDeviceInformation/tradeItemSterilityInformation/initialSterilisationPriorToUseCode , 
     		                                 tradeItemInformation/extension/*:medicalDeviceTradeItemModule/medicalDeviceInformation/tradeItemSterilityInformation/manufacturerSpecifiedAcceptableResterilisationCode)
         				satisfies  ($node != 'NOT_STERILISED'))                           
           							        							
				          				 else true()">			
                        		 
				          		 				<initialSterilisationPriorToUseCode><xsl:value-of select="tradeItemInformation/extension/*:medicalDeviceTradeItemModule/medicalDeviceInformation/tradeItemSterilityInformation/initialSterilisationPriorToUseCode"/></initialSterilisationPriorToUseCode>
				          		 				<manufacturerSpecifiedAcceptableResterilisationCode><xsl:value-of select="tradeItemInformation/extension/*:medicalDeviceTradeItemModule/medicalDeviceInformation/tradeItemSterilityInformation/manufacturerSpecifiedAcceptableResterilisationCode"/></manufacturerSpecifiedAcceptableResterilisationCode>
							      		 		<errorMessage>For initialSterilisationPriorToUseCode (#initialSterilisationPriorToUseCode#) and/or manufacturerSpecifiedAcceptableResterilisationCode (#manufacturerSpecifiedAcceptableResterilisationCode#) shall not equal NOT_STERILISED and is invalidly used.</errorMessage>
							                
								                <location>
														<!-- Fichier SDBH -->
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
