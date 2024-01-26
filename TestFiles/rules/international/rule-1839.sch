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
      <title>Rule 1839</title>      
      <doc:description>If compulsoryAdditionalLabelInformationTypeCode is used, then compulsoryAdditionalLabelInformation SHALL be used.</doc:description>       
      <doc:attribute1>compulsoryAdditionalLabelInformationTypeCode</doc:attribute1> 
      <doc:attribute2>compulsoryAdditionalLabelInformation</doc:attribute2>      
      <rule context="compulsoryAdditionalInformation">
		 <assert test="if(exists(compulsoryAdditionalLabelInformationTypeCode))         			              			
            			  then (exists(compulsoryAdditionalLabelInformation)
            			  and (every $node in (compulsoryAdditionalLabelInformation)
            			  satisfies ($node != '')))            			 
            
		            			  else true()">   	 
				          		 		
							      		 		<errorMessage>If Additional Legal Product Information Type Code (compulsoryAdditionalLabelInformationTypeCode) is used, then you SHALL use Additional Legal Product Information (compulsoryAdditionalLabelInformation).</errorMessage>
							                
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
