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
      <title>Rule FR_198</title>
       <doc:description>If one iteration of targetMarketCountryCode equals '250' (France) and for the same instance of the XML class regulatoryInformation, if regulatoryAct equals 'SANITARY_AGREEMENT_NUMBER' then regulatoryAgency shall be used with the value 'SANITARY_AGREEMENT_NUMBER_AGENCY'.</doc:description>
       <doc:attribute1>targetMarketCountryCode,regulatoryAct</doc:attribute1>
       <doc:attribute2>regulatoryAgency</doc:attribute2>
       <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode = '250')
        					and (exists(tradeItemInformation/extension/*:regulatedTradeItemModule/regulatoryInformation/regulatoryAct))
        					and (tradeItemInformation/extension/*:regulatedTradeItemModule/regulatoryInformation/regulatoryAct = 'SANITARY_AGREEMENT_NUMBER'))        				  				
          					then (exists(tradeItemInformation/extension/*:regulatedTradeItemModule/regulatoryInformation/regulatoryAgency)              			      			 
            			    and (some $node in (tradeItemInformation/extension/*:regulatedTradeItemModule/regulatoryInformation/regulatoryAgency)
            			    satisfies ($node = 'SANITARY_AGREEMENT_NUMBER_AGENCY')))           				    					 
          				  
          					else true()">
          	 
          	 	
		          	 	       <errorMessage>Pour le marché cible France et pour chaque instance de la classe XML relative aux informations réglementaires, si la décision réglementaire vaut 'SANITARY_AGREEMENT_NUMBER', alors l'agence de régulation doit être renseigné avec la valeur 'SANITARY_AGREEMENT_NUMBER_AGENCY'.</errorMessage>
				           
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
