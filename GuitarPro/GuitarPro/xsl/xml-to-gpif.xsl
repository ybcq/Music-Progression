<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" cdata-section-elements="Title Artist Album Words Music Copyright Tabber FirstPageHeader FirstPageFooter PageHeader PageFooter Name ShortName"/>
  
  <xsl:variable name="tracks" select="count(/score-timewise/part-list/score-part)"/>
  <xsl:variable name="MAX_VOICES" select="4"/>

  <xsl:template name="Range1">
    <xsl:param name="i" select="0"/>
    <xsl:param name="total" select="1"/>
    <xsl:if test="$i &lt; $total">
      <xsl:if test="$i != 0">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:value-of select="$i + 1"/>
      <xsl:call-template name="Range1">
        <xsl:with-param name="i" select="$i + 1"/>
        <xsl:with-param name="total" select="$total"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="RepeatString">
    <xsl:param name="repeat" select="1"/>
    <xsl:param name="str"/>
    <xsl:param name="delim" select="''"/>
    <xsl:if test="$repeat &gt; 0">
      <xsl:value-of select="$str"/>
      <xsl:if test="$repeat != 1">
        <xsl:value-of select="$delim"/>
      </xsl:if>
      <xsl:call-template name="RepeatString">
        <xsl:with-param name="repeat" select="$repeat - 1"/>
        <xsl:with-param name="str" select="$str"/>
        <xsl:with-param name="delim" select="$delim"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Iterate">
    <xsl:param name="template" select="''"/>
    <xsl:param name="i" select="0"/>
    <xsl:param name="total" select="1"/>
    <xsl:param name="arg1" select="0"/>
    <xsl:param name="arg2" select="0"/>
    <xsl:param name="arg3" select="0"/>
    <xsl:if test="$i &lt; $total">
      <xsl:choose>
        <xsl:when test="$template = 'ChordFret'">
          <xsl:call-template name="ChordFret">
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="total" select="$total"/>
            <xsl:with-param name="arg1" select="$arg1"/>
            <xsl:with-param name="arg2" select="$arg2"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$template = 'VoiceIndex'">
          <xsl:call-template name="VoiceIndex">
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="total" select="$total"/>
            <xsl:with-param name="arg1" select="$arg1"/>
            <xsl:with-param name="arg2" select="$arg2"/>
            <xsl:with-param name="arg3" select="$arg3"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$template = 'Voice'">
          <xsl:call-template name="Voice">
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="total" select="$total"/>
            <xsl:with-param name="arg1" select="$arg1"/>
            <xsl:with-param name="arg2" select="$arg2"/>
            <xsl:with-param name="arg3" select="$arg3"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$template = 'LyricsLine'">
          <xsl:call-template name="LyricsLine">
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="total" select="$total"/>
            <xsl:with-param name="arg1" select="$arg1"/>
            <xsl:with-param name="arg2" select="$arg2"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
      <xsl:call-template name="Iterate">
        <xsl:with-param name="template" select="$template"/>
        <xsl:with-param name="i" select="$i + 1"/>
        <xsl:with-param name="total" select="$total"/>
        <xsl:with-param name="arg1" select="$arg1"/>
        <xsl:with-param name="arg2" select="$arg2"/>
        <xsl:with-param name="arg3" select="$arg3"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="StepPitch">
    <xsl:param name="step" select="0"/>
    <xsl:param name="alter" select="0"/>
    <xsl:variable name="alterPitch">
      <xsl:choose>
        <xsl:when test="$alter">
          <xsl:value-of select="ceiling($alter)"/>
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
    <xsl:variable name="pitch" select="$stepPitch + $alterPitch" />
    <xsl:choose>
      <xsl:when test="$pitch &gt;= 0">            
        <xsl:value-of select="$pitch"/>          
	  </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="12 + $pitch"/>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>
  
  <xsl:template name="Pitch">
    <xsl:param name="step" select="0"/>
    <xsl:param name="octave" select="0"/>
    <xsl:param name="alter" select="0"/>
    <xsl:variable name="stepPitch">
      <xsl:call-template name="StepPitch">
        <xsl:with-param name="step" select="$step"/>
        <xsl:with-param name="alter" select="$alter"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="($octave + 1) * 12 + $stepPitch"/>
  </xsl:template>

  <xsl:template name="ChordFret">
    <xsl:param name="i" select="0"/>
    <xsl:param name="total" select="0"/>
    <xsl:param name="arg1" select="0"/>
    <xsl:param name="arg2" select="0"/>
    
    <xsl:variable name="frame" select="$arg1"/>
    <xsl:variable name="baseFret" select="$arg2"/>
    <xsl:variable name="note" select="$frame/frame-note[string = $total - $i]"/>
    
    <xsl:if test="$i != 0">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$note">
        <xsl:choose>
          <xsl:when test="$note/fret &gt; $baseFret">
            <xsl:value-of select="$note/fret - $baseFret"/>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>-1</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="VoiceIndex">
    <xsl:param name="i" select="0"/>
    <xsl:param name="arg1" select="0"/>
    <xsl:param name="arg2" select="0"/>
    <xsl:param name="arg3" select="0"/>

    <xsl:variable name="part" select="$arg1"/>
    <xsl:variable name="barId" select="$arg2"/>
    <xsl:variable name="staff" select="$arg3"/>
        
    <xsl:if test="$i != 0">
      <xsl:text> </xsl:text>
    </xsl:if> 
    <xsl:variable name="note" select="$part/note" />    
    <xsl:choose>
      <xsl:when test="$note/staff = $staff and $note/voice = $i + 1">
        <xsl:value-of select="($barId - 1) * $MAX_VOICES + $i + 1"/>
      </xsl:when>
      <xsl:otherwise>-1</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="Voice">
    <xsl:param name="i" select="0"/>
    <xsl:param name="arg1" select="0"/>
    <xsl:param name="arg2" select="0"/>
    <xsl:param name="arg3" select="0"/>

    <xsl:variable name="part" select="$arg1"/>
    <xsl:variable name="barId" select="$arg2"/>
    <xsl:variable name="staff" select="$arg3"/>
    <xsl:variable name="voiceNum" select="$i + 1"/>
        
    <xsl:if test="$part/note/voice = $voiceNum">
      <xsl:variable name="voiceId" select="($barId - 1) * $MAX_VOICES + $voiceNum"/>
      <Voice id="{$voiceId}">
        <Beats>
          <xsl:for-each select="$part/note[staff = $staff and voice = $voiceNum and not(chord)]">
            <xsl:if test="position() != 1">
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="@id"/>
          </xsl:for-each>
        </Beats>
      </Voice>
    </xsl:if>
  </xsl:template>

  <xsl:template name="LyricsLine">
    <xsl:param name="i" select="0"/>
    <xsl:param name="arg1" select="0"/>
    <xsl:variable name="note" select="$arg1"/>
    <Line><xsl:value-of select="$note/lyric[@number = $i + 1]/text"/></Line>
  </xsl:template>

  <xsl:template name="ChordName">
    <xsl:param name="harmony" select="."/>
    <xsl:value-of select="$harmony/root/root-step"/>
    <xsl:choose>
      <xsl:when test="$harmony/root/root-alter = 1">#</xsl:when>
      <xsl:when test="$harmony/root/root-alter = -1">b</xsl:when>
    </xsl:choose>
    <xsl:value-of select="$harmony/kind/@text"/>
  </xsl:template>
    
  <xsl:template name="Clef">
    <xsl:param name="clef" select="." />
    
    <xsl:choose>
      <xsl:when test="$clef/sign = 'G'">G2</xsl:when>
      <xsl:when test="$clef/sign = 'F'">F4</xsl:when>
      <xsl:when test="$clef/sign = 'C'">C3</xsl:when>
      <xsl:when test="$clef/sign = 'percussion' or $clef/sign = 'none'">Neutral</xsl:when>
      <xsl:when test="$clef/sign = 'TAB'">G2</xsl:when>
      <xsl:otherwise>G2</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="score-timewise">
    <GPIF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="gpif.xsd">
      <Score>
        <Title><xsl:value-of select="movement-title"/></Title>
        <Artist><xsl:value-of select="identification/creator[@type = 'artist']"/></Artist>
        <Album><xsl:value-of select="work/work-title"/></Album>
        <Words><xsl:value-of select="identification/creator[@type = 'poet']"/></Words>
        <Music><xsl:value-of select="identification/creator[@type = 'composer']"/></Music>
        <Copyright><xsl:value-of select="identification/rights"/></Copyright>
        <Tabber><xsl:value-of select="identification/creator[@type = 'tabber']"/></Tabber>
        <FirstPageHeader><xsl:value-of select="credit[@page = 1]/credit-words[@valign = 'top']"/></FirstPageHeader>
        <FirstPageFooter><xsl:value-of select="credit[@page = 1]/credit-words[@valign = 'bottom']"/></FirstPageFooter>
        <PageHeader><xsl:value-of select="credit[not(@page)]/credit-words[@valign = 'top']"/></PageHeader>
        <PageFooter><xsl:value-of select="credit[not(@page)]/credit-words[@valign = 'bottom']"/></PageFooter>
      </Score>
      <MasterTrack>
        <xsl:variable name="tempo" select="measure[1]/part[1]/direction/sound/@tempo"/>
        <Automations>
          <Automation>
            <Type>Tempo</Type>
            <Linear>false</Linear>
            <Bar>0</Bar>
            <Position>0</Position>
            <Text></Text>
            <Visible>true</Visible>
            <Value>
              <xsl:choose>
                <xsl:when test="$tempo"><xsl:value-of select="$tempo"/></xsl:when>
                <xsl:otherwise>120</xsl:otherwise>
              </xsl:choose>
            </Value>
          </Automation>
        </Automations>
        <Tracks>
          <xsl:call-template name="Range1">
            <xsl:with-param name="total" select="$tracks"/>
          </xsl:call-template>
        </Tracks>
      </MasterTrack>
      <Tracks>
        <xsl:for-each select="part-list/score-part">
          <xsl:variable name="part" select="."/>
          <xsl:variable name="attributes" select="/score-timewise/measure[1]/part[@id = $part/@id]/attributes"/>
          <Track id="{position()}">
            <Name><xsl:value-of select="part-name"/></Name>
            <ShortName><xsl:value-of select="part-abbreviation"/></ShortName>
            <Color>0 0 0</Color>
            <PlayingStyle>Default</PlayingStyle>
            <GeneralMidi>
              <xsl:variable name="midiChannel" select="midi-instrument/midi-channel" />
              <xsl:attribute name="table">
                <xsl:choose>
                  <xsl:when test="$midiChannel and $midiChannel = 10">Percussion</xsl:when>
                  <xsl:otherwise>Instrument</xsl:otherwise>
				</xsl:choose>
			  </xsl:attribute>
              <Program>
                <xsl:choose>
                  <xsl:when test="midi-instrument/midi-program">
                    <xsl:value-of select="midi-instrument/midi-program - 1"/>
                  </xsl:when>
                  <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
              </Program>
              <Port>0</Port>
              <PrimaryChannel>
                <xsl:choose>
                  <xsl:when test="$midiChannel">
                    <xsl:value-of select="$midiChannel - 1"/>
                  </xsl:when>
                  <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
              </PrimaryChannel>
              <SecondaryChannel>0</SecondaryChannel>
            </GeneralMidi>
            <ChannelStrip>
              <Volume>
                <xsl:choose>
                  <xsl:when test="midi-instrument/volume">
                    <xsl:value-of select="round(midi-instrument/volume * 255 div 100)"/>
                  </xsl:when>
                  <!-- 70% volume is default -->
                  <xsl:otherwise>180</xsl:otherwise>
                </xsl:choose>
              </Volume>
              <Pan>
                <xsl:choose>
                  <xsl:when test="midi-instrument/pan">
                    <xsl:value-of select="round((midi-instrument/pan + 90) * 255 div 180)"/>
                  </xsl:when>
                  <xsl:otherwise>128</xsl:otherwise>
                </xsl:choose>
              </Pan>
            </ChannelStrip>
            <PlaybackState>Default</PlaybackState>
            <xsl:variable name="staff" select="$attributes/staff-details[staff-tuning]"/>
            <xsl:variable name="capo" select="$attributes/staff-details/capo"/>
            <xsl:variable name="chords" select="/score-timewise/measure/part[@id = $part/@id]/harmony"/>
            <xsl:if test="$staff or $capo or $chords">
              <Properties>
                <xsl:if test="$staff">
                  <Property name="Tuning">
                    <Pitches>
                      <xsl:for-each select="$staff/staff-tuning">
                        <xsl:sort select="@line" data-type="number" order="ascending"/>
                        <xsl:if test="position() != 1">
                          <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:call-template name="Pitch">
                          <xsl:with-param name="step" select="tuning-step"/>
                          <xsl:with-param name="octave" select="tuning-octave"/>
                          <xsl:with-param name="alter" select="tuning-alter"/>
                        </xsl:call-template>
                      </xsl:for-each>
                    </Pitches>
                  </Property>
                </xsl:if>
                <xsl:if test="$capo">
                  <Property name="CapoFret">
                    <Fret><xsl:value-of select="$capo" /></Fret>
				  </Property>
				</xsl:if>
                <!--xsl:if test="$chords">
                  <Property name="ChordCollection">
                    <Chords>
                      <xsl:for-each select="$chords">
                        <xsl:variable name="spanLimit">
                          <xsl:choose>
                            <xsl:when test="frame/frame-frets">
                              <xsl:value-of select="frame/frame-frets"/>
                            </xsl:when>
                            <xsl:otherwise>5</xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="strings">
                          <xsl:choose>
                            <xsl:when test="frame/frame-strings">
                              <xsl:value-of select="frame/frame-strings"/>
                            </xsl:when>
                            <xsl:otherwise>6</xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="baseFret">
                          <xsl:choose>
                            <xsl:when test="frame/first-fret">
                              <xsl:value-of select="frame/first-fret - 1"/>
                            </xsl:when>
                            <xsl:otherwise>0</xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <Chord baseFret="{$baseFret}" spanLimit="{$spanLimit}">
                          <xsl:attribute name="name">
                            <xsl:call-template name="ChordName"/>
                          </xsl:attribute>
                          <xsl:attribute name="barsStates">
                            <xsl:call-template name="RepeatString">
                              <xsl:with-param name="str" select="0"/>
                              <xsl:with-param name="delim" select="' '"/>
                              <xsl:with-param name="repeat" select="$spanLimit"/>
                            </xsl:call-template>
                          </xsl:attribute>
                          <xsl:attribute name="frets">
                            <xsl:call-template name="Iterate">
                              <xsl:with-param name="arg1" select="frame"/>
                              <xsl:with-param name="arg2" select="$baseFret"/>
                              <xsl:with-param name="total" select="$strings"/>
                              <xsl:with-param name="template" select="'ChordFret'"/>
                            </xsl:call-template>
                          </xsl:attribute>
                        </Chord>
                      </xsl:for-each>
                    </Chords>
                  </Property>
                </xsl:if-->
              </Properties>
            </xsl:if>
          </Track>
        </xsl:for-each>
      </Tracks>
      <!-- MasterBars definition -->
      <xsl:variable name="firstMeasure" select="measure[1]" />
      <xsl:variable name="staffCount" select="count($firstMeasure//clef)" />
      <MasterBars>
        <xsl:for-each select="measure">
          <xsl:variable name="measurePosition" select="position()"/>  
          <MasterBar>
            <xsl:variable name="key" select="((. | preceding-sibling::measure)/part[1]/attributes/key)[last()]"/>
            <Key>
              <xsl:choose>
                <xsl:when test="$key">
                  <AccidentalCount><xsl:value-of select="$key/fifths"/></AccidentalCount>
                  <Mode>
                    <xsl:choose>
                      <xsl:when test="$key/mode = 'minor'">Minor</xsl:when>
                      <xsl:otherwise>Major</xsl:otherwise>
                    </xsl:choose>
                  </Mode>
                </xsl:when>
                <xsl:otherwise>
                  <AccidentalCount>0</AccidentalCount>
                  <Mode>Major</Mode>
                </xsl:otherwise>
              </xsl:choose>
            </Key>
            <xsl:variable name="time" select="((. | preceding-sibling::measure)/part[1]/attributes/time)[last()]"/>
            <Time>
              <xsl:choose>
                <xsl:when test="$time">
                  <xsl:value-of select="$time/beats"/>/<xsl:value-of select="$time/beat-type"/>
                </xsl:when>
                <xsl:otherwise>4/4</xsl:otherwise>
              </xsl:choose>
            </Time>
            <xsl:variable name="repeatEnd" select="part[1]/barline/repeat[@direction = 'backward']"/>
            <Repeat end="{boolean($repeatEnd)}" start="{boolean(part[1]/barline/repeat[@direction = 'forward'])}">
              <xsl:attribute name="count">
                <xsl:choose>
                  <xsl:when test="$repeatEnd/@times">
                    <xsl:value-of select="$repeatEnd/@times"/>
                  </xsl:when>
                  <xsl:when test="$repeatEnd">2</xsl:when>
                  <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </Repeat>
            <xsl:choose>
              <xsl:when test="part[1]/barline/bar-style = 'light-light'">
                <DoubleBar/>
              </xsl:when>
              <xsl:when test="part[1]/barline/bar-style = 'dashed'">
                <FreeTime/>
              </xsl:when>
			</xsl:choose>
            <xsl:variable name="ending" select="part[1]/barline/ending[@type != 'stop']"/>
            <xsl:if test="$ending">
              <AlternateEndings>
                <xsl:value-of select="translate($ending/@number, ',', ' ')"/>
              </AlternateEndings>
            </xsl:if>
            <xsl:variable name="sounds" select="part[1]/direction/sound"/>
            <xsl:if test="$sounds[@dacapo or @segno or @dalsegno or @coda or @tocoda]">
              <Directions>
                <xsl:if test="$sounds[@segno]">
                  <Target>Segno</Target>
                </xsl:if>
                <xsl:if test="$sounds[@coda]">
                  <Target>Coda</Target>
                </xsl:if>
                <xsl:if test="$sounds[@dacapo]">
                  <Jump>DaCapo</Jump>
                </xsl:if>
                <xsl:if test="$sounds[@dalsegno]">
                  <Jump>DaSegno</Jump>
                </xsl:if>
                <xsl:if test="$sounds[@tocoda]">
                  <Jump>DaCoda</Jump>
                </xsl:if>
              </Directions>
            </xsl:if>
            <!-- Bar list -->
            <Bars>
              <xsl:for-each select="$firstMeasure//clef">
                <xsl:variable name="barId" select="($measurePosition - 1) * $staffCount + position()"/>
                <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
                <xsl:value-of select="$barId"/>
              </xsl:for-each>
            </Bars>
          </MasterBar>
        </xsl:for-each>
      </MasterBars>
      <!-- Bars definition -->
      <Bars>
        <xsl:for-each select="measure">
          <xsl:variable name="measure" select="." />
          <xsl:variable name="measureNumber" select="@number" />
          <xsl:variable name="measurePosition" select="position()" />
          <xsl:for-each select="$firstMeasure//clef"> 
            <xsl:variable name="partId" select="../../@id" />
            <xsl:variable name="part" select="$measure/part[@id = $partId]" />
            <xsl:variable name="barId" select="($measurePosition - 1) * $staffCount + position()"/>
            <xsl:variable name="clefNumber" select="@number" />
            <Bar id="{$barId}">
              <!--Clef -->
              <Clef>  
                <xsl:variable name="clef" select="$part/attributes/clef[@number = $clefNumber]" />
                <xsl:choose>
                  <xsl:when test="$clef">
                    <xsl:call-template name="Clef">
                       <xsl:with-param name="clef" select="$clef" />
                    </xsl:call-template>
				  </xsl:when>
                  <xsl:otherwise>
                    <xsl:variable name="prevClef" select="//clef[../../../@number &lt; $measureNumber and ../../@id = $partId and @number = $clefNumber][last()]" />
                    <xsl:call-template name="Clef">
                       <xsl:with-param name="clef" select="$prevClef" />
                    </xsl:call-template>
				  </xsl:otherwise>
				</xsl:choose>
              </Clef>
              <!-- Voices -->
              <Voices>
                <xsl:call-template name="Iterate">
                  <xsl:with-param name="template" select="'VoiceIndex'"/>
                  <xsl:with-param name="total" select="$MAX_VOICES"/>
                  <xsl:with-param name="arg1" select="$part"/>
                  <xsl:with-param name="arg2" select="$barId"/>
                  <xsl:with-param name="arg3" select="$clefNumber"/>
                </xsl:call-template>
              </Voices>
            </Bar>
          </xsl:for-each>
        </xsl:for-each>
      </Bars>
        
      <Voices>
        <xsl:for-each select="measure">
          <xsl:variable name="measure" select="." />
          <xsl:variable name="measurePosition" select="position()" />
          <xsl:for-each select="$firstMeasure//clef"> 
            <xsl:variable name="partId" select="../../@id" />
            <xsl:variable name="part" select="$measure/part[@id = $partId]" />
            <xsl:variable name="barId" select="($measurePosition - 1) * $staffCount + position()"/>
            <xsl:variable name="clefNumber" select="@number" />
            <xsl:call-template name="Iterate">
              <xsl:with-param name="template" select="'Voice'"/>
              <xsl:with-param name="total" select="$MAX_VOICES"/>
              <xsl:with-param name="arg1" select="$part"/>
              <xsl:with-param name="arg2" select="$barId"/>
              <xsl:with-param name="arg3" select="$clefNumber"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:for-each>
      </Voices>
        
      <Beats>
        <xsl:for-each select="measure/part/note[not(chord)]">
          <Beat id="{@id}">
            <Rhythm ref="{@id}"/>
            <xsl:variable name="dynamics" select="notations/dynamics"/>
            <xsl:if test="$dynamics">
              <Dynamic>
                <xsl:choose>
                  <xsl:when test="$dynamics = ppp">PPP</xsl:when>  
                  <xsl:when test="$dynamics = pp">PP</xsl:when>
                  <xsl:when test="$dynamics = p">P</xsl:when>
                  <xsl:when test="$dynamics = mp">MP</xsl:when>
                  <xsl:when test="$dynamics = mf">MF</xsl:when>
                  <xsl:when test="$dynamics = f">F</xsl:when>
                  <xsl:when test="$dynamics = ff">FF</xsl:when>
                  <xsl:when test="$dynamics = fff">FFF</xsl:when>
                  <xsl:otherwise>MF</xsl:otherwise>
				</xsl:choose>  
			  </Dynamic>
            </xsl:if>
            <xsl:variable name="tremolo" select="notations/ornaments/tremolo[@type = 'single']"/>
            <xsl:if test="$tremolo">
              <Tremolo>
                <xsl:choose>
                  <xsl:when test="$tremolo = 1">1/2</xsl:when>
                  <xsl:when test="$tremolo = 2">1/4</xsl:when>
                  <xsl:otherwise>1/8</xsl:otherwise>
                </xsl:choose>
              </Tremolo>
            </xsl:if>
            <xsl:if test="grace">
              <GraceNotes>BeforeBeat</GraceNotes>
			</xsl:if>
            <!--xsl:choose>
              <xsl:when test="notations/slur">
                <Legato origin="{boolean(notations/slur/@type = 'start')}" destination="{boolean(notations/slur/@type = 'stop')}"/>
			  </xsl:when> 
              <xsl:otherwise>
                <xsl:variable name="voice" select="voice" />
                <xsl:variable name="staff" select="staff" />
                <xsl:variable name="partId" select="../@id" />
                <xsl:variable name="prevBeat" select="../../preceding-sibling::measure//note[not(chord) and (voice = $voice) and (staff = $staff) and ../@id = $partId and notations/slur][1]"/>
                <xsl:variable name="nextBeat" select="../../following-sibling::measure//note[not(chord) and (voice = $voice) and (staff = $staff) and ../@id = $partId and notations/slur][1]"/>                
                <xsl:if test="$prevBeat or $nextBeat">
                  <xsl:variable name="nextSlur" select="$nextBeat/notations/slur[1]" />
                  <xsl:variable name="prevSlur" select="$prevBeat/notations/slur[last()]" />
                  <debug-legato>
                    <xsl:value-of select="$prevSlur/@type" /> - <xsl:value-of select="$nextSlur/@type" />  
				  </debug-legato>
                  <Legato origin="{boolean(($nextSlur/@type = 'stop') or ($nextSlur/@type = 'continue'))}"
                          destination="{boolean(($prevSlur/@type = 'start') or ($prevSlur/@type = 'continue'))}" />
                </xsl:if>
			  </xsl:otherwise>
			</xsl:choose-->
            <xsl:variable name="arpeggiate" select="notations/arpeggiate"/>
            <xsl:if test="$arpeggiate">
              <Arpeggio>
                <xsl:choose>
                  <xsl:when test="$arpeggiate/@direction = 'uo'">Up</xsl:when>
                  <xsl:otherwise>Down</xsl:otherwise>
                </xsl:choose>
              </Arpeggio>
            </xsl:if>
            <xsl:if test="not(rest)">
              <xsl:variable name="nextBeat" select="following-sibling::note[not(chord)]"/>
              <xsl:variable name="lastNoteId">
                <xsl:choose>
                  <xsl:when test="$nextBeat"><xsl:value-of select="$nextBeat/@id"/></xsl:when>
                  <xsl:otherwise>1000000</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <Notes>
                <xsl:value-of select="@id"/>                
                <xsl:for-each select="following-sibling::note[@id &lt; $lastNoteId]">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="@id"/>
                </xsl:for-each>
              </Notes>
            </xsl:if>
            <xsl:if test="lyric">
              <Lyrics>
                <xsl:call-template name="Iterate">
                  <xsl:with-param name="template" select="'LyricsLine'"/>
                  <xsl:with-param name="arg1" select="."/>
                  <xsl:with-param name="total" select="5"/>
                </xsl:call-template>
              </Lyrics>
            </xsl:if>            
            <xsl:variable name="harmony" select="preceding-sibling::*[1]"/>
            <xsl:variable name="harmonyExist" select="$harmony and name($harmony) = 'harmony'"/>
            <xsl:variable name="pickStroke" select="notations/technical[up-bow or down-bow]"/>
            <xsl:variable name="whammy" select="notations/technical/bend[with-bar]"/>
            <xsl:if test="$harmonyExist or $pickStroke or $whammy">
              <Properties>
                <!-- Chord -->
                <xsl:if test="$harmonyExist">
                  <Property name="Chord">
                    <Name>
                      <xsl:call-template name="ChordName">
                        <xsl:with-param name="harmony" select="$harmony"/>
                      </xsl:call-template>
                    </Name>
                  </Property>
                </xsl:if>
                <!-- PickStroke -->
                <xsl:if test="$pickStroke">
                  <Property name="PickStroke">
                    <Direction>
                      <xsl:choose>
                        <xsl:when test="notations/technical/up-bow">Up</xsl:when>
                        <xsl:otherwise>Down</xsl:otherwise>
                      </xsl:choose>
                    </Direction>
                  </Property>                    
                </xsl:if>
                <!-- WhammyBar -->
                <xsl:if test="$whammy">
                  <Property name="WhammyBar">
                    <Enable/>
                  </Property>
                  <xsl:variable name="whammyValue" select="number(translate($whammy/bend-alter, '-', ' ')) * 50"/>
                  <xsl:choose>
                    <!-- PreDive -->
                    <xsl:when test="$whammy/pre-bend">
                      <Property name="WhammyBarOriginValue">
                        <Float>-<xsl:value-of select="$whammyValue"/></Float>
                      </Property>
                      <Property name="WhammyBarMiddleValue">
                        <Float>-16</Float>
                      </Property>
                      <Property name="WhammyBarDestinationValue">
                        <Float>-<xsl:value-of select="$whammyValue"/></Float>
                      </Property>
                      <Property name="WhammyBarOriginOffset">
                        <Float>0</Float>
                      </Property>
                      <Property name="WhammyBarMiddleOffset1">
                        <Float>50</Float>
                      </Property>
                      <Property name="WhammyBarMiddleOffset2">
                        <Float>50</Float>
                      </Property>
                      <Property name="WhammyBarDestinationOffset">
                        <Float>100</Float>
                      </Property>
                    </xsl:when>
                    <!-- PreDiveNRelease -->
                    <xsl:when test="$whammy/release">
                      <Property name="WhammyBarOriginValue">
                        <Float>-<xsl:value-of select="$whammyValue"/></Float>
                      </Property>
                      <Property name="WhammyBarMiddleValue">
                        <Float>-16</Float>
                      </Property>
                      <Property name="WhammyBarDestinationValue">
                        <Float>0</Float>
                      </Property>
                      <Property name="WhammyBarOriginOffset">
                        <Float>0</Float>
                      </Property>
                      <Property name="WhammyBarMiddleOffset1">
                        <Float>25</Float>
                      </Property>
                      <Property name="WhammyBarMiddleOffset2">
                        <Float>25</Float>
                      </Property>
                      <Property name="WhammyBarDestinationOffset">
                        <Float>50</Float>
                      </Property>
                    </xsl:when>
                    <!-- Dive -->
                    <xsl:otherwise>
                      <Property name="WhammyBarOriginValue">
                        <Float>0</Float>
                      </Property>
                      <Property name="WhammyBarMiddleValue">
                        <Float>-16</Float>
                      </Property>
                      <Property name="WhammyBarDestinationValue">
                        <Float>-<xsl:value-of select="$whammyValue"/></Float>
                      </Property>
                      <Property name="WhammyBarOriginOffset">
                        <Float>0</Float>
                      </Property>
                      <Property name="WhammyBarMiddleOffset1">
                        <Float>35</Float>
                      </Property>
                      <Property name="WhammyBarMiddleOffset2">
                        <Float>35</Float>
                      </Property>
                      <Property name="WhammyBarDestinationOffset">
                        <Float>75</Float>
                      </Property>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
              </Properties>
            </xsl:if>
          </Beat>
        </xsl:for-each>
      </Beats>
      <Notes>        
        <xsl:for-each select="measure/part/note[not(rest)]">
          <xsl:variable name="part" select=".."/>
          <Note id="{@id}">
            <xsl:variable name="articulations" select="notations/articulations" />
            <xsl:choose>
              <xsl:when test="$articulations/staccato and $articulations/accent">
                <Accent>9</Accent>
			  </xsl:when> 
              <xsl:when test="$articulations/staccato and $articulations/strong-accent">
                <Accent>5</Accent>
			  </xsl:when>
              <xsl:when test="$articulations/staccato">
                <Accent>1</Accent>
              </xsl:when>
              <xsl:when test="$articulations/accent">
                <Accent>8</Accent>
              </xsl:when>
              <xsl:when test="$articulations/strong-accent">
                <Accent>4</Accent>
              </xsl:when>
			</xsl:choose>
            <xsl:if test="notations/technical/fingering">
              <LeftFingering>
                <xsl:value-of select="translate(notations/technical/fingering, '51234', 'PIMAC')"/>
              </LeftFingering>
            </xsl:if>
            <xsl:if test="notations/technical/pluck">
              <RightFingering>
                <xsl:value-of select="translate(notations/technical/pluck, 'pimac', 'PIMAC')"/>
              </RightFingering>
            </xsl:if>
            <xsl:if test="tie">
              <Tie origin="{boolean(tie/@type = 'start')}" destination="{boolean(tie/@type = 'stop')}"/>
            </xsl:if>
            <xsl:if test="notations/ornaments/trill-mark">
              <Trill>0</Trill>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="notations/ornaments/turn">
                <Ornament>Turn</Ornament>
              </xsl:when>    
              <xsl:when test="notations/ornaments/inverted-turn">
                <Ornament>InvertedTurn</Ornament>
              </xsl:when>   
              <xsl:when test="notations/ornaments/mordent">
                <Ornament>LowerMordent</Ornament>
              </xsl:when>
              <xsl:when test="notations/ornaments/inverted-mordent">
                <Ornament>UpperMordent</Ornament>
              </xsl:when>
			</xsl:choose>
            <Properties>
              <xsl:if test="notations/technical/string">
                <xsl:variable name="strings" select="/score-timewise/measure[1]/part[@id = $part/@id]/attributes/staff-details/staff-lines"/>
                <Property name="String">
                  <String><xsl:value-of select="$strings - notations/technical/string"/></String>
                </Property>
              </xsl:if>
              <xsl:if test="notations/technical/fret">
                <Property name="Fret">
                  <Fret><xsl:value-of select="notations/technical/fret"/></Fret>
                </Property>
              </xsl:if>
              <xsl:if test="pitch/step">
                <Property name="Tone">
                  <Step>
                    <xsl:call-template name="StepPitch">
                      <xsl:with-param name="step" select="pitch/step"/>
                      <xsl:with-param name="alter" select="pitch/alter"/>
                    </xsl:call-template>
                  </Step>
                </Property>
              </xsl:if>
              <xsl:if test="pitch/octave">
                <Property name="Octave">
                  <Number>
                    <xsl:value-of select="pitch/octave + 1"/>
                  </Number>
                </Property>
              </xsl:if>
              <xsl:if test="@pizzicato">
                <Property name="PalmMuted"><Enable/></Property>
              </xsl:if>
              <xsl:if test="notations/technical/snap-pizzicato">
                <Property name="Slapped"><Enable/></Property>
              </xsl:if>
              <xsl:if test="notations/technical/tap">
                <Property name="Tapped"><Enable/></Property>
              </xsl:if>
              <xsl:if test="notations/technical/stopped">
                <Property name="Muted"><Enable/></Property>
              </xsl:if>
              <xsl:if test="notations/technical/hammer-on[@type = 'start'] or notations/technical/pull-off[@type = 'start']">
                <Property name="HopoOrigin"><Enable /></Property>
              </xsl:if>
              <xsl:if test="notations/technical/hammer-on[@type = 'stop'] or notations/technical/pull-off[@type = 'stop']">
                <Property name="HopoDestination"><Enable /></Property>
              </xsl:if>
              <xsl:variable name="bend" select="notations/technical/bend[not(with-bar)]"/>
              <xsl:if test="$bend">
                <Property name="Bended">
                  <Enable/>
                </Property>
                <xsl:variable name="bendValue" select="number(translate($bend/bend-alter, '-', ' ')) * 50"/>
                <xsl:choose>
                  <!-- PreBend -->
                  <xsl:when test="$bend/pre-bend">
                    <Property name="BendOriginValue">
                      <Float><xsl:value-of select="$bendValue"/></Float>
                    </Property>
                    <Property name="BendMiddleValue">
                      <Float>-1</Float>
                    </Property>
                    <Property name="BendDestinationValue">
                      <Float><xsl:value-of select="$bendValue"/></Float>
                    </Property>
                    <Property name="BendOriginOffset">
                      <Float>0</Float>
                    </Property>
                    <Property name="BendMiddleOffset1">
                      <Float>50</Float>
                    </Property>
                    <Property name="BendMiddleOffset2">
                      <Float>50</Float>
                    </Property>
                    <Property name="BendDestinationOffset">
                      <Float>100</Float>
                    </Property>
                  </xsl:when>
                  <!-- PreBendNRelease -->
                  <xsl:when test="$bend/release">
                    <Property name="BendOriginValue">
                      <Float><xsl:value-of select="$bendValue"/></Float>
                    </Property>
                    <Property name="BendMiddleValue">
                      <Float>-1</Float>
                    </Property>
                    <Property name="BendDestinationValue">
                      <Float><xsl:value-of select="$bendValue"/></Float>
                    </Property>
                    <Property name="BendOriginOffset">
                      <Float>0</Float>
                    </Property>
                    <Property name="BendMiddleOffset1">
                      <Float>12</Float>
                    </Property>
                    <Property name="BendMiddleOffset2">
                      <Float>12</Float>
                    </Property>
                    <Property name="BendDestinationOffset">
                      <Float>25</Float>
                    </Property>
                  </xsl:when>
                  <!-- Bend -->
                  <xsl:otherwise>
                    <Property name="BendOriginValue">
                      <Float>0</Float>
                    </Property>
                    <Property name="BendMiddleValue">
                      <Float>-1</Float>
                    </Property>
                    <Property name="BendDestinationValue">
                      <Float><xsl:value-of select="$bendValue" /></Float>
                    </Property>
                    <Property name="BendOriginOffset">
                      <Float>0</Float>
                    </Property>
                    <Property name="BendMiddleOffset1">
                      <Float>12</Float>
                    </Property>
                    <Property name="BendMiddleOffset2">
                      <Float>12</Float>
                    </Property>
                    <Property name="BendDestinationOffset">
                      <Float>25</Float>
                    </Property>
                  </xsl:otherwise>
                </xsl:choose>                
              </xsl:if>
              <xsl:if test="notations/technical/harmonic">
                <Property name="HarmonicType">
                  <HType>
                    <xsl:choose>
                      <xsl:when test="notations/technical/harmonic/artificial">Artificial</xsl:when>
                      <xsl:otherwise>Natural</xsl:otherwise>
                    </xsl:choose>
                  </HType>
                </Property>
                <Property name="HarmonicType">
                  <HFret>12</HFret>
				</Property>
              </xsl:if>
              <xsl:if test="notations/slide[@type = 'start']">
                <Property name="Slide"><Flags>1</Flags></Property>
              </xsl:if>
            </Properties>
          </Note>
        </xsl:for-each>
      </Notes>
      <Rhythms>
        <xsl:for-each select="measure/part/note">
          <xsl:variable name="part" select=".."/>
          <Rhythm id="{@id}">
            <xsl:choose>
              <xsl:when test="type">
                <NoteValue>
                  <xsl:choose>
                    <xsl:when test="type = 'breve'">DoubleWhole</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="translate(substring(type, 1, 1), 'lwhqe', 'LWHQE')"/>
                      <xsl:value-of select="substring(type, 2)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </NoteValue>
                <AugmentationDot count="{count(dot)}"/>
                <xsl:if test="time-modification">
                  <PrimaryTuplet den="{time-modification/normal-notes}" num="{time-modification/actual-notes}"/>
                </xsl:if>
              </xsl:when>
              <!-- @todo calculate rhythm from duration -->              
              <xsl:otherwise>
                <xsl:variable name="divisions" select="/score-timewise/measure[1]/part[@id = $part/@id]/attributes/divisions"/>
                <NoteValue>Whole</NoteValue>
              </xsl:otherwise>
            </xsl:choose>
          </Rhythm>
        </xsl:for-each>
      </Rhythms>
    </GPIF>
  </xsl:template>
</xsl:stylesheet>
