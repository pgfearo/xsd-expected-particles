<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                exclude-result-prefixes="#all" 
                version="3.0" expand-text="yes">
    
    <xsl:output indent="yes"/>
    
    <xsl:mode on-no-match="deep-skip"/>
    <xsl:mode name="lookup" on-no-match="deep-skip"/>
    
    <xsl:template match="/">
        <xsl:variable name="elementsWithSGs" as="element()*" select="/xs:schema/xs:element[@substitutionGroup]"/>
        <result>
            <xsl:for-each-group select="$elementsWithSGs" group-by="tokenize(@substitutionGroup)">
                <sub-group>
                    <key>
                        <xsl:sequence select="current-grouping-key()"/>
                    </key>
                    <xsl:for-each select="current-group()">
                        name: {@name} ref: {@ref}</xsl:for-each>
                </sub-group>
            </xsl:for-each-group>
            <xs-groups>
                <key>XS:GROUP</key>
                <xsl:for-each select="/xs:schema/xs:group">
                    name: {@name}</xsl:for-each>
            </xs-groups>
            <alone-group>
                <key>NOGROUP</key>
                <xsl:variable name="alone" select="/xs:schema/xs:element[empty(@substitutionGroup)]"/>
                <xsl:for-each select="$alone">
                    name: {@name}</xsl:for-each>
            </alone-group>
            <complex-type-group>
                <xsl:for-each select="/xs:schema/xs:complexType">
                    name: {@name}</xsl:for-each>
            </complex-type-group>
        </result>
    </xsl:template>
    
    <xsl:template match="xs:element[@substitutionGroup]"> </xsl:template>
    
    <xsl:template match="xs:element[@name][@abstract eq 'true' and empty(@type)]">
        <!-- 1. <xs:element name="stylesheet" substitutionGroup="xsl:transform"/> -->
        <!--   <xs:element name="transform"> -->
        
        <xsl:variable name="sg" as="xs:string" select="@substitutionGroup"/>
        <xsl:apply-templates select="/*/xs:element[@name eq $sg]" mode="lookup"/>
        
    </xsl:template>
    
    <xsl:template match="xs:element[@name][not(@abstract eq 'true')]">
        <!-- 1. <xs:element name="stylesheet" substitutionGroup="xsl:transform"/> -->
        <!--   <xs:element name="transform"> -->
        
        <xsl:variable name="sg" as="xs:string" select="@substitutionGroup"/>
        <xsl:apply-templates select="/*/xs:element[@name eq $sg]" mode="lookup"/>
        
    </xsl:template>
    
    <xsl:template match="xs:element//xs:complexContent">
        <!-- e.g. xs;element[@name eq 'transform']/complexType/complexContent -->
        <xsl:apply-templates select="xs:extension"/>
        
    </xsl:template>
    
    <xsl:template match="xs:extension">
        <!-- e.g. <xs:extension base="xsl:versioned-element-type"> -->
    </xsl:template>
    
    <xsl:template match="xs:element[@ref]">
        <xsl:variable name="local" as="xs:string" select="substring-after(@ref, 'xsl:')"/>
        <xsl:variable name="elementDefinition" as="element()" select="//xs:element[@name eq $local]"/>
        
        
        <xsl:apply-templates select="/*/xs:element[@substitutionGroup eq $local]" mode="lookup"/>
        <xsl:apply-templates select="/*/xs:element[not(@abstract eq 'true')][@name eq $local]" mode="lookup"/>
        
    </xsl:template>
    
    <xsl:template match="xs:element[@group]">
        <xsl:variable name="local" as="xs:string" select="substring-after(@ref, 'xsl:')"/>
        <xsl:variable name="elementDefinition" as="element()" select="//xs:element[@name eq $local]"/>
        
        
        <xsl:apply-templates select="/*/xs:element[@substitutionGroup eq $local]" mode="lookup"/>
        
    </xsl:template>
    
    <xsl:template match="xs:element[@name]"> </xsl:template>
    
    <xsl:template match="xs:complexType[@name]" mode="lookup"> </xsl:template>
    
    <xsl:template match="xs:element[@substitutionGroup]" mode="lookup">
        <!--  2. <xs:element name="template" substitutionGroup="xsl:declaration"> -->
    </xsl:template>
    
    <xsl:template match="xs:element[@type][@abstract eq 'true']" mode="lookup">
        <!--  3. <xs:element name="declaration" type="xsl:generic-element-type" abstract="true"/> -->
    </xsl:template>
    
    <xsl:template match="xs:complexType[@name]">
        <!--  4. <xs:complexType name="generic-element-type" mixed="true"> -->
    </xsl:template>
    
    <xsl:template match="xs:group[@name]" mode="lookup"> </xsl:template>
    
    
    
</xsl:stylesheet>
