<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:doc="http://doc" queryBinding="xslt2">
    <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3" prefix="catalogue_item_confirmation"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" prefix="sh"/>
    <ns uri="http://data" prefix="data"/>
    <pattern>
        <title>Rule FR_099</title>
        <doc:description>If one iteration of targetMarketCountryCode equals '250' (France), gpcCategoryCode equals ['50000000' or '10000000'], and organicTradeItemCode equals '2' 
                         then at least one instance of certificationAgency SHALL be equal to 'ORGANIC_AGENCY'
                         and its [certificationEffectiveStartDate, certificationEffectiveEndDate and certificationValue] SHALL be used].
        </doc:description>
        <doc:avenant>Modification 3.1.19 Le 26/07/2022</doc:avenant>
        <doc:attribute1>targetMarket[1]/targetMarketCountryCode</doc:attribute1>
        <doc:attribute2>organicTradeItemCode, certificationAgency, certificationStandard,
            certificationEffectiveStartDate, certificationEffectiveEndDate et
            certificationValue</doc:attribute2>            
        <rule context="tradeItem">
            <assert
                test="
                if ((targetMarket/targetMarketCountryCode = '250')
                    and ((gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP006/gpcDP006Code)
                    or  (gdsnTradeItemClassification/gpcCategoryCode = ('10006843' , '10007768' , '10008290' , '10000640' , '10000662')))
                    and (isTradeItemAConsumerUnit = 'true')
                    and (tradeItemInformation/extension/*:farmingAndProcessingInformationModule/tradeItemOrganicInformation/organicClaim/organicTradeItemCode = '2'))
                    then
                    (some $node in (tradeItemInformation/extension/*:certificationInformationModule/certificationInformation[certificationAgency = 'ORGANIC_AGENCY' or certificationAgency = 'ECOLOGIC_AGENCY'])
                    satisfies(exists($node/certificationStandard) and exists($node/certification/certificationValue) and exists($node/certification/certificationEffectiveStartDateTime) and exists($node/certification/certificationEffectiveEndDateTime)))
                    
                    else true()">
                    
                    
                			
        		       <errorMessage>Pour le marché cible France, si un produit est biologique (organicTradeItemCode = 2), le numéro du certificat BIO et les dates de validité de ce certificat doivent être renseignées.</errorMessage>
		           
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
