<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" cdata-section-elements="FreeText Title Artist Instructions Name ShortName"/>

  <xsl:variable name="tracks" select="count(tabledit/tracks/track)"/>
  <xsl:variable name="MAX_VOICES" select="4"/>
  <xsl:variable name="DEFAULT_BAR_LENGTH" select="256"/>

  <xsl:key name="voiceNotes" match="/tabledit/components/note" use="concat(track, '-', measure, '-', voice)"/>
  
  <xsl:template match="tabledit">
    <GPIF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="gpif.xsd">
      <Score>
        <Title><xsl:value-of select="info/title"/></Title>
        <Artist><xsl:value-of select="info/subtitle"/></Artist>
        <Instructions>
          <xsl:value-of select="info/comments"/>
          <xsl:value-of select="info/notes"/>
        </Instructions>
      </Score>
      <MasterTrack>
        <Automations>
          <Automation>
            <Type>Tempo</Type>      
            <Linear>false</Linear>
            <Bar>0</Bar>
            <Position>0</Position>
            <Text></Text>
            <Visible>true</Visible>
            <Value><xsl:value-of select="tempo"/> 2</Value>
	      </Automation>
          <xsl:for-each select="components/tempo" >
            <Automation>
              <Type>Tempo</Type>      
              <Linear>false</Linear>
              <Bar><xsl:value-of select="measure"/></Bar>
              <Position><xsl:value-of select="graphPosition div $DEFAULT_BAR_LENGTH"/></Position>
              <Text></Text>
              <Visible>true</Visible>
              <Value><xsl:value-of select="tempo"/> 2</Value>
		    </Automation>
	      </xsl:for-each>
		</Automations>
        <Tracks>
          <xsl:for-each select="tracks/track">
            <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
            <xsl:value-of select="@id"/>
          </xsl:for-each>
        </Tracks>
      </MasterTrack>
      <Tracks>
        <xsl:for-each select="tracks/track">
        <Track>
          <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
          <Name><xsl:value-of select="name"/></Name>
          <Color>0 0 0</Color>
          <PlayingStyle>Default</PlayingStyle>
          <GeneralMidi table="Instrument">
            <Program><xsl:value-of select="instrument"/></Program>
            <Port>0</Port>
            <PrimaryChannel>
              <xsl:value-of select="@id * 2 + 1"/>
            </PrimaryChannel>
            <SecondaryChannel>
              <xsl:value-of select="@id * 2 + 2"/>
            </SecondaryChannel>
          </GeneralMidi>
          <ChannelStrip>
            <Volume><xsl:value-of select="(15 - volume) * 255 div 15"/></Volume>
            <Pan><xsl:value-of select="pan * 255 div 15"/></Pan>
          </ChannelStrip>
          <PlaybackState>Default</PlaybackState>
          <Properties>
            <Property name="Tuning">
              <Pitches>
                <xsl:for-each select="strings/string">
                  <xsl:sort select="@id" data-type="number" order="descending"/>
                  <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
                  <xsl:value-of select="96 - ."/>
                </xsl:for-each>
              </Pitches>
            </Property>
            <Property name="CapoFret">
              <Fret><xsl:value-of select="capo"/></Fret>
  		    </Property>
            <xsl:variable name="trackStringCount" select="count(strings/string)"/>
            <!--Property name="ChordCollection">
              <Chords>
                <xsl:for-each select="/tabledit/chords/chord">
                  <Chord spanLimit="5" barsStates="0 0 0 0 0">
                    <xsl:attribute name="name"><xsl:value-of select="name"/></xsl:attribute>
                    <xsl:attribute name="baseFret"><xsl:value-of select="baseFret - 1"/></xsl:attribute>
                    <xsl:attribute name="frets">
                      <xsl:for-each select="strings/string[@id &lt; $trackStringCount]">
                        <xsl:sort select="@id" data-type="number" order="descending"/>
                        <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
                        <xsl:choose>
                          <xsl:when test =". &gt; 0">
                            <xsl:value-of select=". - ../../baseFret + 1"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="."/>
                          </xsl:otherwise>
                        </xsl:choose>                        
                      </xsl:for-each>
                    </xsl:attribute>
                  </Chord>
                </xsl:for-each>
              </Chords>
            </Property-->
          </Properties>
        </Track>
        </xsl:for-each>
      </Tracks>
      <MasterBars>
        <xsl:call-template name="MasterBars">
          <xsl:with-param name="count" select="measures"/>
        </xsl:call-template>
      </MasterBars>
      <Bars>
        <xsl:for-each select="tracks/track">
          <xsl:variable name="track" select="." />
          <xsl:variable name="trackId" select="@id"/>
          <xsl:for-each select="measures/measure">
            <xsl:variable name="i" select="@id * $tracks + $trackId"/>
            <Bar>
              <xsl:attribute name="id"><xsl:value-of select="$i"/></xsl:attribute>
              <xsl:choose>
                <xsl:when test="$track/clefNumber &lt;= 1 "><Clef>G2</Clef></xsl:when>
                <xsl:when test="$track/clefNumber = 2 or $track/clefNumber = 3"><Clef>F4</Clef></xsl:when>
                <xsl:when test="$track/clefNumber = 4"><Clef>C4</Clef></xsl:when>
                <xsl:otherwise><Clef>C3</Clef></xsl:otherwise>
              </xsl:choose>
              <xsl:if test="$track/clefType = -12">
                <Ottavia>8vb</Ottavia>
			  </xsl:if>
              <Voices>
                <xsl:call-template name="VoiceIndexes">
                  <xsl:with-param name="count" select="$MAX_VOICES"/>
                  <xsl:with-param name="start" select="$i * $MAX_VOICES"/>
                  <xsl:with-param name="track" select="$trackId"/>
                  <xsl:with-param name="measure" select="@id"/>
                  <xsl:with-param name="voiceCount" select="voiceCount"/>
                </xsl:call-template>
              </Voices>
            </Bar>
          </xsl:for-each>
        </xsl:for-each>
      </Bars>
      <Voices>
        <xsl:call-template name="Voices">
          <xsl:with-param name="count" select="measures * $tracks * $MAX_VOICES"/>
        </xsl:call-template>
      </Voices>
      <Beats>
        <xsl:for-each select="tracks/track">
          <xsl:call-template name="Beats">
            <xsl:with-param name="track" select="@id"/>
            <xsl:with-param name="count" select="/tabledit/measures * $MAX_VOICES"/>
          </xsl:call-template>
        </xsl:for-each>
      </Beats>
      <Notes>
        <xsl:for-each select="components/note">
          <xsl:variable name="note" select="."/>
          <Note>
            <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
            <xsl:variable name="track" select="track"/>
            <xsl:variable name="measure" select="measure"/>
            <xsl:variable name="voice" select="voice"/>
            <xsl:variable name="graphPosition" select="graphPosition"/>
            
            <Tie>
              <xsl:variable name="tieDestination" select="../note[string = $note/string and fret = $note/fret and voice = $voice and ((measure = $note/measure and position &gt; $note/position) or measure = $note/measure + 1) and track = $track][1]" />
              <xsl:variable name="tieOrigin" select="../note[string = $note/string and fret = $note/fret and voice = $voice and ((measure = $note/measure and position &lt; $note/position) or measure = $note/measure - 1) and track = $track][last()]" />
                <xsl:attribute name="origin">
                <xsl:value-of select="boolean($tieDestination and $tieDestination/dynamic = 14)"/>
              </xsl:attribute>
              <xsl:attribute name="destination">
                <xsl:value-of select="boolean($tieOrigin and dynamic = 14)"/>
              </xsl:attribute>
            </Tie>
            <xsl:choose>
              <xsl:when test="effect = -1"><LetRing/></xsl:when>
              <xsl:when test="effect = -7"><Accent>1</Accent></xsl:when>              
              <xsl:when test="effect = -4"><AntiAccent>Normal</AntiAccent></xsl:when>
            </xsl:choose>
            <xsl:if test="leftFinger">
              <LeftFingering>
                <xsl:call-template name="Fingering">
                  <xsl:with-param name="finger" select="leftFinger"/>
                </xsl:call-template>
              </LeftFingering>
            </xsl:if>
            <xsl:if test="rightFinger">
              <RightFingering>
                <xsl:call-template name="Fingering">
                  <xsl:with-param name="finger" select="rightFinger"/>
                </xsl:call-template>
              </RightFingering>
            </xsl:if>
            <!-- VibratoWTremBar, Vibrato-->
            <xsl:if test="effect = 10">
              <Vibrato>Slight</Vibrato>
            </xsl:if>
            <Properties>
              <Property name="String">
                <String>
                  <xsl:value-of select="count(/tabledit/tracks/track[@id = $track]/strings/string) - realString - 1"/>
                </String>
              </Property>
              <Property name="Fret">
                <Fret>
                  <xsl:value-of select="fret"/>
                </Fret>
              </Property>
              <!-- HoPo -->
              <xsl:if test="effect = 1 or effect = 2">
                <Property name="HopoOrigin"><Enable /></Property>
              </xsl:if>
              <xsl:variable name="hopoOrigin" select="../note[string = $note/string and fret != $note/fret and voice = $voice and ((measure = $note/measure and position &lt; $note/position) or measure = $note/measure - 1) and track = $track][last()]" />
              <xsl:if test="$hopoOrigin and $hopoOrigin/effect = 1 or $hopoOrigin/effect = 2">
                <Property name="HopoDestination"><Enable /></Property>
			  </xsl:if>
              <!-- Note Effects -->
              <xsl:choose>
                <!-- Dead, PalmMuted, Tapped, Choked -->
                <xsl:when test="effect = 15">
                  <Property name="Muted"><Enable/></Property>
                </xsl:when>
                <xsl:when test="effect = 8">
                  <Property name="PalmMuted"><Enable/></Property>
                </xsl:when>
                <xsl:when test="effect = 9">
                  <Property name="Tapped"><Enable/></Property>
                </xsl:when>
                <!-- Brush -->
                <xsl:when test="effect = 5">
                  <Property name="Brush">
                    <Direction>Down</Direction>
                  </Property>
                </xsl:when>
                <!-- Choke -->
                <xsl:when test="effect = 4">
                  <Property name="Bended"><Enable /></Property>
                  <Property name="BendOriginValue"><Float>0</Float></Property>
                  <Property name="BendMiddleValue"><Float>-1</Float></Property>
                  <Property name="BendDestinationValue"><Float>25</Float></Property>
                  <Property name="BendOriginOffset"><Float>0</Float></Property>
                  <Property name="BendMiddleOffset1"><Float>12</Float></Property>
                  <Property name="BendMiddleOffset2"><Float>12</Float></Property>
                  <Property name="BendDestinationOffset"><Float>25</Float></Property>
                </xsl:when>
                <!-- Bend -->
                <xsl:when test="effect = 12"> 
                  <Property name="Bended"><Enable /></Property>
                  <Property name="BendOriginValue"><Float>0</Float></Property>
                  <Property name="BendMiddleValue"><Float>-1</Float></Property>
                  <Property name="BendDestinationValue"><Float>100</Float></Property>
                  <Property name="BendOriginOffset"><Float>0</Float></Property>
                  <Property name="BendMiddleOffset1"><Float>12</Float></Property>
                  <Property name="BendMiddleOffset2"><Float>12</Float></Property>
                  <Property name="BendDestinationOffset"><Float>25</Float></Property>
			    </xsl:when>
                <!-- BendNRelease -->
                <xsl:when test="effect = 13">
                  <Property name="Bended"><Enable /></Property>
                  <Property name="BendOriginValue"><Float>0</Float></Property>
                  <Property name="BendMiddleValue"><Float>100</Float></Property>
                  <Property name="BendDestinationValue"><Float>0</Float></Property>
                  <Property name="BendOriginOffset"><Float>0</Float></Property>
                  <Property name="BendMiddleOffset1"><Float>17</Float></Property>
                  <Property name="BendMiddleOffset2"><Float>34</Float></Property>
                  <Property name="BendDestinationOffset"><Float>50</Float></Property>
			    </xsl:when>
                <!-- Slide -->
                <xsl:when test="effect = 3">
                  <Property name="Slide"><Flags>2</Flags></Property>
                </xsl:when>
                <!-- HarmonicType -->
                <xsl:when test="effect = 6">
                  <Property name="HarmonicType"><HType>Natural</HType></Property>
                  <Property name="HarmonicFret"><HFret>12</HFret></Property>
                </xsl:when>
                <xsl:when test="effect = 7">
                  <Property name="HarmonicType"><HType>Artificial</HType></Property>
                  <Property name="HarmonicFret"><HFret>12</HFret></Property>
                </xsl:when>
              </xsl:choose>
            </Properties>
          </Note>
        </xsl:for-each>
      </Notes>
      <Rhythms>
        <Rhythm id="0">
          <NoteValue>Whole</NoteValue>
        </Rhythm>
        <Rhythm id="1">
          <NoteValue>Half</NoteValue>
          <AugmentationDot count="1"/>
        </Rhythm>
        <Rhythm id="2">
          <NoteValue>Whole</NoteValue>
          <PrimaryTuplet den="2" num="3"/>
        </Rhythm>
        <Rhythm id="3">
          <NoteValue>Half</NoteValue>
        </Rhythm>
        <Rhythm id="4">
          <NoteValue>Quarter</NoteValue>
          <AugmentationDot count="1"/>
        </Rhythm>
        <Rhythm id="5">
          <NoteValue>Half</NoteValue>
          <PrimaryTuplet den="2" num="3"/>
        </Rhythm>
        <Rhythm id="6">
          <NoteValue>Quarter</NoteValue>
        </Rhythm>
        <Rhythm id="7">
          <NoteValue>Eighth</NoteValue>
          <AugmentationDot count="1"/>
        </Rhythm>
        <Rhythm id="8">
          <NoteValue>Quarter</NoteValue>
          <PrimaryTuplet den="2" num="3"/>
        </Rhythm>
        <Rhythm id="9">
          <NoteValue>Eighth</NoteValue>
        </Rhythm>
        <Rhythm id="10">
          <NoteValue>16th</NoteValue>
          <AugmentationDot count="1"/>
        </Rhythm>
        <Rhythm id="11">
          <NoteValue>Eighth</NoteValue>
          <PrimaryTuplet den="2" num="3"/>
        </Rhythm>
        <Rhythm id="12">
          <NoteValue>16th</NoteValue>
        </Rhythm>
        <Rhythm id="13">
          <NoteValue>32nd</NoteValue>
          <AugmentationDot count="1"/>
        </Rhythm>
        <Rhythm id="14">
          <NoteValue>16th</NoteValue>
          <PrimaryTuplet den="2" num="3"/>
        </Rhythm>
        <Rhythm id="15">
          <NoteValue>32nd</NoteValue>
        </Rhythm>
        <Rhythm id="16">
          <NoteValue>64th</NoteValue>
          <AugmentationDot count="1"/>
        </Rhythm>
        <Rhythm id="17">
          <NoteValue>32nd</NoteValue>
          <PrimaryTuplet den="2" num="3"/>
        </Rhythm>
        <Rhythm id="18">
          <NoteValue>64th</NoteValue>
        </Rhythm>
        <Rhythm id="19">
          <NoteValue>128th</NoteValue>
          <AugmentationDot count="1"/>
        </Rhythm>
        <Rhythm id="20">
          <NoteValue>64th</NoteValue>
          <PrimaryTuplet den="2" num="3"/>
        </Rhythm>
      </Rhythms>
    </GPIF>
  </xsl:template>

  <xsl:template name="MasterBars">
    <xsl:param name="i" select="0"/>
    <xsl:param name="count" select="1"/>
    <xsl:if test="$i &lt; $count">
      <MasterBar>
        <Key>
          <AccidentalCount>
            <xsl:choose>
              <xsl:when test="key/variable = 1">
                <xsl:if test="not(keys/key[@id = $i]/sharps = 1)">-</xsl:if><xsl:value-of select="keys/key[@id = $i]/accidentals"/>                
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="not(key/sharps = 1)">-</xsl:if><xsl:value-of select="key/accidentals"/>                
              </xsl:otherwise>
            </xsl:choose>            
          </AccidentalCount>
          <Mode>
            <xsl:choose>
              <xsl:when test="key/major = 1">Major</xsl:when>
              <xsl:otherwise>Minor</xsl:otherwise>
            </xsl:choose>
          </Mode>
        </Key>
        <Time>
          <xsl:choose>
            <xsl:when test="timeSignatureChanges/timeSignatureChange[measure &lt;= $i]">
              <xsl:value-of select="timeSignatureChanges/timeSignatureChange[measure &lt;= $i][last()]/timeSignature/numerator"/>/<xsl:value-of select="timeSignatureChanges/timeSignatureChange[measure &lt;= $i][last()]/timeSignature/denominator"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="timeSignature/numerator"/>/<xsl:value-of select="timeSignature/denominator"/>
            </xsl:otherwise>
          </xsl:choose>
        </Time>
        <!-- repeat and alternate endings-->
        <xsl:variable name="repeat" select="components/repeat[measure = $i][1]"/>
        <xsl:if test="$repeat">
          <Repeat>
            <xsl:attribute name="start">
              <xsl:value-of select="boolean($repeat/open = 1)"/>
            </xsl:attribute> 
            <xsl:attribute name="end">
              <xsl:value-of select="boolean($repeat/close = 1)"/>
            </xsl:attribute> 
            <xsl:attribute name="count">
              <xsl:choose>
                <xsl:when test="$repeat/close = 1"><xsl:value-of select="$repeat/number"/></xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute> 
	  	  </Repeat>
          <xsl:if test="$repeat/ending = 1">
           <AlternateEndings><xsl:value-of select="$repeat/number"/></AlternateEndings>  
          </xsl:if>
        </xsl:if>
        <!-- directions -->
        <xsl:if test="$repeat and $repeat/direction &gt; 1">
          <Directions>
            <xsl:choose>
              <xsl:when test="$repeat/direction = 2"><Jump>DaSegno</Jump></xsl:when>
              <xsl:when test="$repeat/direction = 3"><Target>Segno</Target></xsl:when>
              <xsl:when test="$repeat/direction = 4"><Jump>DaCapoAlCoda</Jump></xsl:when>
              <xsl:when test="$repeat/direction = 5"><Target>Coda</Target></xsl:when>
            </xsl:choose>
          </Directions>
        </xsl:if>
        <!-- fermatas -->
        <xsl:variable name="fermata" select="components/character[measure = $i and (id = 7 or id = 8)]" />
        <xsl:if test="$fermata">
          <Fermatas>
            <xsl:for-each select="$fermata">
              <Fermata>
                <Type>Medium</Type>
                <Offset><xsl:value-of select="graphPosition"/>/<xsl:value-of select="$DEFAULT_BAR_LENGTH"/></Offset>
                <Length>0</Length>
              </Fermata>
            </xsl:for-each>
          </Fermatas>
        </xsl:if>
        <!-- sections -->
        <xsl:variable name="section" select="components/character[measure = $i and graphPosition = 0]" />
        <xsl:if test="$section and $section[id = 9 or id = 10 or id = 11 or id = 12]">
          <Section>
            <xsl:choose>
              <xsl:when test="$section/id = 9">
                <Letter>A</Letter>
              </xsl:when>
              <xsl:when test="$section/id = 10">
                <Letter>B</Letter>
              </xsl:when>
              <xsl:when test="$section/id = 11">
                <Letter>C</Letter>
              </xsl:when>
              <xsl:when test="$section/id = 12">
                <Letter>D</Letter>
              </xsl:when>
            </xsl:choose>
            <Text></Text>
          </Section>
        </xsl:if>
        <Bars>
          <xsl:call-template name="Indexes">
            <xsl:with-param name="count" select="$tracks"/>
            <xsl:with-param name="start" select="$i * $tracks"/>
          </xsl:call-template>
        </Bars>
      </MasterBar>
      <xsl:call-template name="MasterBars">
        <xsl:with-param name="count" select="$count"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Indexes">
    <xsl:param name="i" select="0"/>
    <xsl:param name="start" select="0"/>
    <xsl:param name="count" select="1"/>
    <xsl:param name="step" select="1"/>
    <xsl:if test="$i &lt; $count">
      <xsl:if test="$i != 0"><xsl:text> </xsl:text></xsl:if>
      <xsl:value-of select="$start + $i"/>
      <xsl:call-template name="Indexes">
        <xsl:with-param name="start" select="$start"/>
        <xsl:with-param name="count" select="$count"/>
        <xsl:with-param name="step" select="$step"/>
        <xsl:with-param name="i" select="$i + $step"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="VoiceIndexes">
    <xsl:param name="i" select="0"/>
    <xsl:param name="start" select="0"/>
    <xsl:param name="count" select="1"/>
    <xsl:param name="track" select="0"/>
    <xsl:param name="measure" select="0"/>
    <xsl:param name="voiceCount" select="0"/>
    <xsl:if test="$i &lt; $count">
      <xsl:if test="$i != 0"><xsl:text> </xsl:text></xsl:if>
      <xsl:choose>
        <xsl:when test="$i &lt; $voiceCount">
          <xsl:value-of select="$start + $i"/>
        </xsl:when>
        <xsl:otherwise>-1</xsl:otherwise>
      </xsl:choose>      
      <xsl:call-template name="VoiceIndexes">
        <xsl:with-param name="start" select="$start"/>
        <xsl:with-param name="count" select="$count"/>
        <xsl:with-param name="track" select="$track"/>
        <xsl:with-param name="measure" select="$measure"/>
        <xsl:with-param name="voiceCount" select="$voiceCount"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Voices">
    <xsl:param name="i" select="0"/>
    <xsl:param name="count" select="1"/>
    
    <xsl:variable name="bar" select="floor($i div $MAX_VOICES)"/>
    <xsl:variable name="measure" select="floor($bar div $tracks)"/>
    <xsl:variable name="track" select="$bar mod $tracks"/>
    <xsl:variable name="voice" select="$i mod $MAX_VOICES"/>
    <xsl:variable name="barLength">
      <xsl:choose>
        <xsl:when test="timeSignatureChanges/timeSignatureChange[measure &lt;= $measure]">
          <xsl:value-of select="$DEFAULT_BAR_LENGTH * timeSignatureChanges/timeSignatureChange[measure &lt;= $measure][last()]/timeSignature/numerator
                        div timeSignatureChanges/timeSignatureChange[measure &lt;= $measure][last()]/timeSignature/denominator"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$DEFAULT_BAR_LENGTH * timeSignature/numerator div timeSignature/denominator"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$i &lt; $count">
      <xsl:if test="key('voiceNotes', concat($track, '-', $measure, '-', $voice))">
        <Voice>
          <xsl:attribute name="id">
            <xsl:value-of select="$i"/>
          </xsl:attribute>
          <Beats>
            <xsl:for-each select="key('voiceNotes', concat($track, '-', $measure, '-', $voice))">
              <xsl:choose>
                <xsl:when test="position() = 1">
                  <!-- if the first note position is not 0, add the rest -->
                  <xsl:if test="position &gt; 0">
                    <xsl:value-of select="@id + 100000"/><xsl:text> </xsl:text>
                  </xsl:if>
                  <!-- add the first beat -->
                  <xsl:value-of select="@id"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="p" select="position()"/>
                  <xsl:if test="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[$p - 1]/position &lt; position">
                    <!-- if the end of the previous note is not equal to this note beginning, add the rest -->
                    <xsl:if test="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[$p - 1]/endPosition + 1 &lt; position">
                      <xsl:text> </xsl:text><xsl:value-of select="@id + 100000"/>
                    </xsl:if>
                    <xsl:text> </xsl:text><xsl:value-of select="@id"/>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <!-- if the last note end position is not $barLength, add the final rest -->
              <xsl:if test="(position() = last()) and (endPosition &lt; $barLength - 1)">
                <xsl:text> </xsl:text><xsl:value-of select="@id + 200000"/>
              </xsl:if>
            </xsl:for-each>
          </Beats>
        </Voice>
      </xsl:if>
      <xsl:call-template name="Voices">
        <xsl:with-param name="count" select="$count"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Beats">
    <xsl:param name="i" select="0"/>
    <xsl:param name="count" select="1"/>
    <xsl:param name="track" select="0"/>

    <xsl:variable name="measure" select="floor($i div $MAX_VOICES)"/>
    <xsl:variable name="voice" select="$i mod $MAX_VOICES"/>
    <xsl:variable name="barLength">
      <xsl:choose>
        <xsl:when test="/tabledit/timeSignatureChanges/timeSignatureChange[measure &lt;= $measure]">
          <xsl:value-of select="$DEFAULT_BAR_LENGTH * /tabledit/timeSignatureChanges/timeSignatureChange[measure &lt;= $measure][last()]/timeSignature/numerator
                        div /tabledit/timeSignatureChanges/timeSignatureChange[measure &lt;= $measure][last()]/timeSignature/denominator"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$DEFAULT_BAR_LENGTH * /tabledit/timeSignature/numerator div /tabledit/timeSignature/denominator"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$i &lt; $count">
      <xsl:for-each select="key('voiceNotes', concat($track, '-', $measure, '-', $voice))">
        <xsl:choose>
          <xsl:when test="position() = 1">
            <!-- if the first note position is not 0, add the rest -->
            <xsl:if test="position &gt; 0">
              <Beat>
                <xsl:attribute name="id"><xsl:value-of select="@id + 100000"/></xsl:attribute>
                <Rhythm>
                  <xsl:attribute name="ref">
                    <xsl:call-template name="Duration">
                      <xsl:with-param name="position" select="position"/>
                    </xsl:call-template>
                  </xsl:attribute>
                </Rhythm>
              </Beat>
            </xsl:if>
            <!-- add the first beat -->
            <xsl:call-template name="Beat">
              <xsl:with-param name="measure" select="$measure"/>
              <xsl:with-param name="track" select="$track"/>
              <xsl:with-param name="voice" select="$voice"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="p" select="position()"/>
            <xsl:if test="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[$p - 1]/position &lt; position">
              <!-- if the end of the previous note is not equal to this note beginning, add the rest -->
              <xsl:if test="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[$p - 1]/endPosition + 1 &lt; position">
                <Beat>
                  <xsl:attribute name="id"><xsl:value-of select="@id + 100000"/></xsl:attribute>
                  <Rhythm>
                    <xsl:attribute name="ref">
                      <xsl:call-template name="Duration">
                        <xsl:with-param name="position" select="position - key('voiceNotes', concat($track, '-', $measure, '-', $voice))[$p - 1]/endPosition"/>
                      </xsl:call-template>
                    </xsl:attribute>
                  </Rhythm>
                </Beat>
              </xsl:if>
              <xsl:call-template name="Beat">
                <xsl:with-param name="measure" select="$measure"/>
                <xsl:with-param name="track" select="$track"/>
                <xsl:with-param name="voice" select="$voice"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <!-- if the last note end position is not $barLength, add the final rest -->
        <xsl:if test="(position() = last()) and (endPosition &lt; $barLength - 1)">
          <Beat>
            <xsl:attribute name="id">
              <xsl:value-of select="@id + 200000"/>
            </xsl:attribute>
            <Rhythm>
              <xsl:attribute name="ref">
                <xsl:call-template name="Duration">
                  <xsl:with-param name="position" select="$barLength - endPosition"/>
                </xsl:call-template>
              </xsl:attribute>
            </Rhythm>
          </Beat>
        </xsl:if>
      </xsl:for-each>

      <xsl:call-template name="Beats">
        <xsl:with-param name="count" select="$count"/>
        <xsl:with-param name="track" select="$track"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Beat">
    <xsl:param name="measure" select="0"/>
    <xsl:param name="voice" select="0"/>
    <xsl:param name="track" select="0"/>
    <Beat>
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      <Rhythm>
        <xsl:attribute name="ref"><xsl:value-of select="duration"/></xsl:attribute>
      </Rhythm>
      <xsl:call-template name="Dynamic">
        <xsl:with-param name="value" select="dynamic"/>
      </xsl:call-template>
      <xsl:variable name="beatPosition" select="position"/>
      <xsl:variable name="beatGraphPosition" select="graphPosition"/>
      <xsl:if test="/tabledit/components/text[measure = $measure and track = $track and graphPosition = $beatGraphPosition]">
        <FreeText>
          &lt;span&gt;
          <xsl:value-of select="/tabledit/texts/text[@id = /tabledit/components/text[measure = $measure and track = $track and graphPosition = $beatGraphPosition][1]/text]"/>
          &lt;/span&gt;
        </FreeText>
      </xsl:if>  
      <xsl:if test="/tabledit/components/cresc[measure = $measure and graphPosition = $beatGraphPosition]">
        <Hairpin>
          <xsl:choose>
            <xsl:when test="/tabledit/components/cresc[measure = $measure and graphPosition = $beatGraphPosition]/diminuendo = 1">Decrescendo</xsl:when>
            <xsl:otherwise>Crescendo</xsl:otherwise>
          </xsl:choose>  
	    </Hairpin>
      </xsl:if>
      <xsl:if test="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[position = $beatPosition]">
        <Notes>
          <xsl:for-each select="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[position = $beatPosition]">
            <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
            <xsl:value-of select="@id"/>
          </xsl:for-each>
        </Notes>
      </xsl:if>
      <xsl:if test="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[position = $beatPosition and effect = 11]">
        <Tremolo>1/8</Tremolo>
      </xsl:if>
      <xsl:if test="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[position = $beatPosition and effect = 14]">
        <Arpeggio>Down</Arpeggio>
      </xsl:if>
      <xsl:if test="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[position = $beatPosition and effect = -8]">
        <FadeIn/>
      </xsl:if>
      <Properties>
        <!--xsl:if test="/tabledit/components/chord[measure = $measure and track = $track and graphPosition = $beatGraphPosition]">
          <Property name="Chord">
            <Name><xsl:value-of select="/tabledit/chords/chord[/tabledit/components/chord[measure = $measure and track = $track and graphPosition = $beatGraphPosition][1]/chord + 1]/name"/></Name>
          </Property>
        </xsl:if-->
        <!-- Slapped -->
        <xsl:variable name="slappedNote" select="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[position = $beatPosition and effect = -2][1]"/>
        <xsl:if test="$slappedNote">
          <Property name="Slapped"><Enable/></Property>
        </xsl:if>
        <!-- Rasgueado -->
        <!--xsl:if test="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[position = $beatPosition and effect = 14]">
          <Property name="Rasgueado"><Rasgueado>amip_1</Rasgueado></Property>
        </xsl:if-->
        <!-- PickStroked -->
        <xsl:variable name="pickStrokedNote" select="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[position = $beatPosition and stroke &gt; 2][1]"/>
        <xsl:if test="$pickStrokedNote">
          <Property name="PickStroke">
            <Direction>
              <xsl:choose>
                <xsl:when test="$pickStrokedNote/stroke = 3">Up</xsl:when>
                <xsl:when test="$pickStrokedNote/stroke = 4">Down</xsl:when>
              </xsl:choose>
            </Direction>
          </Property>
        </xsl:if>
        <!-- WhammyBar -->
        <xsl:variable name="whammyNote" select="key('voiceNotes', concat($track, '-', $measure, '-', $voice))[position = $beatPosition and (effect = -5 or effect = -6)][1]"/>
        <xsl:if test="$whammyNote">
          <Property name="WhammyBar">
            <WhammyBarDescription>
              <Type>
                <xsl:choose>
                  <xsl:when test="$whammyNote/effect = -5 and $whammyNote/bendValue &lt; 0">Dive</xsl:when>
                  <xsl:when test="$whammyNote/effect = -5">Return</xsl:when>
                  <xsl:when test="$whammyNote/effect = -6 and $whammyNote/bendValue &lt; 0">Dip</xsl:when>
                  <xsl:when test="$whammyNote/effect = -6">Inverted</xsl:when>
                </xsl:choose>
              </Type>
              <Value>
                <xsl:choose>
                  <xsl:when test="$whammyNote/bendValue &gt; 0">
                    <xsl:value-of select="$whammyNote/bendValue * 50"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="(0 - $whammyNote/bendValue) * 50"/>
                  </xsl:otherwise>
                </xsl:choose>
              </Value>
              <Points>
                <Point>0 0 0</Point>
              </Points>
            </WhammyBarDescription>
          </Property>
        </xsl:if>
      </Properties>
    </Beat>
  </xsl:template>
  
  <xsl:template name="Dynamic">
    <xsl:param name="value" select="4"/>
    <Dynamic>
      <xsl:choose>
        <xsl:when test="$value = 14">PPP</xsl:when>
        <xsl:when test="$value = 12">PP</xsl:when>
        <xsl:when test="$value = 10">P</xsl:when>
        <xsl:when test="$value = 8">MP</xsl:when>
        <xsl:when test="$value = 6">MF</xsl:when>
        <xsl:when test="$value = 4">F</xsl:when>
        <xsl:when test="$value = 2">FF</xsl:when>
        <xsl:when test="$value = 0">FFF</xsl:when>
        <xsl:otherwise>None</xsl:otherwise>
      </xsl:choose>
    </Dynamic>    
  </xsl:template>

  <xsl:template name="Duration">
    <xsl:param name="position" select="0"/>
    <xsl:choose>
      <xsl:when test="256 - $position &lt; 2">0</xsl:when>
      <xsl:when test="192 - $position &lt; 2">1</xsl:when>
      <xsl:when test="171 - $position &lt; 2">2</xsl:when>
      <xsl:when test="128 - $position &lt; 2">3</xsl:when>
      <xsl:when test="96  - $position &lt; 2">4</xsl:when>
      <xsl:when test="85  - $position &lt; 2">5</xsl:when>
      <xsl:when test="64  - $position &lt; 2">6</xsl:when>
      <xsl:when test="48  - $position &lt; 2">7</xsl:when>
      <xsl:when test="43  - $position &lt; 2">8</xsl:when>
      <xsl:when test="32  - $position &lt; 2">9</xsl:when>
      <xsl:when test="24  - $position &lt; 2">10</xsl:when>
      <xsl:when test="21  - $position &lt; 2">11</xsl:when>
      <xsl:when test="16  - $position &lt; 2">12</xsl:when>
      <xsl:when test="12  - $position &lt; 2">13</xsl:when>
      <xsl:when test="11  - $position &lt; 2">14</xsl:when>
      <xsl:when test="8   - $position &lt; 2">15</xsl:when>
      <xsl:when test="6   - $position &lt; 2">16</xsl:when>
      <xsl:when test="5   - $position &lt; 2">17</xsl:when>
      <xsl:when test="4   - $position &lt; 2">18</xsl:when>
      <xsl:when test="3   - $position &lt; 2">19</xsl:when>
      <xsl:when test="3   - $position &lt; 2">20</xsl:when>
      <xsl:otherwise>6</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="Fingering">
    <xsl:param name="finger" select="0"/>
    <xsl:choose>
      <xsl:when test="$finger = 0">None</xsl:when>
      <xsl:when test="$finger = 1">P</xsl:when>
      <xsl:when test="$finger = 2">I</xsl:when>
      <xsl:when test="$finger = 3">M</xsl:when>
      <xsl:when test="$finger = 4">A</xsl:when>
      <xsl:when test="$finger = 5">C</xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
