<?xml version='1.0' encoding='utf-8' ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	
	<xsl:key name="bars" match="/GPIF/Bars/Bar" use="@id"/>
	<xsl:key name="voices" match="/GPIF/Voices/Voice" use="@id"/>
	<xsl:key name="beats" match="/GPIF/Beats/Beat" use="@id"/>
	<xsl:key name="notes" match="/GPIF/Notes/Note" use="@id"/>
	<xsl:key name="rhythms" match="/GPIF/Rhythms/Rhythm" use="@id"/>
	
	<!-- retourne le nombre d'element d'une liste d'entiers -->
	<xsl:template name="CountIndexes">
		<xsl:param name="indexes" select="'0'"/>
		<xsl:param name="counter" select="1"/>
		<xsl:choose>
			<xsl:when test="contains($indexes, ' ')">
				<xsl:call-template name="CountIndexes">
					<xsl:with-param name="counter" select="$counter + 1"/>
					<xsl:with-param name="indexes" select="substring-after($indexes, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$counter"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- retourne l'index d'un entier contenue dans indexes -->
	<xsl:template name="IndexOfValue">
		<xsl:param name="indexes" select="'0'"/>
		<!-- liste d'entier -->
		<xsl:param name="value" select="0"/>
		<!-- valeur recherchée -->
		<xsl:param name="counter" select="0"/>
		<!-- compteur -->
	
		
	<!-- debug
	value = <xsl:copy-of select="$value"/>, 
	indexes = <xsl:copy-of select="$indexes"/>
	-->
		<xsl:choose>
			<xsl:when test="contains($indexes, ' ')">
				<!-- il reste des elements -->
				<!-- on recupere le premier la valeur courante-->
				<xsl:variable name="current_value" select="substring-before($indexes, ' ')"/>
				<xsl:choose>
					<xsl:when test="$value = $current_value">
						<!-- on a trouvé la valeur recherchée-->
						<xsl:value-of select="$counter"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- on va rechercher dans le reste de la liste-->
						<xsl:call-template name="IndexOfValue">
							<xsl:with-param name="counter" select="$counter + 1"/>
							<xsl:with-param name="value" select="$value"/>
							<xsl:with-param name="indexes" select="substring-after($indexes, ' ')"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!-- la liste est vide ou à 1 seul element-->
				<xsl:choose>
					<xsl:when test="$value = $indexes">
						<!-- on a trouvé la valeur recherchée-->
						<xsl:value-of select="$counter"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="-1"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- retourne -1 si la bar n'est pas dans la masterBar sinon retourne l'index dans track-->
	<xsl:template name="IsBarIndexInsideMasterBar">
		<xsl:param name="barId" select="0"/>
		<xsl:param name="masterBar" select="0"/>
		<xsl:variable name="index_in_mbar">
			<xsl:call-template name="IndexOfValue">
				<xsl:with-param name="value" select="$barId"/>
				<xsl:with-param name="indexes" select="$masterBar"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$index_in_mbar"/>
	</xsl:template>
	
	<!-- prend l'index d'une Bar et retourne l'index de la track -->
	<xsl:template name="BarTrackIndex">
		<xsl:param name="barId" select="0"/>
		<xsl:variable name="index">
			<xsl:for-each select="/GPIF/MasterBars/MasterBar/Bars">
				<xsl:variable name="id">
					<xsl:call-template name="IsBarIndexInsideMasterBar">
						<xsl:with-param name="barId" select="$barId"/>
						<xsl:with-param name="masterBar" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="not($id = -1)">
					<xsl:value-of select="$id"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="$index"/>
	</xsl:template>
	
	<!-- règle par defaut pour tout recopier-->
	<xsl:template match="/ | @* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- on specifie un autre xsd pour la validation -->
	<xsl:template match="/GPIF">
		<GPIF xsi:noNamespaceSchemaLocation="gpif2.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:apply-templates select="node()"/>
		</GPIF>
	</xsl:template>
	
	<!-- gestion des proprietes des notes -->
	<xsl:template match="Property">
		<xsl:choose>
			<!-- Les dead notes sont devenues Muted -->
			<xsl:when test="@name='Dead'">
				<xsl:element name="Property">
					<xsl:attribute name="name">
						<xsl:value-of select="'Muted'"/>
                    </xsl:attribute>
					<xsl:copy-of select="node()"/>
				</xsl:element>
            </xsl:when>
			<!-- gestion des bends via middleValue & destinationValue -->
			<xsl:when test="@name='Bend'">
				<xsl:element name="Property">
					<xsl:attribute name="name">
						<xsl:value-of select="'Bended'"/>
                    </xsl:attribute>
					<xsl:element name="Enable"/>
                </xsl:element>
				<xsl:choose>
					<xsl:when test="BendDescription/Type = 'BendRelease'">
						<xsl:element name="Property">
							<xsl:attribute name="name">
								<xsl:value-of select="'BendMiddleValue'"/>
							</xsl:attribute>
							<xsl:element name="Float">
								<xsl:value-of select="'100'"/>
							</xsl:element>
                        </xsl:element>
                    </xsl:when>
					<xsl:otherwise>
						<xsl:element name="Property">
							<xsl:attribute name="name">
								<xsl:value-of select="'BendDestinationValue'"/>
							</xsl:attribute>
							<xsl:element name="Float">
								<xsl:value-of select="'100'"/>
							</xsl:element>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
			<!-- recopie des autres proprietes -->
			<xsl:otherwise>
				<xsl:element name="Property">
					<xsl:attribute name="name">
						<xsl:value-of select="@name"/>
					</xsl:attribute>
					<xsl:copy-of select="node()"/>
				</xsl:element>
        	</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- plus geres de la meme facon-->
	<xsl:template match="Legato">
		<xsl:element name="Properties">
			<xsl:element name="Property">
				<xsl:attribute name="name">
					<xsl:value-of select="'HopoOrigin'"/>
            	</xsl:attribute>
				<xsl:element name="Enable"/>
        	</xsl:element>
		</xsl:element>
    </xsl:template>
	
	<!-- Le noeud clef doit etre ignoré car deplacé dans l'element Bar-->
	<xsl:template match="Clef"/>
	<xsl:template match="Bar">
		<!-- ici on doit ajouter la clef en allant la chercher dans la track contenant la mesure -->
		<!-- recuperation de l'index de la track qui contiend la mesure -->
		<xsl:variable name="trackIndex">
			<xsl:call-template name="BarTrackIndex">
				<xsl:with-param name="barId" select="1"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- debug 
		TrackIndex = <xsl:value-of select="$trackIndex"/>
		-->
		<xsl:variable name="id" select="@id"/>
		<!-- on crée le noeud Bar -->
		<xsl:element name="Bar">
			<!-- on conserve l'attribut id-->
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<!-- ajout de la clef en gérant la transformation F->F4, G -> G2 -->
			<xsl:choose>
				<xsl:when test="/GPIF/Tracks/Track[@id=$trackIndex]/Clef = 'F'">
					<Clef>F4</Clef>
				</xsl:when>
				<xsl:when test="/GPIF/Tracks/Track[@id=$trackIndex]/Clef = 'G'">
					<Clef>G2</Clef>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="/GPIF/Tracks/Track[@id=$trackIndex]/Clef"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- on conserve le reste de la hierarchie-->
			<xsl:copy-of select="node()"/>
		</xsl:element>
	</xsl:template>
	
	<!-- transformation de accentuationType en antiAccentType -->
	<xsl:template match="accentuationType">
		<antiAccentType>
			<xsl:choose>
				<xsl:when test="accentuationType = Ghost">
					Soft
                </xsl:when>
				<xsl:when test="accentuationType = Normal">
					Normal
                </xsl:when>
				<xsl:when test="accentuationType = Heavy">
					Strong
                </xsl:when>
			</xsl:choose>
		</antiAccentType>
	</xsl:template>

	<!-- RidePartType devient RideElement -->
	<xsl:template match="RidePartType">
		<RideElement>
			<xsl:copy-of select="."/>
		</RideElement>
	</xsl:template>
	
	<!-- Attributes devient XProperties-->
	<xsl:template match="Attributes">
		<XProperties>
			<xsl:copy-of select="."/>
		</XProperties>
	</xsl:template>
	
	<!-- arpeggio sans speed -->
	<xsl:template match="Arpeggio">
		<Arpeggio>
			<xsl:value-of select="Direction"/>
		</Arpeggio>
	</xsl:template>
	
	<!-- suppression des alternateEndings qui ne marchent pas (pblm au parse) -->
	<xsl:template match="AlternateEndings"/>
	<!-- supprime les BrushDescription qui n'existent plus-->
	<xsl:template match="BrushDescription"/>
	<!-- supprime les WhaType qui n'existent plus-->
	<xsl:template match="WahType"/>
	<!-- fadeIn (fadding) ignore -->
	<xsl:template match="FadeIn"/>
	<xsl:template match="Staccato"/>
	<xsl:template match="Accentuation"/>
	<xsl:template match="Ornament"/>
	<xsl:template match="DummyNote"/>
	<xsl:template match="Trill"/>
	<xsl:template match="TempoLabel"/>
</xsl:stylesheet>