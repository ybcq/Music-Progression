<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="scoreType" select="'guitar'"/>

  <xsl:output method="xml" cdata-section-elements="Title Artist Album Words Music Copyright Tabber Instructions Name ShortName"/>
  
  <xsl:variable name="MAX_SCORE_BARS" select="100000"/>
  <xsl:variable name="EMPTY_BAR_ID" select="$MAX_SCORE_BARS"/>
  <xsl:variable name="MAX_VOICES" select="4"/>
  <xsl:variable name="MAX_POSITIONS" select="256"/>
  <xsl:variable name="MAX_BEAT_NOTES" select="16"/>
  <xsl:variable name="score" select="/powertab/score[@type = $scoreType]"/>

  <xsl:template name="Range">
    <xsl:param name="i" select="0"/>
    <xsl:param name="total" select="1"/>
    <xsl:if test="$i &lt; $total">
      <xsl:if test="$i != 0"><xsl:text> </xsl:text></xsl:if>
      <xsl:value-of select="$i"/>
      <xsl:call-template name="Range">
        <xsl:with-param name="i" select="$i + 1"/>
        <xsl:with-param name="total" select="$total"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="ChordName">
    <xsl:choose>
      <xsl:when test="chordname/TonicKey = 0">C</xsl:when>
      <xsl:when test="chordname/TonicKey = 1">C#</xsl:when>
      <xsl:when test="chordname/TonicKey = 2">D</xsl:when>
      <xsl:when test="chordname/TonicKey = 3">Eb</xsl:when>
      <xsl:when test="chordname/TonicKey = 4">E</xsl:when>
      <xsl:when test="chordname/TonicKey = 5">F</xsl:when>
      <xsl:when test="chordname/TonicKey = 6">F#</xsl:when>
      <xsl:when test="chordname/TonicKey = 7">G</xsl:when>
      <xsl:when test="chordname/TonicKey = 8">Ab</xsl:when>
      <xsl:when test="chordname/TonicKey = 9">A</xsl:when>
      <xsl:when test="chordname/TonicKey = 10">Bb</xsl:when>
      <xsl:when test="chordname/TonicKey = 11">B</xsl:when>
    </xsl:choose>
    <xsl:value-of select="chordname/FormulaText"/>
  </xsl:template>
  
  <xsl:template name="Tracks">
    <xsl:param name="i" select="0"/>
    <xsl:if test="systems/system/staffs/staff[@id = $i]">
      <xsl:variable name="trackId" select="$i"/>
      <Track id="{$trackId}">
        <xsl:variable name="guitarIn" select="guitarins/guitarin[Staff = $i][1]"/>
        <xsl:variable name="guitar" select="guitars/guitar[@id = $guitarIn/StaffGuitars - 1 or @id = 0][last()]"/>
        <Name><xsl:value-of select="$guitar/Description"/></Name>
        <Color>0 0 0</Color>
        <PlayingStyle>Default</PlayingStyle>
        <GeneralMidi table="Instrument">
          <Program><xsl:value-of select="$guitar/Preset"/></Program>
          <Port>0</Port>
          <PrimaryChannel><xsl:value-of select="$trackId * 2"/></PrimaryChannel>
          <SecondaryChannel><xsl:value-of select="$trackId * 2 + 1"/></SecondaryChannel>
        </GeneralMidi>
        <ChannelStrip>
          <Volume><xsl:value-of select="floor($guitar/InitialVolume * 255 div 104)"/></Volume>
          <Pan><xsl:value-of select="$guitar/Pan * 2"/></Pan>
        </ChannelStrip>
        <PlaybackState>Default</PlaybackState>
        <Properties>
          <Property name="Tuning">
            <Pitches>
              <xsl:for-each select="$guitar/tuning/notes/Note">
                <xsl:sort select="@id" data-type="number" order="descending"/>
                <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
                <xsl:value-of select="."/>
              </xsl:for-each>
            </Pitches>
          </Property>
          <Property name="CapoFret">
            <Fret><xsl:value-of select="$guitar/Capo"/></Fret>
  		  </Property>
          <!--Property name="ChordCollection">
            <Items>
              <xsl:for-each select="chorddiagrams/chorddiagram">
                <Item spanLimit="5" barsStates="0 0 0 0 0">
                  <xsl:attribute name="name">
                    <xsl:call-template name="ChordName"/>
                  </xsl:attribute>
                  <xsl:variable name="baseFret">
                    <xsl:choose>
                      <xsl:when test="TopFret = 0">0</xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="TopFret - 1"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:attribute name="baseFret"><xsl:value-of select="$baseFret"/></xsl:attribute>
                  <xsl:attribute name="frets">
                    <xsl:for-each select="fretnumbers/FretNumber">
                      <xsl:sort select="@id" data-type="number" order="descending"/>
                      <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
                      <xsl:choose>
                        <xsl:when test=". = 254">-1</xsl:when>
                        <xsl:when test=". &gt; 0"><xsl:value-of select=". - $baseFret"/></xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:attribute>
                </Item>
              </xsl:for-each>
            </Items>
          </Property-->
        </Properties>
      </Track>      
      
      <xsl:call-template name="Tracks">
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="CountTracks">
    <xsl:param name="i" select="0"/>
    <xsl:choose>
      <xsl:when test="$score/systems/system/staffs/staff[@id = $i]">
        <xsl:call-template name="CountTracks">
          <xsl:with-param name="i" select="$i + 1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$i"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:variable name="trackCount">
    <xsl:call-template name="CountTracks"/>
  </xsl:variable>

  <xsl:template name="RepeatString">
    <xsl:param name="repeat" select="1"/>
    <xsl:param name="str"/>
    <xsl:param name="delim" select="''"/>
    <xsl:if test="$repeat &gt; 0">
      <xsl:value-of select="$str"/>
      <xsl:if test="$repeat != 1"><xsl:value-of select="$delim"/></xsl:if>
      <xsl:call-template name="RepeatString">
        <xsl:with-param name="repeat" select="$repeat - 1"/>
        <xsl:with-param name="str" select="$str"/>
        <xsl:with-param name="delim" select="$delim"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="BarIndexes">
    <xsl:param name="barline"/>
    <xsl:param name="barlineId" select="0"/>
    
    <!-- staff bars -->
    <xsl:for-each select="$barline/../../staffs/staff">
      <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
      <xsl:value-of select="$barlineId * $trackCount + position() - 1"/>
    </xsl:for-each>
    <!-- empty bars for systems, which have less staffs than tracks -->
    <xsl:call-template name="RepeatString">
      <xsl:with-param name="str" select="concat(' ', $EMPTY_BAR_ID)"/>
      <xsl:with-param name="repeat" select="$trackCount - count($barline/../../staffs/staff)"/>
    </xsl:call-template>        
  </xsl:template>
    
  <xsl:template match="powertab">
    <GPIF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="gpif.xsd">
      <Score>
        <Title><xsl:value-of select="header/song/SongTitle"/></Title>
        <Artist><xsl:value-of select="header/song/SongArtist"/></Artist>
        <Album><xsl:value-of select="header/song/release/audio/SongAudioReleaseTitle"/></Album>
        <Words><xsl:value-of select="header/song/author/SongLyricist"/></Words>
        <Music><xsl:value-of select="header/song/author/SongComposer"/></Music>
        <Copyright><xsl:value-of select="header/song/SongCopyright"/></Copyright>
        <Tabber>
          <xsl:value-of select="header/song/SongGuitarScoreTranscriber"/>
          <xsl:value-of select="header/song/SongBassScoreTranscriber"/>
        </Tabber>
        <Instructions>
          <xsl:value-of select="header/song/SongGuitarScoreNotes"/>
          <xsl:value-of select="header/song/SongBassScoreNotes"/>
        </Instructions>
      </Score>
      
      <MasterTrack>
        <xsl:variable name="trackTempoMarker" select="$score/tempomarkers/tempomarker[System = 0 and Position = 0][1]"/>
        <xsl:choose>
            <xsl:when test="$trackTempoMarker">
                <Automations>
                    <Automation>
                    <Type>Tempo</Type>
                    <Linear>false</Linear>
                    <Bar>0</Bar>
                    <Position>0</Position>
                    <Text><xsl:value-of select="$trackTempoMarker/Description"/></Text>
                    <Visible>true</Visible>
                    <xsl:choose>
                        <xsl:when test="($trackTempoMarker/BeatType &gt;= 0) and ($trackTempoMarker/BeatType &lt;= 4)">
                            <xsl:choose>
                            <xsl:when test="$trackTempoMarker/BeatType = 0"><Value><xsl:value-of select="$trackTempoMarker/BeatsPerMinute"/> 4</Value></xsl:when>
                            <xsl:when test="$trackTempoMarker/BeatType = 1"><Value><xsl:value-of select="$trackTempoMarker/BeatsPerMinute"/> 5</Value></xsl:when>
                            <xsl:when test="$trackTempoMarker/BeatType = 2"><Value><xsl:value-of select="$trackTempoMarker/BeatsPerMinute"/> 2</Value></xsl:when>
                            <xsl:when test="$trackTempoMarker/BeatType = 3"><Value><xsl:value-of select="$trackTempoMarker/BeatsPerMinute"/> 3</Value></xsl:when>
                            <xsl:when test="$trackTempoMarker/BeatType = 4"><Value><xsl:value-of select="$trackTempoMarker/BeatsPerMinute"/> 1</Value></xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="bpm" select="$trackTempoMarker/BeatsPerMinute"/>
                            <xsl:choose>
                            <xsl:when test="$trackTempoMarker/BeatType = 5"><Value><xsl:value-of select="$bpm div 2"/> 3</Value></xsl:when>
                            <xsl:when test="$trackTempoMarker/BeatType = 6"><Value><xsl:value-of select="$bpm div 2"/> 1</Value></xsl:when>
                            <xsl:when test="$trackTempoMarker/BeatType = 7"><Value><xsl:value-of select="$bpm div 4"/> 3</Value></xsl:when>
                            <xsl:when test="$trackTempoMarker/BeatType = 8"><Value><xsl:value-of select="$bpm div 4"/> 1</Value></xsl:when>
                            <xsl:when test="$trackTempoMarker/BeatType = 9"><Value><xsl:value-of select="$bpm div 8"/> 3</Value></xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    </Automation>
                </Automations>
            </xsl:when>
        </xsl:choose>
        <Tracks>
          <xsl:call-template name="Range">
            <xsl:with-param name="total" select="$trackCount"/>
          </xsl:call-template>
        </Tracks>
      </MasterTrack>
      
      <Tracks>
        <xsl:for-each select="$score">
          <xsl:call-template name="Tracks"/>
        </xsl:for-each>
      </Tracks>
      
      <MasterBars>
        <xsl:for-each select="$score/systems/system/barlines/barline">
          <xsl:variable name="barline" select="."/>
          <xsl:variable name="system" select="../.."/>
          <xsl:variable name="nextBarline" select="(following-sibling::barline | $system/barline[@type = 'end'])[1]"/>
          <MasterBar>
            <Key>
              <AccidentalCount>
                <xsl:choose>
                  <xsl:when test="keysignature/KeyAccidentals &lt; 8">
                    <xsl:value-of select="keysignature/KeyAccidentals"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="7 - keysignature/KeyAccidentals"/>
                  </xsl:otherwise>
                </xsl:choose>
              </AccidentalCount>
              <Mode>
                <xsl:choose>
                  <xsl:when test="keysignature/KeyType = 0">Major</xsl:when>
                  <xsl:otherwise>Minor</xsl:otherwise>
                </xsl:choose>
              </Mode>
            </Key>
            <Time>
              <xsl:value-of select="timesignature/BeatsPerMeasure"/>/<xsl:value-of select="timesignature/BeatAmount"/>
            </Time>
            <xsl:variable name="sectionLetter" select="rehearsalsign/Letter" />
            <xsl:if test="$sectionLetter != 127">
              <Section>
                  <Letter><!--xsl:value-of select="codepoints-to-string($sectionLetter)"/--></Letter>
                  <Text><xsl:value-of select="rehearsalsign/Description"/></Text>
			  </Section>
			</xsl:if>
            <xsl:variable name="repeatStart" select="Type = 3"/>
            <Repeat>
              <xsl:attribute name="count">
                <xsl:value-of select="$nextBarline/RepeatCount"/>
              </xsl:attribute>
              <xsl:attribute name="start">
                <xsl:value-of select="boolean(Type = 3)"/>
              </xsl:attribute>
              <xsl:attribute name="end">
                <xsl:value-of select="boolean($nextBarline/Type = 4)"/>
              </xsl:attribute>
            </Repeat>
            <xsl:choose>
              <xsl:when test="$nextBarline/Type = 1"><DoubleBar /></xsl:when>
              <xsl:when test="$nextBarline/Type = 2"><FreeTime /></xsl:when>
			</xsl:choose>
            <!-- alternate endings -->
            <xsl:variable name="alternateEnding" select="$score/alternateendings/alternateending[
                          (System = $system/@id) and (Position &gt;= $barline/Position) and (Position &lt; $nextBarline/Position)]"/>
            <xsl:if test="$alternateEnding">
              <AlternateEndings>
                <xsl:for-each select="$alternateEnding/Numbers/Number">
                  <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
                  <xsl:value-of select="."/>
                </xsl:for-each>
              </AlternateEndings>
            </xsl:if>
            <!-- directions -->
            <xsl:variable name="directions" select="$system/directions/direction[(Position &gt;= $barline/Position) and (Position &lt; $nextBarline/Position)]"/>
            <xsl:if test="$directions">
              <Directions>
                <xsl:variable name="target" select="$directions/symbols/symbol[symbolType &lt; 5][1]"/>
                <xsl:if test="$target">
                  <Target>
                    <xsl:choose>
                      <xsl:when test="$target/symbolType = 0">Coda</xsl:when>
                      <xsl:when test="$target/symbolType = 1">DoubleCoda</xsl:when>
                      <xsl:when test="$target/symbolType = 2">Segno</xsl:when>
                      <xsl:when test="$target/symbolType = 3">SegnoSegno</xsl:when>
                      <xsl:when test="$target/symbolType = 4">Fine</xsl:when>
                    </xsl:choose>
                  </Target>
                </xsl:if>
                <xsl:variable name="jump" select="$directions/symbols/symbol[symbolType &gt;= 5][1]"/>
                <xsl:if test="$jump">
                  <Jump>
                    <xsl:choose>
                      <xsl:when test="$jump/symbolType = 5">DaCapo</xsl:when>
                      <xsl:when test="$jump/symbolType = 6">DaSegno</xsl:when>
                      <xsl:when test="$jump/symbolType = 7">DaSegnoSegno</xsl:when>
                      <xsl:when test="$jump/symbolType = 8">DaCoda</xsl:when>
                      <xsl:when test="$jump/symbolType = 9">DaDoubleCoda</xsl:when>
                      <xsl:when test="$jump/symbolType = 10">DaCapoAlCoda</xsl:when>
                      <xsl:when test="$jump/symbolType = 11">DaCapoAlDoubleCoda</xsl:when>
                      <xsl:when test="$jump/symbolType = 12">DaSegnoAlCoda</xsl:when>
                      <xsl:when test="$jump/symbolType = 13">DaSegnoAlDoubleCoda</xsl:when>
                      <xsl:when test="$jump/symbolType = 14">DaSegnoSegnoAlCoda</xsl:when>
                      <xsl:when test="$jump/symbolType = 15">DaSegnoSegnoAlDoubleCoda</xsl:when>
                      <xsl:when test="$jump/symbolType = 16">DaCapoAlFine</xsl:when>
                      <xsl:when test="$jump/symbolType = 17">DaSegnoAlFine</xsl:when>
                      <xsl:when test="$jump/symbolType = 18">DaSegnoSegnoAlFine</xsl:when>
                    </xsl:choose>
                  </Jump>
                </xsl:if>
              </Directions>
            </xsl:if>
            <Bars>
              <xsl:call-template name="BarIndexes">
                <xsl:with-param name="barline" select="."/>
                <xsl:with-param name="barlineId" select="position() - 1"/>
              </xsl:call-template>
            </Bars>
          </MasterBar>
        </xsl:for-each>
      </MasterBars>
      
      <Bars>
        <xsl:for-each select="$score/systems/system/barlines/barline">
          <xsl:variable name="barline" select="."/>
          <xsl:variable name="system" select="../.."/>
          <xsl:variable name="nextBarline" select="(following-sibling::barline | $system/barline[@type = 'end'])[1]"/>
          <xsl:variable name="barlineId" select="position() - 1"/>
          <xsl:for-each select="$system/staffs/staff">
            <xsl:variable name="barId" select="$barlineId * $trackCount + position() - 1"/>
            <Bar id="{$barId}">
              <Clef>
                <xsl:choose>
                  <xsl:when test="$scoreType = 'guitar'">G2</xsl:when>
                  <xsl:otherwise>F4</xsl:otherwise>
                </xsl:choose>
              </Clef>
              <Voices>
                <xsl:variable name="voices" select="voices/voice[position[(Position &gt;= $barline/Position) and (Position &lt; $nextBarline/Position)]]"/>
                <xsl:for-each select="$voices">
                  <xsl:if test="position() &lt;= $MAX_VOICES">
                    <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
                    <xsl:value-of select="$barId * $MAX_VOICES + position() - 1"/>
                  </xsl:if>
                </xsl:for-each>
                <!-- empty voices -->
                <xsl:if test="count($voices) != 0"><xsl:text> </xsl:text></xsl:if>
                <xsl:call-template name="RepeatString">
                  <xsl:with-param name="str" select="'-1'"/>
                  <xsl:with-param name="delim" select="' '"/>
                  <xsl:with-param name="repeat" select="$MAX_VOICES - count($voices)"/>
                </xsl:call-template>
              </Voices>
            </Bar>
          </xsl:for-each>
        </xsl:for-each>

        <!-- empty bar -->
        <Bar id="{$EMPTY_BAR_ID}">
          <Clef>G2</Clef>
          <Voices>-1 -1 -1 -1</Voices>
        </Bar>
      </Bars>
      
      <Voices>
        <!-- master bars -->
        <xsl:for-each select="$score/systems/system/barlines/barline">
          <xsl:variable name="barline" select="."/>
          <xsl:variable name="system" select="../.."/>
          <xsl:variable name="nextBarline" select="(following-sibling::barline | $system/barline[@type = 'end'])[1]"/>
          <xsl:variable name="barlineId" select="position() - 1"/>
          <!-- tracks -->
          <xsl:for-each select="$system/staffs/staff">
            <xsl:variable name="barId" select="$barlineId * $trackCount + position() - 1"/>
            <!-- voices -->
            <xsl:variable name="voices" select="voices/voice[position[(Position &gt;= $barline/Position) and (Position &lt; $nextBarline/Position)]]"/>
            <xsl:for-each select="$voices">
              <xsl:if test="position() &lt;= $MAX_VOICES">
                <xsl:variable name="voiceId" select="$barId * $MAX_VOICES + position() - 1"/>                
                <Voice id="{$voiceId}">
                  <Beats>
                    <!-- beats -->
                    <xsl:for-each select="position[(Position &gt;= $barline/Position) and (Position &lt; $nextBarline/Position)]">
                      <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
                      <xsl:value-of select="$voiceId * $MAX_POSITIONS + position() - 1"/>
                    </xsl:for-each>
                  </Beats>
                </Voice>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
      </Voices>
      
      <Beats>
        <!-- master bars -->
        <xsl:for-each select="$score/systems/system/barlines/barline">
          <xsl:variable name="barline" select="."/>
          <xsl:variable name="system" select="../.."/>
          <xsl:variable name="nextBarline" select="(following-sibling::barline | $system/barline[@type = 'end'])[1]"/>
          <xsl:variable name="barlineId" select="position() - 1"/>
          <!-- tracks -->
          <xsl:for-each select="$system/staffs/staff">
            <xsl:variable name="barId" select="$barlineId * $trackCount + position() - 1"/>
            <xsl:variable name="staff" select="."/>
            <!-- voices -->
            <xsl:variable name="voices" select="voices/voice[position[(Position &gt;= $barline/Position) and (Position &lt; $nextBarline/Position)]]"/>
            <xsl:for-each select="$voices">
              <xsl:if test="position() &lt;= $MAX_VOICES">
                <xsl:variable name="voiceId" select="$barId * $MAX_VOICES + position() - 1"/>
                <!-- beats -->
                <xsl:for-each select="position[(Position &gt;= $barline/Position) and (Position &lt; $nextBarline/Position)]">
                  <xsl:variable name="beatId" select="$voiceId * $MAX_POSITIONS + position() - 1"/>
                  <xsl:variable name="position" select="."/>
                  <Beat id="{$beatId}">
                    <Rhythm ref="{RhythmId}"/>
                    <!-- dynamic -->
                    <xsl:variable name="dynamic" select="$score/dynamics/dynamic[
                                  (Staff = $staff/@id) and ((System &lt; $system/@id) or ((System = $system/@id) and (Position &lt;= $position/Position)))][last()]"/>
                    <xsl:if test="$dynamic">
                      <xsl:variable name="v" select="$dynamic/StaffVolume"/>
                      <Dynamic>
                        <xsl:choose>
                          <xsl:when test="$v = 104">FFF</xsl:when>
                          <xsl:when test="$v = 91">FF</xsl:when>
                          <xsl:when test="$v = 78">F</xsl:when>
                          <xsl:when test="$v = 65">MF</xsl:when>
                          <xsl:when test="$v = 52">MP</xsl:when>
                          <xsl:when test="$v = 39">P</xsl:when>
                          <xsl:when test="$v = 26">PP</xsl:when>
                          <xsl:when test="$v = 13">PPP</xsl:when>
                          <xsl:otherwise>PPPP</xsl:otherwise>
                        </xsl:choose>
                      </Dynamic>
                    </xsl:if>
                    <xsl:choose>
                      <xsl:when test="VolumeSwellStartVolume &lt; VolumeSwellEndVolume">
                        <Hairpin>Crescendo</Hairpin>
					  </xsl:when>
                      <xsl:when test="VolumeSwellStartVolume &gt; VolumeSwellEndVolume">
                        <Hairpin>Decrescendo</Hairpin>
					  </xsl:when>
					</xsl:choose>
                    <xsl:if test="TremoloPicking = 1">
                      <Tremolo>1/8</Tremolo>
                    </xsl:if>
                    <xsl:if test="ArpeggioUp = 1">
                      <Arpeggio>Down</Arpeggio>
                    </xsl:if>
                    <xsl:if test="ArpeggioDown = 1">
                      <Arpeggio>Up</Arpeggio>
                    </xsl:if>
                    <xsl:if test="Acciaccatura = 1" >
                        <GraceNotes>BeforeBeat</GraceNotes>
					</xsl:if>
                    <xsl:for-each select="$system/chordtexts/chordtext[Position = $position/Position]">
                        <Chord><xsl:call-template name="ChordName"/></Chord>
                    </xsl:for-each>
                    <xsl:if test="notes/note">
                      <Notes>
                        <xsl:for-each select="notes/note">
                          <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
                          <xsl:value-of select="$beatId * $MAX_BEAT_NOTES + position() - 1"/>
                        </xsl:for-each>
                      </Notes>
                    </xsl:if>
                    <Properties>
                      <!-- VibratoWTremBar -->
                      <xsl:choose>
                        <xsl:when test="Vibrato = 1">
                          <Property name="VibratoWTremBar">
                            <Strength>Slight</Strength>
                          </Property>
						</xsl:when>
                        <xsl:when test="WideVibrato = 1">
                          <Property name="VibratoWTremBar">
                            <Strength>Wide</Strength>
                          </Property>
						</xsl:when>
  					  </xsl:choose>
                      <!-- PickStroked -->
                      <xsl:if test="$position/PickStrokeDown = 1">
                        <Property name="PickStroke">
                          <Direction>Down</Direction>
                        </Property>
                      </xsl:if>
                      <xsl:if test="$position/PickStrokeUp = 1">
                        <Property name="PickStroke">
                          <Direction>Up</Direction>
                        </Property>
                      </xsl:if>
                      <!-- WhammyBar -->
                      <xsl:if test="$position/TremoloBarType">
                        <xsl:variable name="tremBarType" select="$position/TremoloBarType"/>
                        <xsl:variable name="tremBarPitch" select="$position/TremoloBarPitch * 25"/>
                        <xsl:choose>
                            <!-- Dip -->
                            <xsl:when test="$tremBarType = 0">
                                <Property name="WhammyBar"><Enable /></Property>
                                <Property name="WhammyBarOriginValue"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleValue"><Float>-<xsl:value-of select="$tremBarPitch"/></Float></Property>
                                <Property name="WhammyBarDestinationValue"><Float>0</Float></Property>
                                <Property name="WhammyBarOriginOffset"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleOffset1"><Float>25</Float></Property>
                                <Property name="WhammyBarMiddleOffset2"><Float>25</Float></Property>
                                <Property name="WhammyBarDestinationOffset"><Float>50</Float></Property>
                            </xsl:when>
                            <!-- DiveNRelease -->
                            <xsl:when test="$tremBarType = 1">
                                <Property name="WhammyBar"><Enable /></Property>
                                <Property name="WhammyBarOriginValue"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleValue"><Float>-16</Float></Property>
                                <Property name="WhammyBarDestinationValue"><Float>-<xsl:value-of select="$tremBarPitch"/></Float></Property>
                                <Property name="WhammyBarOriginOffset"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleOffset1"><Float>35</Float></Property>
                                <Property name="WhammyBarMiddleOffset2"><Float>35</Float></Property>
                                <Property name="WhammyBarDestinationOffset"><Float>75</Float></Property>
                            </xsl:when>
                            <!-- DiveNHold -->
                            <xsl:when test="$tremBarType = 2">
                                <Property name="WhammyBar"><Enable /></Property>
                                <Property name="WhammyBarOriginValue"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleValue"><Float>-16</Float></Property>
                                <Property name="WhammyBarDestinationValue"><Float>-<xsl:value-of select="$tremBarPitch"/></Float></Property>
                                <Property name="WhammyBarOriginOffset"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleOffset1"><Float>35</Float></Property>
                                <Property name="WhammyBarMiddleOffset2"><Float>35</Float></Property>
                                <Property name="WhammyBarDestinationOffset"><Float>75</Float></Property>
                            </xsl:when>
                            <!-- Release -->
                            <xsl:when test="$tremBarType = 3">
                                <Property name="WhammyBar"><Enable /></Property>
                                <Property name="WhammyBarOriginValue"><Float>100</Float></Property>
                                <Property name="WhammyBarMiddleValue"><Float>-16</Float></Property>
                                <Property name="WhammyBarDestinationValue"><Float><xsl:value-of select="$tremBarPitch"/></Float></Property>
                                <Property name="WhammyBarOriginOffset"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleOffset1"><Float>35</Float></Property>
                                <Property name="WhammyBarMiddleOffset2"><Float>35</Float></Property>
                                <Property name="WhammyBarDestinationOffset"><Float>75</Float></Property>
                            </xsl:when>
                            <!-- ReturnNRelease -->
                            <xsl:when test="$tremBarType = 4">
                                <Property name="WhammyBar"><Enable /></Property>
                                <Property name="WhammyBarOriginValue"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleValue"><Float>-16</Float></Property>
                                <Property name="WhammyBarDestinationValue"><Float><xsl:value-of select="$tremBarPitch"/></Float></Property>
                                <Property name="WhammyBarOriginOffset"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleOffset1"><Float>35</Float></Property>
                                <Property name="WhammyBarMiddleOffset2"><Float>35</Float></Property>
                                <Property name="WhammyBarDestinationOffset"><Float>75</Float></Property>
                            </xsl:when>
                            <!-- ReturnNHold -->
                            <xsl:when test="$tremBarType = 5">
                                <Property name="WhammyBar"><Enable /></Property>
                                <Property name="WhammyBarOriginValue"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleValue"><Float>-16</Float></Property>
                                <Property name="WhammyBarDestinationValue"><Float><xsl:value-of select="$tremBarPitch"/></Float></Property>
                                <Property name="WhammyBarOriginOffset"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleOffset1"><Float>35</Float></Property>
                                <Property name="WhammyBarMiddleOffset2"><Float>35</Float></Property>
                                <Property name="WhammyBarDestinationOffset"><Float>75</Float></Property>
							</xsl:when>
                            <!-- InvertedDip -->
                            <xsl:when test="$tremBarType = 6">
                                <Property name="WhammyBar"><Enable /></Property>
                                <Property name="WhammyBarOriginValue"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleValue"><Float><xsl:value-of select="$tremBarPitch"/></Float></Property>
                                <Property name="WhammyBarDestinationValue"><Float>0</Float></Property>
                                <Property name="WhammyBarOriginOffset"><Float>0</Float></Property>
                                <Property name="WhammyBarMiddleOffset1"><Float>25</Float></Property>
                                <Property name="WhammyBarMiddleOffset2"><Float>25</Float></Property>
                                <Property name="WhammyBarDestinationOffset"><Float>50</Float></Property>
                            </xsl:when>
                        </xsl:choose>
                      </xsl:if>
                    </Properties>
                  </Beat>
                </xsl:for-each>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
      </Beats>

      <Rhythms>
        <xsl:for-each select="$score/rhythms/rhythm">
          <Rhythm id="{@id}">
            <NoteValue>
              <xsl:choose>
                <xsl:when test="DurationType = 1">Whole</xsl:when>
                <xsl:when test="DurationType = 2">Half</xsl:when>
                <xsl:when test="DurationType = 4">Quarter</xsl:when>
                <xsl:when test="DurationType = 8">Eighth</xsl:when>
                <xsl:when test="DurationType = 16">16th</xsl:when>
                <xsl:when test="DurationType = 32">32nd</xsl:when>
                <xsl:when test="DurationType = 64">64th</xsl:when>
                <xsl:otherwise>Eighth</xsl:otherwise>
              </xsl:choose>
            </NoteValue>
            <AugmentationDot count="{Dotted + DoubleDotted * 2}"/>
            <xsl:if test="IrregularGroupingTimingNotesPlayed">
              <PrimaryTuplet den="{IrregularGroupingTimingNotesPlayedOver}" num="{IrregularGroupingTimingNotesPlayed}"/>
            </xsl:if>
            <xsl:if test="TripletFeel1st = 1">
                <PrimaryTuplet num="3" den="2" />
			</xsl:if>
            <xsl:if test="TripletFeel2nd = 1">
                <SecondaryTuplet num="3" den="2" />
			</xsl:if>
          </Rhythm>
        </xsl:for-each>
      </Rhythms>

      <Notes>
        <!-- master bars -->
        <xsl:for-each select="$score/systems/system/barlines/barline">
          <xsl:variable name="barline" select="."/>
          <xsl:variable name="system" select="../.."/>
          <xsl:variable name="nextBarline" select="(following-sibling::barline | $system/barline[@type = 'end'])[1]"/>
          <xsl:variable name="barlineId" select="position() - 1"/>
          <!-- tracks -->
          <xsl:for-each select="$system/staffs/staff">
            <xsl:variable name="barId" select="$barlineId * $trackCount + position() - 1"/>
            <xsl:variable name="staff" select="."/>

            <xsl:variable name="guitarIn" select="$score/guitarins/guitarin[Staff = $staff/@id][1]"/>
            <xsl:variable name="guitar" select="$score/guitars/guitar[@id = $guitarIn/StaffGuitars - 1 or @id = 0][last()]"/>
            <xsl:variable name="guitarStringCount" select="count($guitar/tuning/notes/Note)"/>

            <!-- voices -->
            <xsl:variable name="voices" select="voices/voice[position[(Position &gt;= $barline/Position) and (Position &lt; $nextBarline/Position)]]"/>
            <xsl:for-each select="$voices">
              <xsl:if test="position() &lt;= $MAX_VOICES">
                <xsl:variable name="voiceId" select="$barId * $MAX_VOICES + position() - 1"/>
                <!-- beats -->
                <xsl:for-each select="position[(Position &gt;= $barline/Position) and (Position &lt; $nextBarline/Position)]">
                  <xsl:variable name="beatId" select="$voiceId * $MAX_POSITIONS + position() - 1"/>
                  <xsl:variable name="position" select="."/>
                    <!-- notes -->
                    <xsl:for-each select="notes/note">
                      <xsl:variable name="note" select="."/>
                      <xsl:variable name="noteId" select="$beatId * $MAX_BEAT_NOTES + position() - 1"/>
                      <Note id="{$noteId}">
                        <xsl:if test="$position/LetRing = 1"><LetRing/></xsl:if>
                        <xsl:if test="GhostNote = 1"><AntiAccent>Normal</AntiAccent></xsl:if>
                        <xsl:choose>
                            <xsl:when test="$position/Staccato = 1 and $position/Marcato = 1">
                                <Accent>9</Accent>
							</xsl:when>
                            <xsl:when test="$position/Staccato = 1 and $position/Sforzando = 1">
                                <Accent>5</Accent>
							</xsl:when>
                            <xsl:when test="$position/Staccato = 1">
                                <Accent>1</Accent>
							</xsl:when>
                            <xsl:when test="$position/Marcato = 1">
                                <Accent>8</Accent>
							</xsl:when>
                            <xsl:when test="$position/Sforzando = 1">
                                <Accent>4</Accent>
							</xsl:when>
						</xsl:choose>  
                        <xsl:if test="TrillTrilledFretNumber">
                          <Trill>
                            <xsl:value-of select="$guitar/tuning/notes/Note[$note/String + 1] + TrillTrilledFretNumber"/>
                          </Trill>
                        </xsl:if>
                        <Tie destination="{Tied = 1}" origin="{TieWrap = 1
                             or $position/following-sibling::position[1]/notes/note[String = $note/String and FretNumber = $note/FretNumber and Tied = 1]}"/>
                        <Properties>
                          <Property name="String">
                            <String><xsl:value-of select="$staff/TablatureStaffType - String - 1"/></String>
                          </Property>
                          <Property name="Fret">
                            <Fret><xsl:value-of select="FretNumber"/></Fret>
                          </Property>
                          <!-- Hammer-on Pull-off -->
                          <xsl:if test="HammerOn = 1 or PullOff = 1">
                            <Property name="HopoOrigin"><Enable /></Property>
                          </xsl:if>
                          <xsl:if test="HammerOnFromNowhere = 1 or PullOffToNowhere = 1">
                            <Property name="LeftHandTapped"><Enable /></Property>
                          </xsl:if>
                          <xsl:if test="$position/preceding-sibling::position[1]/notes/note[String = $note/String and FretNumber != $note/FretNumber and (HammerOn = 1 or PullOff = 1) and HammerOnFromNowhere != 1 and PullOffToNowhere != 1]" >
                            <Property name="HopoDestination"><Enable /></Property>
						  </xsl:if>
                          <!-- Dead, PalmMuted, Tapped -->
                          <xsl:if test="Muted = 1">
                            <Property name="Muted"><Enable/></Property>
                          </xsl:if>
                          <xsl:if test="$position/Tap = 1">
                            <Property name="Tapped"><Enable/></Property>
                          </xsl:if>
                          <xsl:if test="$position/PalmMuting = 1">
                            <Property name="PalmMuted"><Enable/></Property>
                          </xsl:if>
                          <!-- VibratoWTremBar, Vibrato-->
                          <xsl:if test="$position/Vibrato = 1">
                            <Property name="Vibrato"><Strength>Slight</Strength></Property>
                          </xsl:if>
                          <xsl:if test="$position/WideVibrato = 1">
                            <Property name="Vibrato"><Strength>Wide</Strength></Property>
                          </xsl:if>
                          <!-- Bend -->
                          <xsl:if test="BendType">
                            <xsl:choose>
                              <!-- Bend -->
                              <xsl:when test="BendType = 0">
                                <Property name="Bended"><Enable /></Property>
                                <Property name="BendOriginValue"><Float>0</Float></Property>
                                <Property name="BendMiddleValue"><Float>-1</Float></Property>
                                <Property name="BendDestinationValue"><Float><xsl:value-of select="BendBentPitch * 25"/></Float></Property>
                                <Property name="BendOriginOffset"><Float>0</Float></Property>
                                <Property name="BendMiddleOffset1"><Float>12</Float></Property>
                                <Property name="BendMiddleOffset2"><Float>12</Float></Property>
                                <Property name="BendDestinationOffset"><Float>25</Float></Property>
							  </xsl:when>
                              <!-- BendNRelease -->
                              <xsl:when test="BendType = 1">
                                <Property name="Bended"><Enable /></Property>
                                <Property name="BendOriginValue"><Float>0</Float></Property>
                                <Property name="BendMiddleValue"><Float><xsl:value-of select="BendBentPitch * 25"/></Float></Property>
                                <Property name="BendDestinationValue"><Float><xsl:value-of select="BendReleasePitch * 25"/></Float></Property>
                                <Property name="BendOriginOffset"><Float>0</Float></Property>
                                <Property name="BendMiddleOffset1"><Float>17</Float></Property>
                                <Property name="BendMiddleOffset2"><Float>34</Float></Property>
                                <Property name="BendDestinationOffset"><Float>50</Float></Property>  
							  </xsl:when>
                              <!-- BendNHold -->
                              <xsl:when test="BendType = 2"> 
                                <Property name="Bended"><Enable /></Property>
                                <Property name="BendOriginValue"><Float>0</Float></Property>
                                <Property name="BendMiddleValue"><Float>-1</Float></Property>
                                <Property name="BendDestinationValue"><Float><xsl:value-of select="BendBentPitch * 25"/></Float></Property>
                                <Property name="BendOriginOffset"><Float>0</Float></Property>
                                <Property name="BendMiddleOffset1"><Float>12</Float></Property>
                                <Property name="BendMiddleOffset2"><Float>12</Float></Property>
                                <Property name="BendDestinationOffset"><Float>25</Float></Property>
							  </xsl:when>
                              <!-- PreBend -->
                              <xsl:when test="BendType = 3">
                                <Property name="Bended"><Enable /></Property>
                                <Property name="BendOriginValue"><Float><xsl:value-of select="BendBentPitch * 25"/></Float></Property>
                                <Property name="BendMiddleValue"><Float>-1</Float></Property>
                                <Property name="BendDestinationValue"><Float><xsl:value-of select="BendBentPitch * 25"/></Float></Property>
                                <Property name="BendOriginOffset"><Float>0</Float></Property>
                                <Property name="BendMiddleOffset1"><Float>50</Float></Property>
                                <Property name="BendMiddleOffset2"><Float>50</Float></Property>
                                <Property name="BendDestinationOffset"><Float>100</Float></Property>  
							  </xsl:when>
                              <!-- PreBendNRelease -->
                              <xsl:when test="BendType = 4">
                                <Property name="Bended"><Enable /></Property>
                                <Property name="BendOriginValue"><Float><xsl:value-of select="BendBentPitch * 25"/></Float></Property>
                                <Property name="BendMiddleValue"><Float>-1</Float></Property>
                                <Property name="BendDestinationValue"><Float><xsl:value-of select="BendReleasePitch * 25"/></Float></Property>
                                <Property name="BendOriginOffset"><Float>0</Float></Property>
                                <Property name="BendMiddleOffset1"><Float>12</Float></Property>
                                <Property name="BendMiddleOffset2"><Float>12</Float></Property>
                                <Property name="BendDestinationOffset"><Float>25</Float></Property>  
							  </xsl:when>
                              <!-- PreBendNHold -->
                              <xsl:when test="BendType = 5">
                                <Property name="Bended"><Enable /></Property>
                                <Property name="BendOriginValue"><Float><xsl:value-of select="BendBentPitch * 25"/></Float></Property>
                                <Property name="BendMiddleValue"><Float>-1</Float></Property>
                                <Property name="BendDestinationValue"><Float><xsl:value-of select="BendBentPitch * 25"/></Float></Property>
                                <Property name="BendOriginOffset"><Float>0</Float></Property>
                                <Property name="BendMiddleOffset1"><Float>50</Float></Property>
                                <Property name="BendMiddleOffset2"><Float>50</Float></Property>
                                <Property name="BendDestinationOffset"><Float>100</Float></Property>  
							  </xsl:when>
                              <!-- Gradual Release -->
                              <xsl:when test="BendType = 6">
                                <Property name="Bended"><Enable /></Property>
                                <Property name="BendOriginValue"><Float>100</Float></Property>
                                <Property name="BendMiddleValue"><Float>-1</Float></Property>
                                <Property name="BendDestinationValue"><Float><xsl:value-of select="BendReleasePitch * 25"/></Float></Property>
                                <Property name="BendOriginOffset"><Float>0</Float></Property>
                                <Property name="BendMiddleOffset1"><Float>12</Float></Property>
                                <Property name="BendMiddleOffset2"><Float>12</Float></Property>
                                <Property name="BendDestinationOffset"><Float>25</Float></Property>  
							  </xsl:when>
                              <!-- Immediate Release -->
                              <xsl:when test="BendType = 7">
                                <Property name="Bended"><Enable /></Property>
                                <Property name="BendOriginValue"><Float>100</Float></Property>
                                <Property name="BendMiddleValue"><Float>-1</Float></Property>
                                <Property name="BendDestinationValue"><Float>0</Float></Property>
                                <Property name="BendOriginOffset"><Float>0</Float></Property>
                                <Property name="BendMiddleOffset1"><Float>6</Float></Property>
                                <Property name="BendMiddleOffset2"><Float>6</Float></Property>
                                <Property name="BendDestinationOffset"><Float>12</Float></Property>  
							  </xsl:when>
                            </xsl:choose>
                          </xsl:if>
                          <!-- Slide -->
                          <xsl:if test="SlideIntoType or SlideOutOfType">
                            <Property name="Slide">                              
                              <Flags>
                                <xsl:choose>
                                  <xsl:when test="SlideIntoType = 1">16</xsl:when>
                                  <xsl:when test="SlideIntoType = 2">32</xsl:when>
                                  <xsl:when test="SlideIntoType = 3">17</xsl:when>
                                  <xsl:when test="SlideIntoType = 4">33</xsl:when>
                                  <xsl:when test="SlideIntoType = 5">18</xsl:when>
                                  <xsl:when test="SlideIntoType = 6">34</xsl:when>
                                  <xsl:when test="SlideOutOfType = 1">1</xsl:when>
                                  <xsl:when test="SlideOutOfType = 2">2</xsl:when>
                                  <xsl:when test="SlideOutOfType = 3">4</xsl:when>
                                  <xsl:when test="SlideOutOfType = 4">8</xsl:when>
                                  <xsl:otherwise>0</xsl:otherwise>
                                </xsl:choose>
                              </Flags>
                            </Property>
                          </xsl:if>
                          <!-- HarmonicType -->
                          <xsl:if test="NaturalHarmonic = 1">
                            <Property name="HarmonicType"><HType>Natural</HType></Property>
                            <Property name="HarmonicFret"><HFret>12</HFret></Property>
                          </xsl:if>
                          <xsl:if test="ArtificialHarmonicKey">
                            <Property name="HarmonicType"><HType>Artificial</HType></Property>
                            <Property name="HarmonicFret"><HFret>12</HFret></Property>
                          </xsl:if>
                          <xsl:if test="TappedHarmonicTappedFretNumber">
                            <Property name="HarmonicType"><HType>Tap</HType></Property>
                            <Property name="HarmonicFret"><HFret>12</HFret></Property>
                            <!--Property name="HarmonicFret"><HFret><xsl:value-of select="TappedHarmonicTappedFretNumber"/></HFret></Property-->
                          </xsl:if>
                        </Properties>
                      </Note>
                    </xsl:for-each>
                </xsl:for-each>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
      </Notes>
      
    </GPIF>
  </xsl:template>
</xsl:stylesheet>
