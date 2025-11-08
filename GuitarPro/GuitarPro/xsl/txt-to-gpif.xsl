<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" cdata-section-elements="Title Artist Album Words Music Copyright Tabber Instructions Name ShortName"/>
  
  <xsl:template name="StepPitch">
    <xsl:param name="step" select="0"/>
    <xsl:param name="alter" select="0"/>
    <xsl:variable name="alterPitch">
      <xsl:choose>
        <xsl:when test="$alter">
          <xsl:value-of select="$alter"/>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="stepPitch">
      <xsl:choose>
        <xsl:when test="$step = 'B'">11</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(translate($step, 'CDEFGA', '024579'))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$stepPitch + $alterPitch"/>
  </xsl:template>

  <xsl:template name="NotePitch">
    <xsl:param name="note" select="E"/>
    <xsl:variable name="alter">
      <xsl:choose>
        <xsl:when test="substring($note, 2) = '#'">1</xsl:when>
        <xsl:when test="substring($note, 2) = 'b'">-1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="StepPitch">
      <xsl:with-param name="step" select="substring($note, 1, 1)"/>
      <xsl:with-param name="alter" select="$alter"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="StandardTuning">
    <xsl:param name="string" select="1"/>
    <xsl:param name="strings" select="6"/>
    <!-- additional string -->
    <xsl:variable name="s">
      <xsl:choose>
        <xsl:when test="$strings = 4 or $strings = 6">
          <xsl:value-of select="$string"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$string - 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pitch">
      <xsl:choose>
        <xsl:when test="$s = 0">35</xsl:when>
        <xsl:when test="$s = 1">40</xsl:when>
        <xsl:when test="$s = 2">45</xsl:when>
        <xsl:when test="$s = 3">50</xsl:when>
        <xsl:when test="$s = 4">55</xsl:when>
        <xsl:when test="$s = 5">59</xsl:when>
        <xsl:otherwise>64</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- guitar or bass -->
    <xsl:choose>
      <xsl:when test="$strings &lt; 6">
        <xsl:value-of select="$pitch - 12"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$pitch"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="abs">
    <xsl:param name="x" select="0"/>
    <xsl:choose>
      <xsl:when test="x &lt; 0">
        <xsl:value-of select="-$x"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$x"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ClosestNumber">
    <xsl:param name="n" select="0"/>
    <xsl:param name="x1" select="0"/>
    <xsl:param name="x2" select="0"/>
    <xsl:variable name="d1">
      <xsl:call-template name="abs">
        <xsl:with-param name="x" select="$n - $x1"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="d2">
      <xsl:call-template name="abs">
        <xsl:with-param name="x" select="$n - $x2"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$d1 &lt; $d2">
        <xsl:value-of select="$x1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$x2"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="ClosestNumber3">
    <xsl:param name="n" select="0"/>
    <xsl:param name="x1" select="0"/>
    <xsl:param name="x2" select="0"/>
    <xsl:param name="x3" select="0"/>
    <xsl:variable name="c1">
      <xsl:call-template name="ClosestNumber">
        <xsl:with-param name="n" select="$n"/>
        <xsl:with-param name="x1" select="$x1"/>
        <xsl:with-param name="x2" select="$x2"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="c2">
      <xsl:call-template name="ClosestNumber">
        <xsl:with-param name="n" select="$n"/>
        <xsl:with-param name="x1" select="$x1"/>
        <xsl:with-param name="x3" select="$x3"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="ClosestNumber">
      <xsl:with-param name="n" select="$n"/>
      <xsl:with-param name="x1" select="$c1"/>
      <xsl:with-param name="x2" select="$c2"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tab">
    <xsl:variable name="clef">
      <xsl:choose>
       <xsl:when test="strings &lt; 6">F4</xsl:when>
       <xsl:otherwise>G2</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <GPIF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="gpif.xsd">
      <Score>
        <Title><xsl:value-of select="song"/></Title>
        <Artist><xsl:value-of select="artist"/></Artist>
        <Album><xsl:value-of select="album"/></Album>
        <Tabber><xsl:value-of select="tabber"/></Tabber>
      </Score>
      <MasterTrack>
        <Tracks>0</Tracks>
	  </MasterTrack>
      <Tracks>
        <Track id="0">
          <Name>Track 1</Name>
          <Color>0 0 0</Color>
          <PlayingStyle>Default</PlayingStyle>
          <GeneralMidi table="Instrument">
            <Program>
              <xsl:choose>
                <xsl:when test="strings &lt; 6">33</xsl:when>
                <xsl:otherwise>25</xsl:otherwise>
              </xsl:choose>
            </Program>
            <Port>0</Port>
            <PrimaryChannel>0</PrimaryChannel>
            <SecondaryChannel>0</SecondaryChannel>
          </GeneralMidi>
          <ChannelStrip>
            <Volume>192</Volume>
            <Pan>0</Pan>
          </ChannelStrip>
          <PlaybackState>Default</PlaybackState>
          <Properties>
            <Property name="Tuning">
			  <Pitches>
                <xsl:variable name="tuning" select="staff[1]/tuning"/>
                <xsl:choose>
                  <xsl:when test="$tuning">
                    <xsl:for-each select="$tuning/string">
                      <xsl:if test="position() != 1">
                        <xsl:text> </xsl:text>
                      </xsl:if>
                      <xsl:variable name="standardPitch">
                        <xsl:call-template name="StandardTuning">
                          <xsl:with-param name="string" select="position()"/>
                          <xsl:with-param name="strings" select="../../strings"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:variable name="notePitch">
                        <xsl:call-template name="NotePitch">
                          <xsl:with-param name="note" select="."/>
                        </xsl:call-template>
                      </xsl:variable>
                      <!-- find the pitch in the nearest octave to the standard tuning pitch -->
                      <xsl:variable name="pitch" select="$standardPitch - $standardPitch mod 12 + $notePitch"/>
                      <xsl:call-template name="ClosestNumber3">
                        <xsl:with-param name="n" select="$standardPitch"/>
                        <xsl:with-param name="x1" select="$pitch"/>
                        <xsl:with-param name="x2" select="$pitch - 12"/>
                        <xsl:with-param name="x3" select="$pitch + 12"/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="strings = 4">28 33 38 43</xsl:when>
                      <xsl:when test="strings = 5">23 28 33 38 43</xsl:when>
                      <xsl:when test="strings = 7">35 40 45 50 55 59 64</xsl:when>
                      <xsl:otherwise>40 45 50 55 59 64</xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </Pitches>
		    </Property>
          </Properties>
        </Track>
      </Tracks>
      <MasterBars>
        <xsl:for-each select="staff/position[barline]">
          <MasterBar>
            <Key>
              <AccidentalCount>0</AccidentalCount>
              <Mode>Major</Mode>
            </Key>
            <Time>4/4</Time>
            <Bars><xsl:value-of select="@id"/></Bars>
          </MasterBar>
        </xsl:for-each>
      </MasterBars>
      <Bars>
        <xsl:for-each select="staff/position[barline]">
          <Bar id="{@id}">
            <Clef><xsl:value-of select="$clef" /></Clef>
            <Voices><xsl:value-of select="@id"/> -1 -1 -1</Voices>
          </Bar>
        </xsl:for-each>
      </Bars>
      <Voices>
        <xsl:for-each select="staff/position[barline]">
          <xsl:variable name="nextBars" select="following::position[barline]"/>
          <xsl:variable name="lastBeatId">
            <xsl:choose>
              <xsl:when test="$nextBars"><xsl:value-of select="$nextBars[1]/@id"/></xsl:when>
              <xsl:otherwise>1000000</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <Voice id="{@id}">
            <Beats>
              <xsl:variable name="beats" select="(. | following::position)[note and @id &lt; $lastBeatId]"/>              
              <xsl:for-each select="$beats">
                <xsl:if test="position() != 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="@id"/>
              </xsl:for-each>
              <xsl:if test="not($beats)">1000000</xsl:if>
            </Beats>
          </Voice>
        </xsl:for-each>
      </Voices>
      <Beats>
        <xsl:for-each select="staff/position[note]">
          <Beat id="{@id}">
            <xsl:variable name="rhythm">
              <xsl:choose>
                <xsl:when test="width = 0">0</xsl:when>
                <xsl:when test="width &lt; 3">1</xsl:when>
                <xsl:otherwise>2</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <Rhythm ref="{$rhythm}"/>
            <Notes>
              <xsl:for-each select="note">
                <xsl:if test="position() != 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="@id"/>
              </xsl:for-each>
            </Notes>
          </Beat>
        </xsl:for-each>
        <Beat id="1000000">
          <Rhythm ref="2"/>
        </Beat>
      </Beats>
      <Notes>
        <xsl:for-each select="staff/position/note">
          <Note id="{@id}">
            <xsl:if test="ghost">
              <AntiAccent>Normal</AntiAccent>
            </xsl:if>
            <Properties>
              <Property name="String">
                <String><xsl:value-of select="../../strings - string - 1"/></String>
              </Property>
              <Property name="Fret">
                <Fret><xsl:value-of select="fret"/></Fret>
              </Property>
              <xsl:if test="legato">
                <Property name="HopoOrigin"><Enable /></Property>
              </xsl:if>
              <xsl:if test="preceding-sibling::note[string = ./string]/legato">
                <Property name="HopoDestination"><Enable /></Property>
              </xsl:if>
              <xsl:if test="dead">
                <Property name="Muted"><Enable/></Property>
              </xsl:if>
              <xsl:if test="harmonic">
                <Property name="HarmonicType">
                  <HType>Natural</HType>
                </Property>
                <Property name="HarmonicFret">
                  <HFret><xsl:value-of select="fret"/></HFret>
                </Property>
              </xsl:if>
              <xsl:if test="slide">
                <Property name="Slide">
                  <Flags>
                    <xsl:variable name="slideIn">
                      <xsl:choose>
                        <xsl:when test="slide/slideInUp">16</xsl:when>
                        <xsl:when test="slide/slideInDown">32</xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="slideOut">
                      <xsl:choose>
                        <xsl:when test="slide/slideOutUp">8</xsl:when>
                        <xsl:when test="slide/slideOutDown">4</xsl:when>
                        <xsl:when test="slide/slideOut">1</xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:value-of select="$slideIn + $slideOut"/>
                  </Flags>
                </Property>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="bend">
                    <Property name="Bended"><Enable /></Property>
                    <Property name="BendOriginValue"><Float>0</Float></Property>
                    <Property name="BendMiddleValue"><Float>-1</Float></Property>
                    <Property name="BendDestinationValue"><Float>50</Float></Property>
                    <Property name="BendOriginOffset"><Float>0</Float></Property>
                    <Property name="BendMiddleOffset1"><Float>12</Float></Property>
                    <Property name="BendMiddleOffset2"><Float>12</Float></Property>
                    <Property name="BendDestinationOffset"><Float>25</Float></Property>
                </xsl:when>
                <xsl:when test="release">
                    <Property name="Bended"><Enable /></Property>
                    <Property name="BendOriginValue"><Float>50</Float></Property>
                    <Property name="BendMiddleValue"><Float>-1</Float></Property>
                    <Property name="BendDestinationValue"><Float>0</Float></Property>
                    <Property name="BendOriginOffset"><Float>0</Float></Property>
                    <Property name="BendMiddleOffset1"><Float>12</Float></Property>
                    <Property name="BendMiddleOffset2"><Float>12</Float></Property>
                    <Property name="BendDestinationOffset"><Float>25</Float></Property>  
                </xsl:when>
              </xsl:choose>
            </Properties>
          </Note>
        </xsl:for-each>
      </Notes>
      <Rhythms>
        <Rhythm id="0">
          <NoteValue>16th</NoteValue>
        </Rhythm>
        <Rhythm id="1">
          <NoteValue>Eighth</NoteValue>
        </Rhythm>
        <Rhythm id="2">
          <NoteValue>Quarter</NoteValue>
        </Rhythm>
      </Rhythms>
    </GPIF>
  </xsl:template>
</xsl:stylesheet>
