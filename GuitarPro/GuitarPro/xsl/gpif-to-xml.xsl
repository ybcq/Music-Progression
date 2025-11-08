<?xml version="1.0" encoding="utf-8"?>
<!-- Created with Liquid XML Studio Developer Edition (Trial) 8.0.7.1998 (http://www.liquid-technologies.com) -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" doctype-public="-//Recordare//DTD MusicXML 2.0 Partwise//EN" doctype-system="musicxml20/partwise.dtd"/>
  <!--xsl:output method="xml" doctype-public="-//Recordare//DTD MusicXML 2.0 Timewise//EN" doctype-system="musicxml20/timewise.dtd"/-->
  <xsl:variable name="DIVISIONS" select="1024" />
  <xsl:key name="bars" match="/GPIF/Bars/Bar" use="@id" />
  <xsl:key name="voices" match="/GPIF/Voices/Voice" use="@id" />
  <xsl:key name="beats" match="/GPIF/Beats/Beat" use="@id" />
  <xsl:key name="notes" match="/GPIF/Notes/Note" use="@id" />
  <xsl:key name="rhythms" match="/GPIF/Rhythms/Rhythm" use="@id" />
  <xsl:template name="CountIndexes">
    <xsl:param name="indexes" select="'0'" />
    <xsl:param name="counter" select="1" />
    <xsl:choose>
      <xsl:when test="contains($indexes, ' ')">
        <xsl:call-template name="CountIndexes">
          <xsl:with-param name="counter" select="$counter + 1" />
          <xsl:with-param name="indexes" select="substring-after($indexes, ' ')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$counter" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="IndexValue">
    <xsl:param name="indexes" select="'0'" />
    <xsl:param name="num" select="0" />
    <xsl:choose>
      <xsl:when test="$num = 0">
        <xsl:choose>
          <xsl:when test="contains($indexes, ' ')">
            <xsl:value-of select="substring-before($indexes, ' ')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$indexes" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="IndexValue">
          <xsl:with-param name="indexes" select="substring-after($indexes, ' ')" />
          <xsl:with-param name="num" select="$num - 1" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="IndexIterator">
    <xsl:param name="indexes" select="''" />
    <xsl:param name="template" select="''" />
    <xsl:param name="num" select="0" />
    <xsl:param name="arg1" select="0" />
    <xsl:param name="arg2" select="0" />
    <xsl:param name="arg3" select="0" />
    <xsl:param name="arg4" select="0" />
    <xsl:choose>
      <xsl:when test="contains($indexes, ' ')">
        <xsl:call-template name="IndexIterator">
          <xsl:with-param name="indexes" select="substring-before($indexes, ' ')" />
          <xsl:with-param name="template" select="$template" />
          <xsl:with-param name="num" select="$num" />
          <xsl:with-param name="arg1" select="$arg1" />
          <xsl:with-param name="arg2" select="$arg2" />
          <xsl:with-param name="arg3" select="$arg3" />
          <xsl:with-param name="arg4" select="$arg4" />
        </xsl:call-template>
        <xsl:call-template name="IndexIterator">
          <xsl:with-param name="indexes" select="substring-after($indexes, ' ')" />
          <xsl:with-param name="template" select="$template" />
          <xsl:with-param name="num" select="$num + 1" />
          <xsl:with-param name="arg1" select="$arg1" />
          <xsl:with-param name="arg2" select="$arg2" />
          <xsl:with-param name="arg3" select="$arg3" />
          <xsl:with-param name="arg4" select="$arg4" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$template = 'BarStaff'">
            <xsl:call-template name="BarStaff">
              <xsl:with-param name="id" select="$indexes" />
              <xsl:with-param name="num" select="$num" />
              <xsl:with-param name="arg1" select="$arg1" />
              <xsl:with-param name="arg2" select="$arg2" />
              <xsl:with-param name="arg3" select="$arg3" />
              <xsl:with-param name="arg4" select="$arg4" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$template = 'BarVoice'">
            <xsl:call-template name="BarVoice">
              <xsl:with-param name="id" select="$indexes" />
              <xsl:with-param name="num" select="$num" />
              <xsl:with-param name="arg1" select="$arg1" />
              <xsl:with-param name="arg2" select="$arg2" />
              <xsl:with-param name="arg3" select="$arg3" />
              <xsl:with-param name="arg4" select="$arg4" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$template = 'Tuning'">
            <xsl:call-template name="Tuning">
              <xsl:with-param name="id" select="$indexes" />
              <xsl:with-param name="num" select="$num" />
              <xsl:with-param name="arg1" select="$arg1" />
              <xsl:with-param name="arg2" select="$arg2" />
              <xsl:with-param name="arg3" select="$arg3" />
              <xsl:with-param name="arg4" select="$arg4" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$template = 'Voice'">
            <xsl:call-template name="Voice">
              <xsl:with-param name="id" select="$indexes" />
              <xsl:with-param name="num" select="$num" />
              <xsl:with-param name="arg1" select="$arg1" />
              <xsl:with-param name="arg2" select="$arg2" />
              <xsl:with-param name="arg3" select="$arg3" />
              <xsl:with-param name="arg4" select="$arg4" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$template = 'Beat'">
            <xsl:call-template name="Beat">
              <xsl:with-param name="id" select="$indexes" />
              <xsl:with-param name="num" select="$num" />
              <xsl:with-param name="arg1" select="$arg1" />
              <xsl:with-param name="arg2" select="$arg2" />
              <xsl:with-param name="arg3" select="$arg3" />
              <xsl:with-param name="arg4" select="$arg4" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$template = 'Note'">
            <xsl:call-template name="Note">
              <xsl:with-param name="id" select="$indexes" />
              <xsl:with-param name="num" select="$num" />
              <xsl:with-param name="arg1" select="$arg1" />
              <xsl:with-param name="arg2" select="$arg2" />
              <xsl:with-param name="arg3" select="$arg3" />
              <xsl:with-param name="arg4" select="$arg4" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$template = 'FrameNote'">
            <xsl:call-template name="FrameNote">
              <xsl:with-param name="id" select="$indexes" />
              <xsl:with-param name="num" select="$num" />
              <xsl:with-param name="arg1" select="$arg1" />
              <xsl:with-param name="arg2" select="$arg2" />
              <xsl:with-param name="arg3" select="$arg3" />
              <xsl:with-param name="arg4" select="$arg4" />
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="Pitch">
    <xsl:param name="pitch" select="0" />
    <xsl:param name="stepElement" select="'step'" />
    <xsl:param name="alterElement" select="'alter'" />
    <xsl:param name="octaveElement" select="'octave'" />
    <xsl:variable name="note" select="$pitch mod 12" />
    <xsl:choose>
      <xsl:when test="$note = 0">
        <xsl:element name="{$stepElement}">C</xsl:element>
      </xsl:when>
      <xsl:when test="$note = 1">
        <xsl:element name="{$stepElement}">C</xsl:element>
        <xsl:element name="{$alterElement}">1</xsl:element>
      </xsl:when>
      <xsl:when test="$note = 2">
        <xsl:element name="{$stepElement}">D</xsl:element>
      </xsl:when>
      <xsl:when test="$note = 3">
        <xsl:element name="{$stepElement}">D</xsl:element>
        <xsl:element name="{$alterElement}">1</xsl:element>
      </xsl:when>
      <xsl:when test="$note = 4">
        <xsl:element name="{$stepElement}">E</xsl:element>
      </xsl:when>
      <xsl:when test="$note = 5">
        <xsl:element name="{$stepElement}">F</xsl:element>
      </xsl:when>
      <xsl:when test="$note = 6">
        <xsl:element name="{$stepElement}">F</xsl:element>
        <xsl:element name="{$alterElement}">1</xsl:element>
      </xsl:when>
      <xsl:when test="$note = 7">
        <xsl:element name="{$stepElement}">G</xsl:element>
      </xsl:when>
      <xsl:when test="$note = 8">
        <xsl:element name="{$stepElement}">G</xsl:element>
        <xsl:element name="{$alterElement}">1</xsl:element>
      </xsl:when>
      <xsl:when test="$note = 9">
        <xsl:element name="{$stepElement}">A</xsl:element>
      </xsl:when>
      <xsl:when test="$note = 10">
        <xsl:element name="{$stepElement}">A</xsl:element>
        <xsl:element name="{$alterElement}">1</xsl:element>
      </xsl:when>
      <xsl:when test="$note = 11">
        <xsl:element name="{$stepElement}">B</xsl:element>
      </xsl:when>
    </xsl:choose>
    <xsl:element name="{$octaveElement}">
      <xsl:value-of select="floor($pitch div 12) - 1" />
    </xsl:element>
  </xsl:template>
  <xsl:template name="Tuning">
    <xsl:param name="id" select="0" />
    <xsl:param name="num" select="0" />
    <staff-tuning line="{$num + 1}">
      <xsl:call-template name="Pitch">
        <xsl:with-param name="pitch" select="$id" />
        <xsl:with-param name="stepElement" select="'tuning-step'" />
        <xsl:with-param name="alterElement" select="'tuning-alter'" />
        <xsl:with-param name="octaveElement" select="'tuning-octave'" />
      </xsl:call-template>
    </staff-tuning>
  </xsl:template>
  <xsl:template name="RhythmDuration">
    <xsl:param name="rhythm" select="0" />
    <xsl:variable name="noteValue" select="$rhythm/NoteValue" />
    <xsl:variable name="noteDuration">
      <xsl:choose>
        <xsl:when test="$noteValue = 'Long'">16</xsl:when>
        <xsl:when test="$noteValue = 'DoubleWhole'">8</xsl:when>
        <xsl:when test="$noteValue = 'Whole'">4</xsl:when>
        <xsl:when test="$noteValue = 'Half'">2</xsl:when>
        <xsl:when test="$noteValue = 'Quarter'">1</xsl:when>
        <xsl:when test="$noteValue = 'Eighth'">0.5</xsl:when>
        <xsl:when test="$noteValue = '16th'">0.25</xsl:when>
        <xsl:when test="$noteValue = '32nd'">0.125</xsl:when>
        <xsl:when test="$noteValue = '64th'">0.0625</xsl:when>
        <xsl:when test="$noteValue = '128th'">0.03125</xsl:when>
        <xsl:when test="$noteValue = '256th'">0.015625</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="dottedNoteCoef">
      <xsl:choose>
        <xsl:when test="$rhythm/AugmentationDot/@count = 1">1.5</xsl:when>
        <xsl:when test="$rhythm/AugmentationDot/@count = 2">1.75</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="duration" select="$DIVISIONS * $noteDuration * $dottedNoteCoef" />
    <xsl:choose>
      <xsl:when test="$rhythm/PrimaryTuplet">
        <xsl:value-of select="round($duration * $rhythm/PrimaryTuplet/@den div $rhythm/PrimaryTuplet/@num)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="round($duration)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="RhythmType">
    <xsl:param name="rhythm" select="0" />
    <xsl:variable name="noteValue" select="$rhythm/NoteValue" />
    <xsl:choose>
      <xsl:when test="$noteValue = 'DoubleWhole'">breve</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="translate($noteValue, 'LWHQE', 'lwhqe')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="Rhythm">
    <xsl:param name="rhythm" select="0" />
    <type>
      <xsl:call-template name="RhythmType">
        <xsl:with-param name="rhythm" select="$rhythm" />
      </xsl:call-template>
    </type>
    <xsl:if test="$rhythm/AugmentationDot/@count &gt; 0">
      <dot />
    </xsl:if>
    <xsl:if test="$rhythm/AugmentationDot/@count &gt; 1">
      <dot />
    </xsl:if>
    <xsl:if test="$rhythm/PrimaryTuplet">
      <time-modification>
        <actual-notes>
          <xsl:value-of select="$rhythm/PrimaryTuplet/@num" />
        </actual-notes>
        <normal-notes>
          <xsl:value-of select="$rhythm/PrimaryTuplet/@den" />
        </normal-notes>
      </time-modification>
    </xsl:if>
  </xsl:template>
  <xsl:template name="Dynamics">
    <xsl:param name="dynamic" select="'MF'" />
    <xsl:if test="$dynamic and $dynamic != 'None'">
      <dynamics>
        <xsl:element name="{translate($dynamic, 'PMF', 'pmf')}" />
      </dynamics>
    </xsl:if>
  </xsl:template>
  <xsl:template name="Bit">
    <xsl:param name="num" select="0" />
    <xsl:param name="bit" select="1" />
    <xsl:choose>
      <xsl:when test="($num mod($bit * 2)) - ($num mod($bit))">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="Note">
    <xsl:param name="id" select="0" />
    <xsl:param name="num" select="0" />
    <xsl:param name="arg1" select="0" />
    <xsl:param name="arg2" select="0" />
    <xsl:param name="arg3" select="0" />
    <xsl:param name="arg4" select="0" />
    <xsl:variable name="note" select="key('notes', $id)" />
    <xsl:variable name="voice" select="$arg1" />
    <xsl:variable name="strings" select="$arg2" />
    <xsl:variable name="tuning" select="$arg3" />
    <xsl:variable name="beat" select="$arg4" />
    <xsl:variable name="string">
      <xsl:choose>
        <xsl:when test="$note/Properties/Property[@name = 'String']">
          <xsl:value-of select="$note/Properties/Property[@name = 'String']/String" />
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="fret">
      <xsl:choose>
        <xsl:when test="$note/Properties/Property[@name = 'Fret']">
          <xsl:value-of select="$note/Properties/Property[@name = 'Fret']/Fret" />
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rhythm" select="key('rhythms', $beat/Rhythm/@ref)" />
    <!-- grace note -->
    <!--xsl:if test="$note/GraceNote">
      <xsl:variable name="graceDuration" select="round($DIVISIONS * substring-before($note/GraceNote/Duration, '/') div substring-after($note/GraceNote/Duration, '/'))" />
      <note>
        <xsl:choose>
          <xsl:when test="$note/GraceNote/OnBeat">
            <grace steal-time-previous="0" steal-time-following="{$graceDuration}" make-time="{$graceDuration}" slash="yes" />
          </xsl:when>
          <xsl:otherwise>
            <grace steal-time-previous="{$graceDuration}" steal-time-following="0" make-time="{$graceDuration}" slash="yes" />
          </xsl:otherwise>
        </xsl:choose>
        <pitch>
          <xsl:call-template name="Pitch">
            <xsl:with-param name="pitch" select="$note/GraceNote/Pitch" />
          </xsl:call-template>
        </pitch>
        <voice>
          <xsl:value-of select="$voice" />
        </voice>
        <type>
          <xsl:choose>
            <xsl:when test="$note/GraceNote/Duration = '1/16'">64th</xsl:when>
            <xsl:when test="$note/GraceNote/Duration = '1/8'">32nd</xsl:when>
            <xsl:when test="$note/GraceNote/Duration = '1/4'">16th</xsl:when>
            <xsl:otherwise>eighth</xsl:otherwise>
          </xsl:choose>
        </type>
        <notations>
          <xsl:call-template name="Dynamics">
            <xsl:with-param name="dynamic" select="$note/GraceNote/Dynamic" />
          </xsl:call-template>
        </notations>
      </note>
    </xsl:if-->
    <note>
      <xsl:if test="$note/Properties/Property[@name = 'PalmMuted']">
        <xsl:attribute name="pizzicato">yes</xsl:attribute>
      </xsl:if>
      <xsl:if test="$num != 0">
        <chord />
      </xsl:if>
      <pitch>
        <!-- calculate midi pitch of the note -->
        <xsl:variable name="pitch">
          <xsl:choose>
            <xsl:when test="$strings = 0">
              <xsl:value-of select="$note/Properties/Property[@name = 'Midi']/Number" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="stringPitch">
                <xsl:call-template name="IndexValue">
                  <xsl:with-param name="indexes" select="$tuning/Pitches" />
                  <xsl:with-param name="num" select="$string" />
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$stringPitch + $fret" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- convert midi pitch to octave/step/alter -->
        <xsl:call-template name="Pitch">
          <xsl:with-param name="pitch" select="$pitch" />
        </xsl:call-template>
      </pitch>
      <duration>
        <xsl:call-template name="RhythmDuration">
          <xsl:with-param name="rhythm" select="$rhythm" />
        </xsl:call-template>
      </duration>
      <!-- sounding tie -->
      <xsl:if test="$note/Tie">
        <xsl:choose>
          <xsl:when test="$note/Tie/@origin = 'true' and $note/Tie/@destination = 'false'">
            <tie type="start" />
          </xsl:when>
          <xsl:when test="$note/Tie/@destination = 'true' and $note/Tie/@origin = 'false'">
            <tie type="stop" />
          </xsl:when>
        </xsl:choose>
      </xsl:if>
      <voice>
        <xsl:value-of select="$voice" />
      </voice>
      <xsl:call-template name="Rhythm">
        <xsl:with-param name="rhythm" select="$rhythm" />
      </xsl:call-template>
      <notations>
        <!-- visual tie -->
        <xsl:if test="$note/Tie">
          <xsl:choose>
            <xsl:when test="$note/Tie/@origin = 'true' and $note/Tie/@destination = 'false'">
              <tied type="start" />
            </xsl:when>
            <xsl:when test="$note/Tie/@destination = 'true' and $note/Tie/@origin = 'false'">
              <tied type="stop" />
            </xsl:when>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="$note/Trill">
          <ornaments>
            <trill-mark placement="above" />
          </ornaments>
        </xsl:if>
        <xsl:if test="$strings != 0">
          <technical>
            <xsl:if test="$note/LeftFingering">
              <fingering>
                <xsl:value-of select="translate($note/LeftFingering, 'PIMAC', '51234')" />
              </fingering>
            </xsl:if>
            <xsl:if test="$note/RightFingering">
              <pluck>
                <xsl:value-of select="translate($note/RightFingering, 'PIMAC', 'pimac')" />
              </pluck>
            </xsl:if>
            <fret>
              <xsl:value-of select="$fret" />
            </fret>
            <string>
              <xsl:value-of select="$strings - $string" />
            </string>
            <xsl:if test="$beat/Properties/Property[@name = 'Popped' or @name = 'Slapped']">
              <snap-pizzicato />
            </xsl:if>
            <xsl:if test="$note/Properties/Property[@name = 'Tapped']">
              <tap />
            </xsl:if>
            <xsl:if test="$beat/Properties/Property[@name = 'PickStroke']">
              <xsl:choose>
                <xsl:when test="$beat/Properties/Property[@name = 'PickStroke']/Direction = 'Up'">
                  <up-bow />
                </xsl:when>
                <xsl:otherwise>
                  <down-bow />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:if test="$note/Properties/Property[@name = 'Dead']">
              <stopped />
            </xsl:if>
            <!-- bends -->
            <!--xsl:if test="$note/Properties/Property[@name = 'Bend']">
              <xsl:variable name="bend" select="$note/Properties/Property[@name = 'Bend']/BendDescription" />
              <bend>
                <bend-alter>
                  <xsl:if test="contains($bend/Type, 'PreBend')">-</xsl:if>
                  <xsl:value-of select="$bend/Value div 50" />
                </bend-alter>
                <xsl:choose>
                  <xsl:when test="$bend/Type = 'PreBend'">
                    <pre-bend />
                  </xsl:when>
                  <xsl:when test="$bend/Type = 'PreBendRelease'">
                    <release />
                  </xsl:when>
                </xsl:choose>
              </bend>
            </xsl:if-->
            <!-- whammy -->
            <!--xsl:if test="$beat/Properties/Property[@name = 'WhammyBar']">
              <xsl:variable name="bend" select="$beat/Properties/Property[@name = 'WhammyBar']/WhammyBarDescription" />
              <bend>
                <bend-alter>
                  <xsl:if test="$bend/Type = 'Dip' or $bend/Type = 'Dive' or $bend/Type = 'ReleaseDown'">-</xsl:if>
                  <xsl:value-of select="$bend/Value div 50" />
                </bend-alter>
                <xsl:if test="contains($bend/Type, 'Release')">
                  <release />
                </xsl:if>
                <with-bar />
              </bend>
            </xsl:if-->
            <!-- harmonic -->
            <xsl:if test="$note/Properties/Property[@name = 'HarmonicType']">
              <harmonic>
                <xsl:choose>
                  <xsl:when test="$note/Properties/Property[@name = 'HarmonicType']/HType = 'Natural'">
                    <natural />
                  </xsl:when>
                  <xsl:otherwise>
                    <artificial />
                  </xsl:otherwise>
                </xsl:choose>
              </harmonic>
            </xsl:if>
          </technical>
        </xsl:if>
        <articulations>
          <xsl:variable name="staccato">
            <xsl:call-template name="Bit">
              <xsl:with-param name="num" select="$note/Accent" />
              <xsl:with-param name="bit" select="1" />
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="accent">
            <xsl:call-template name="Bit">
              <xsl:with-param name="num" select="$note/Accent" />
              <xsl:with-param name="bit" select="8" />
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="strongAccent">
            <xsl:call-template name="Bit">
              <xsl:with-param name="num" select="$note/Accent" />
              <xsl:with-param name="bit" select="4" />
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$staccato = 1">
            <staccato />
          </xsl:if>
          <xsl:if test="$accent = 1">
            <accent />
          </xsl:if>
          <xsl:if test="$strongAccent = 1">
            <strong-accent />
          </xsl:if>
        </articulations>
        <xsl:call-template name="Dynamics">
          <xsl:with-param name="dynamic" select="$beat/Dynamic" />
        </xsl:call-template>
        <xsl:if test="$beat/Properties/Property[@name = 'Brush']">
          <arpeggiate direction="{translate($beat/Properties/Property[@name = 'Brush']/Direction, 'UD', 'ud')}" />
        </xsl:if>
        <xsl:if test="$note/Properties/Property[@name = 'Slide']">
          <slide type="start" />
        </xsl:if>
      </notations>
    </note>
  </xsl:template>
  <xsl:template name="FrameNote">
    <xsl:param name="id" select="0" />
    <xsl:param name="num" select="0" />
    <xsl:param name="arg1" select="0" />
    <xsl:param name="arg2" select="0" />
    <xsl:variable name="strings" select="$arg1" />
    <xsl:variable name="baseFret" select="$arg2" />
    <xsl:if test="$id != -1">
      <frame-note>
        <string>
          <xsl:value-of select="$strings - $num" />
        </string>
        <fret>
          <xsl:choose>
            <xsl:when test="$id != 0">
              <xsl:value-of select="$id + $baseFret" />
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </fret>
      </frame-note>
    </xsl:if>
  </xsl:template>
  <xsl:template name="Beat">
    <xsl:param name="id" select="0" />
    <xsl:param name="arg1" select="0" />
    <xsl:param name="arg2" select="0" />
    <xsl:param name="arg3" select="0" />
    <xsl:param name="arg4" select="0" />
    <xsl:variable name="beat" select="key('beats', $id)" />
    <xsl:variable name="voice" select="$arg1" />
    <xsl:variable name="strings" select="$arg2" />
    <xsl:variable name="tuning" select="$arg3" />
    <xsl:variable name="track" select="$arg4" />
    <xsl:if test="$beat/FreeText">
      <direction placement="above">
        <direction-type>
          <words>
            <xsl:value-of select="$beat/FreeText" />
          </words>
        </direction-type>
      </direction>
    </xsl:if>
    <!-- chord -->
    <!--xsl:if test="$beat/Properties/Property[@name = 'Chord']">
      <xsl:variable name="chordName" select="$beat/Properties/Property[@name = 'Chord']/Name" />
      <xsl:variable name="chord" select="$track/Properties/Property[@name = 'ChordCollection']/Chords/Chord[@name = $chordName]" />
      <harmony>
        <root>
          <root-step>
            <xsl:value-of select="substring($chordName, 1, 1)" />
          </root-step>
          <xsl:variable name="alter" select="substring($chordName, 2, 1)" />
          <root-alter>
            <xsl:choose>
              <xsl:when test="$alter = '#'">1</xsl:when>
              <xsl:when test="$alter = 'b'">-1</xsl:when>
              <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
          </root-alter>
        </root>
        <xsl:choose>
          <xsl:when test="contains($chordName, 'm7M')">
            <kind text="m7M">major-minor</kind>
          </xsl:when>
          <xsl:when test="contains($chordName, '7M')">
            <kind text="7M">major-seventh</kind>
          </xsl:when>
          <xsl:when test="contains($chordName, 'm7')">
            <kind text="m7">minor-seventh</kind>
          </xsl:when>
          <xsl:when test="contains($chordName, 'm6')">
            <kind text="m6">minor-sixth</kind>
          </xsl:when>
          <xsl:when test="contains($chordName, 'm')">
            <kind text="m">minor</kind>
          </xsl:when>
          <xsl:when test="contains($chordName, '6')">
            <kind text="6">major-sixth</kind>
          </xsl:when>
          <xsl:when test="contains($chordName, '7')">
            <kind text="7">dominant</kind>
          </xsl:when>
          <xsl:when test="contains($chordName, 'sus2')">
            <kind text="sus2">suspended-second</kind>
          </xsl:when>
          <xsl:when test="contains($chordName, 'sus4')">
            <kind text="sus4">suspended-fourth</kind>
          </xsl:when>
          <xsl:when test="contains($chordName, 'dim')">
            <kind text="dim">diminished</kind>
          </xsl:when>
          <xsl:when test="contains($chordName, 'aug')">
            <kind text="aug">augmented</kind>
          </xsl:when>
          <xsl:when test="contains($chordName, '5')">
            <kind text="5">power</kind>
          </xsl:when>
          <xsl:otherwise>
            <kind>major</kind>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="contains($chordName, '/')">
          <xsl:variable name="bass" select="substring-after($chordName, '/')" />
          <bass>
            <bass-step>
              <xsl:value-of select="$bass" />
            </bass-step>
            <xsl:variable name="alter" select="substring($bass, 2, 1)" />
            <bass-alter>
              <xsl:choose>
                <xsl:when test="$alter = '#'">1</xsl:when>
                <xsl:when test="$alter = 'b'">-1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
              </xsl:choose>
            </bass-alter>
          </bass>
        </xsl:if>
        <frame>
          <frame-strings>
            <xsl:value-of select="$strings" />
          </frame-strings>
          <frame-frets>
            <xsl:value-of select="$chord/@spanLimit" />
          </frame-frets>
          <first-fret>
            <xsl:value-of select="$chord/@baseFret + 1" />
          </first-fret>
          <xsl:call-template name="IndexIterator">
            <xsl:with-param name="indexes" select="$chord/@frets" />
            <xsl:with-param name="template" select="'FrameNote'" />
            <xsl:with-param name="arg1" select="$strings" />
            <xsl:with-param name="arg2" select="$chord/@baseFret" />
          </xsl:call-template>
        </frame>
      </harmony>
    </xsl:if-->
    <!-- notes in the beat -->
    <xsl:choose>
      <xsl:when test="$beat/Notes">
        <xsl:call-template name="IndexIterator">
          <xsl:with-param name="indexes" select="$beat/Notes" />
          <xsl:with-param name="template" select="'Note'" />
          <xsl:with-param name="arg1" select="$voice" />
          <xsl:with-param name="arg2" select="$strings" />
          <xsl:with-param name="arg3" select="$tuning" />
          <xsl:with-param name="arg4" select="$beat" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="rhythm" select="key('rhythms', $beat/Rhythm/@ref)" />
        <note>
          <rest />
          <duration>
            <xsl:call-template name="RhythmDuration">
              <xsl:with-param name="rhythm" select="$rhythm" />
            </xsl:call-template>
          </duration>
          <voice>
            <xsl:value-of select="$voice" />
          </voice>
          <xsl:call-template name="Rhythm">
            <xsl:with-param name="rhythm" select="$rhythm" />
          </xsl:call-template>
          <notations>
            <xsl:call-template name="Dynamics">
              <xsl:with-param name="dynamic" select="$beat/Dynamic" />
            </xsl:call-template>
          </notations>
        </note>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="VoiceDuration">
    <xsl:param name="indexes" select="'0'" />
    <xsl:choose>
      <xsl:when test="contains($indexes, ' ')">
        <xsl:variable name="headDuration">
          <xsl:call-template name="VoiceDuration">
            <xsl:with-param name="indexes" select="substring-before($indexes, ' ')" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="tailDuration">
          <xsl:call-template name="VoiceDuration">
            <xsl:with-param name="indexes" select="substring-after($indexes, ' ')" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$headDuration + $tailDuration" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="beat" select="key('beats', $indexes)" />
        <xsl:variable name="rhythm" select="key('rhythms', $beat/Rhythm/@ref)" />
        <xsl:call-template name="RhythmDuration">
          <xsl:with-param name="rhythm" select="$rhythm" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="Voice">
    <xsl:param name="id" select="0" />
    <!-- the number of voice in a measure -->
    <xsl:param name="num" select="0" />
    <xsl:param name="arg1" select="0" />
    <xsl:param name="arg2" select="0" />
    <xsl:param name="arg3" select="0" />
    <xsl:if test="$id != -1">
      <xsl:variable name="voice" select="key('voices', $id)" />
      <xsl:variable name="strings" select="$arg1" />
      <xsl:variable name="tuning" select="$arg2" />
      <xsl:variable name="track" select="$arg3" />
      <!-- beats in the voice -->
      <xsl:call-template name="IndexIterator">
        <xsl:with-param name="indexes" select="$voice/Beats" />
        <xsl:with-param name="template" select="'Beat'" />
        <xsl:with-param name="arg1" select="$num" />
        <xsl:with-param name="arg2" select="$strings" />
        <xsl:with-param name="arg3" select="$tuning" />
        <xsl:with-param name="arg4" select="$track" />
      </xsl:call-template>
      <!-- backup at the end of the voice -->
      <xsl:variable name="voiceDuration">
        <xsl:call-template name="VoiceDuration">
          <xsl:with-param name="indexes" select="$voice/Beats" />
        </xsl:call-template>
      </xsl:variable>
      <backup>
        <duration>
          <xsl:value-of select="$voiceDuration" />
        </duration>
      </backup>
    </xsl:if>
  </xsl:template>
  <xsl:template name="QuarterTempo">
    <xsl:param name="value" select="120" />
    <xsl:param name="unit" select="2" />
    <xsl:choose>
      <xsl:when test="$unit = 1">
        <xsl:value-of select="$value * 2" />
      </xsl:when>
      <xsl:when test="$unit = 2">
        <xsl:value-of select="$value" />
      </xsl:when>
      <xsl:when test="$unit = 3">
        <xsl:value-of select="$value * 0.67" />
      </xsl:when>
      <xsl:when test="$unit = 4">
        <xsl:value-of select="$value * 0.50" />
      </xsl:when>
      <xsl:when test="$unit = 5">
        <xsl:value-of select="$value * 0.33" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="BarStaff">
    <xsl:param name="id" select="0" />
    <!-- the number of track -->
    <xsl:param name="num" select="0" />
    <xsl:param name="arg1" select="0" />
    <xsl:param name="arg2" select="0" />
    <xsl:param name="arg3" select="0" />
    <xsl:variable name="masterBarNum" select="$arg1" />
    <xsl:variable name="masterBar" select="$arg2" />
    <xsl:variable name="trackId" select="$arg3" />
    <xsl:variable name="bar" select="key('bars', $id)" />
    <xsl:if test="$trackId = $bar/Track">
      <xsl:variable name="track" select="/GPIF/Tracks/Track[@id = $trackId]" />
      <xsl:variable name="tuning" select="$track/Properties/Property[@name = 'Tuning']" />
      <xsl:variable name="strings">
        <xsl:choose>
          <xsl:when test="$tuning">
            <xsl:call-template name="CountIndexes">
              <xsl:with-param name="indexes" select="$tuning/Pitches" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$tuning">
          <clef>
            <sign>TAB</sign>
            <line>
              <xsl:value-of select="$strings" />
            </line>
          </clef>
          <staff-details>
            <staff-lines>
              <xsl:value-of select="$strings" />
            </staff-lines>
            <xsl:call-template name="IndexIterator">
              <xsl:with-param name="indexes" select="$tuning/Pitches" />
              <xsl:with-param name="template" select="'Tuning'" />
            </xsl:call-template>
          </staff-details>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="clef" select="$bar/Clef" />
          <clef>
            <xsl:choose>
              <xsl:when test="$clef = 'G2'">
                <sign>G</sign>
                <line>2</line>
              </xsl:when>
              <xsl:when test="$clef = 'F4'">
                <sign>F</sign>
                <line>4</line>
              </xsl:when>
              <xsl:when test="$clef = 'C3'">
                <sign>C</sign>
                <line>3</line>
              </xsl:when>
              <xsl:when test="$clef = 'C4'">
                <sign>C</sign>
                <line>4</line>
              </xsl:when>
              <xsl:when test="$clef = 'Neutral'">
                <sign>percussion</sign>
              </xsl:when>
            </xsl:choose>
          </clef>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template name="BarVoice">
    <xsl:param name="id" select="0" />
    <!-- the number of track -->
    <xsl:param name="num" select="0" />
    <xsl:param name="arg1" select="0" />
    <xsl:param name="arg2" select="0" />
    <xsl:param name="arg3" select="0" />
    <xsl:variable name="masterBarNum" select="$arg1" />
    <xsl:variable name="masterBar" select="$arg2" />
    <xsl:variable name="trackId" select="$arg3" />
    <xsl:variable name="bar" select="key('bars', $id)" />
    <xsl:if test="$trackId = $bar/Track">
      <xsl:variable name="track" select="/GPIF/Tracks/Track[@id = $trackId]" />
      <xsl:variable name="tuning" select="$track/Properties/Property[@name = 'Tuning']" />
      <xsl:variable name="strings">
        <xsl:choose>
          <xsl:when test="$tuning">
            <xsl:call-template name="CountIndexes">
              <xsl:with-param name="indexes" select="$tuning/Pitches" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- voices in the bar -->
      <xsl:call-template name="IndexIterator">
        <xsl:with-param name="indexes" select="$bar/Voices" />
        <xsl:with-param name="template" select="'Voice'" />
        <xsl:with-param name="arg1" select="$strings" />
        <xsl:with-param name="arg2" select="$tuning" />
        <xsl:with-param name="arg3" select="$track" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- Root node -->
  <xsl:template match="GPIF">
    <!--score-partwise xsi:noNamespaceSchemaLocation="file:musicxml.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"-->
		<score-partwise>
      <xsl:if test="Score/Album and Score/Album != ''">
        <work>
          <work-title>
            <xsl:value-of select="Score/Album" />
          </work-title>
        </work>
      </xsl:if>
      <movement-title>
        <xsl:value-of select="Score/Title" />
      </movement-title>
      <identification>
        <creator type="composer">
          <xsl:value-of select="Score/Music" />
        </creator>
        <creator type="lyricist">
          <xsl:value-of select="Score/Words" />
        </creator>
        <creator type="artist">
          <xsl:value-of select="Score/Artist" />
        </creator>
        <creator type="tabber">
          <xsl:value-of select="Score/Tabber" />
        </creator>
        <rights>
          <xsl:value-of select="Score/Copyright" />
        </rights>
        <encoding>
          <software>Guitar Pro</software>
        </encoding>
        <miscellaneous>
          <miscellaneous-field name="subtitle">
            <xsl:value-of select="Score/Subtitle" />
          </miscellaneous-field>
          <miscellaneous-field name="instructions">
            <xsl:value-of select="Score/Instructions" />
          </miscellaneous-field>
        </miscellaneous>
      </identification>
      <!--credit page="1">
        <credit-words justify="center" valign="top">
          <xsl:value-of select="Score/FirstPageHeader" />
        </credit-words>
        <credit-words justify="center" valign="bottom">
          <xsl:value-of select="Score/FirstPageFooter" />
        </credit-words>
      </credit>
      <credit>
        <credit-words justify="center" valign="top">
          <xsl:value-of select="Score/PageHeader" />
        </credit-words>
        <credit-words justify="center" valign="bottom">
          <xsl:value-of select="Score/PageFooter" />
        </credit-words>
      </credit-->
      <part-list>
        <xsl:for-each select="Tracks/Track">
          <score-part id="p{@id}">
            <part-name>
              <xsl:value-of select="Name" />
            </part-name>
            <part-abbreviation>
              <xsl:value-of select="ShortName" />
            </part-abbreviation>
            <score-instrument id="i{@id}">
              <instrument-name>
                <xsl:value-of select="Name" />
              </instrument-name>
            </score-instrument>
            <midi-instrument id="i{@id}">
              <midi-channel>
                <xsl:value-of select="GeneralMidi/PrimaryChannel + 1" />
              </midi-channel>
              <midi-program>
                <xsl:value-of select="GeneralMidi/Program + 1" />
              </midi-program>
              <volume>
                <xsl:value-of select="round(0.5 * 100 div 255)" />
              </volume>
              <pan>
                <xsl:value-of select="round(0.5 * 180 div 255 - 90)" />
              </pan>
            </midi-instrument>
          </score-part>
        </xsl:for-each>
      </part-list>
      <xsl:for-each select="/GPIF/Tracks/Track">
				<xsl:variable name="track" select="." />
        <xsl:variable name="partId" select="concat('p', @id)" />
        <part>
          <xsl:attribute name="id">
            <xsl:value-of select="$partId" />
          </xsl:attribute>
          <xsl:for-each select="/GPIF/MasterBars/MasterBar">
            <xsl:variable name="masterBar" select="." />
            <xsl:variable name="measureNumber" select="position()" />
            <measure>
              <xsl:attribute name="number">
                <xsl:value-of select="$measureNumber" />
              </xsl:attribute>
              <attributes>
                <divisions>
                  <xsl:value-of select="$DIVISIONS" />
                </divisions>
                <xsl:if test="$masterBar/Key">
                  <key>
                    <fifths>
                      <xsl:value-of select="$masterBar/Key/AccidentalCount" />
                    </fifths>
                    <mode>
                      <xsl:value-of select="translate($masterBar/Key/Mode, 'M', 'm')" />
                    </mode>
                  </key>
                </xsl:if>
                <xsl:if test="$masterBar/Time">
                  <time>
                    <beats>
                      <xsl:value-of select="substring-before($masterBar/Time, '/')" />
                    </beats>
                    <beat-type>
                      <xsl:value-of select="substring-after($masterBar/Time, '/')" />
                    </beat-type>
                  </time>
                </xsl:if>
                <staves>
                  <xsl:value-of select="$track/StaffCount" />
                </staves>
                <xsl:call-template name="IndexIterator">
                  <xsl:with-param name="indexes" select="$masterBar/Bars" />
                  <xsl:with-param name="template" select="'BarStaff'" />
                  <xsl:with-param name="arg1" select="$measureNumber" />
                  <xsl:with-param name="arg2" select="$masterBar" />
                  <xsl:with-param name="arg3" select="$track/@id" />
                </xsl:call-template>
              </attributes>
              <xsl:variable name="tempoAuto" select="/GPIF/MasterTrack/Automations/Automation[Type = 'Tempo'][1]" />
              <xsl:if test="$measureNumber = 0">
                <direction placement="above" directive="yes">
                  <direction-type>
                    <words>
                      <xsl:value-of select="concat($tempoAuto/Text, ' ')" />
                    </words>
                  </direction-type>
                  <direction-type>
                    <metronome>
                      <beat-unit>quarter</beat-unit>
                      <per-minute>
                        <xsl:call-template name="QuarterTempo">
                          <xsl:with-param name="value" select="substring-before($tempoAuto/Value,' ')" />
                          <xsl:with-param name="unit" select="substring-after($tempoAuto/Value,' ')" />
                        </xsl:call-template>
                      </per-minute>
                    </metronome>
                  </direction-type>
                  <sound>
                    <xsl:attribute name="tempo">
                      <xsl:call-template name="QuarterTempo">
                        <xsl:with-param name="value" select="substring-before($tempoAuto/Value,' ')" />
                        <xsl:with-param name="unit" select="substring-after($tempoAuto/Value,' ')" />
                      </xsl:call-template>
                    </xsl:attribute>
                  </sound>
                </direction>
              </xsl:if>
              <xsl:if test="$measureNumber = 0 and $masterBar/Section">
                <direction placement="above">
                  <direction-type>
                    <words>
                      <xsl:value-of select="$masterBar/Section/Text" />
                    </words>
                  </direction-type>
                </direction>
              </xsl:if>
              <xsl:if test="$masterBar/Directions/Target">
                <xsl:variable name="target" select="$masterBar/Directions/Target" />
                <direction placement="above">
                  <direction-type>
                    <xsl:choose>
                      <xsl:when test="$target = 'Coda'">
                        <coda />
                      </xsl:when>
                      <xsl:when test="$target = 'DoubleCoda'">
                        <coda />
                        <coda />
                      </xsl:when>
                      <xsl:when test="$target = 'Segno'">
                        <segno />
                      </xsl:when>
                      <xsl:when test="$target = 'SegnoSegno'">
                        <segno />
                        <segno />
                      </xsl:when>
                      <xsl:when test="$target = 'Fine'">
                        <words font-style="italic">fine</words>
                      </xsl:when>
                    </xsl:choose>
                  </direction-type>
                  <xsl:choose>
                    <xsl:when test="contains($target, 'Coda')">
                      <sound coda="{$target}" />
                    </xsl:when>
                    <xsl:when test="contains($target, 'Segno')">
                      <sound segno="{$target}" />
                    </xsl:when>
                  </xsl:choose>
                </direction>
              </xsl:if>
              <xsl:if test="$masterBar/Repeat[@start = 'true']">
                <barline location="left">
                  <bar-style>heavy-light</bar-style>
                  <repeat direction="forward" />
                </barline>
              </xsl:if>
              <xsl:if test="$masterBar/AlternateEndings">
                <barline location="left">
                  <ending type="discontinue" number="{translate($masterBar/AlternateEndings, ' ', ',')}" />
                </barline>
              </xsl:if>
              <xsl:call-template name="IndexIterator">
                <xsl:with-param name="indexes" select="$masterBar/Bars" />
                <xsl:with-param name="template" select="'BarVoice'" />
                <xsl:with-param name="arg1" select="$measureNumber" />
                <xsl:with-param name="arg2" select="$masterBar" />
                <xsl:with-param name="arg3" select="$track/@id" />
              </xsl:call-template>
              <xsl:choose>
                <xsl:when test="$masterBar/Repeat[@end = 'true']">
                  <barline location="right">
                    <bar-style>light-heavy</bar-style>
                    <repeat direction="backward" times="{$masterBar/Repeat/@count}" />
                  </barline>
                </xsl:when>
                <xsl:when test="$masterBar/DoubleBar">
                  <barline location="right">
                    <bar-style>light-light</bar-style>
                  </barline>
                </xsl:when>
              </xsl:choose>
              <xsl:if test="$masterBar/Directions/Jump">
                <xsl:variable name="jump" select="$masterBar/Directions/Jump" />
                <direction placement="above">
                  <direction-type>
                    <words font-style="italic" relative-x="80">
                      <xsl:choose>
                        <xsl:when test="$jump = 'DaCapo'">Da Capo</xsl:when>
                        <xsl:when test="$jump = 'DaCapoAlCoda'">D.C. al Coda</xsl:when>
                        <xsl:when test="$jump = 'DaCapoAlDoubleCoda'">D.C. al Double Coda</xsl:when>
                        <xsl:when test="$jump = 'DaCapoAlFine'">D.C. al Fine</xsl:when>
                        <xsl:when test="$jump = 'DaSegno'">Da Segno</xsl:when>
                        <xsl:when test="$jump = 'DaSegnoAlCoda'">D.S. al Coda</xsl:when>
                        <xsl:when test="$jump = 'DaSegnoAlDoubleCoda'">D.S. al Double Coda</xsl:when>
                        <xsl:when test="$jump = 'DaSegnoAlFine'">D.S. al Fine</xsl:when>
                        <xsl:when test="$jump = 'DaSegnoSegno'">Da Segno Segno</xsl:when>
                        <xsl:when test="$jump = 'DaSegnoSegnoAlCoda'">D.S.S. al Coda</xsl:when>
                        <xsl:when test="$jump = 'DaSegnoSegnoAlDoubleCoda'">D.S.S. al Double Coda</xsl:when>
                        <xsl:when test="$jump = 'DaSegnoSegnoAlFine'">D.S.S. al Fine</xsl:when>
                        <xsl:when test="$jump = 'DaCoda'">Da Coda</xsl:when>
                        <xsl:when test="$jump = 'DaDoubleCoda'">Da Double Coda</xsl:when>
                      </xsl:choose>
                    </words>
                  </direction-type>
                  <xsl:choose>
                    <xsl:when test="contains($jump, 'DaCapo')">
                      <sound dacapo="yes" />
                    </xsl:when>
                    <xsl:when test="contains($jump, 'DaSegnoSegno')">
                      <sound dalsegno="SegnoSegno" />
                    </xsl:when>
                    <xsl:when test="contains($jump, 'DaSegno')">
                      <sound dalsegno="Segno" />
                    </xsl:when>
                    <xsl:when test="$jump = 'DaCoda'">
                      <sound tocoda="Coda" />
                    </xsl:when>
                    <xsl:when test="$jump = 'DaDoubleCoda'">
                      <sound tocoda="DoubleCoda" />
                    </xsl:when>
                  </xsl:choose>
                </direction>
              </xsl:if>
            </measure>
          </xsl:for-each>
        </part>
      </xsl:for-each>
    </score-partwise>
  </xsl:template>
</xsl:stylesheet>
