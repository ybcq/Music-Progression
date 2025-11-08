<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:param name="trackId" select="0"/>

  <xsl:variable name="endl" select="'&#13;&#10;'"/>

  <xsl:key name="bars" match="/GPIF/Bars/Bar" use="@id"/>
  <xsl:key name="voices" match="/GPIF/Voices/Voice" use="@id"/>
  <xsl:key name="beats" match="/GPIF/Beats/Beat" use="@id"/>
  <xsl:key name="notes" match="/GPIF/Notes/Note" use="@id"/>
  <xsl:key name="rhythms" match="/GPIF/Rhythms/Rhythm" use="@id"/>

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

  <xsl:template name="ReduceIndexes">
    <xsl:param name="indexes" select="'0'"/>
    <xsl:param name="template" select="''"/>
    <xsl:param name="initial" select="0"/>
    <xsl:param name="arg1" select="0"/>
    <xsl:variable name="result">
      <xsl:choose>
        <xsl:when test="contains($indexes, ' ')">
          <xsl:call-template name="ReduceIndexes">
            <xsl:with-param name="indexes" select="substring-after($indexes, ' ')"/>
            <xsl:with-param name="template" select="$template"/>
            <xsl:with-param name="initial" select="$initial"/>
            <xsl:with-param name="arg1" select="$arg1"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$initial"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="item">
      <xsl:choose>
        <xsl:when test="contains($indexes, ' ')">
          <xsl:value-of select="substring-before($indexes, ' ')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$indexes"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$template = 'RhythmTupletNumMultiply'">
        <xsl:call-template name="RhythmTupletNumMultiply">
          <xsl:with-param name="item" select="$item"/>
          <xsl:with-param name="result" select="$result"/>
          <xsl:with-param name="arg1" select="$arg1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$template = 'RhythmDurationsGCD'">
        <xsl:call-template name="RhythmDurationsGCD">
          <xsl:with-param name="item" select="$item"/>
          <xsl:with-param name="result" select="$result"/>
          <xsl:with-param name="arg1" select="$arg1"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="RhythmTupletNumMultiply">
    <xsl:param name="item" select="0"/>
    <xsl:param name="result" select="0"/>
    <xsl:variable name="beat" select="key('beats', $item)"/>
    <xsl:variable name="rhythm" select="key('rhythms', $beat/Rhythm/@ref)"/>
    <xsl:variable name="num">
      <xsl:choose>
        <xsl:when test="$rhythm/PrimaryTuplet">
          <xsl:value-of select="$rhythm/PrimaryTuplet/@num"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$result * $num"/>
  </xsl:template>

  <xsl:template name="IndexValue">
    <xsl:param name="indexes" select="'0'"/>
    <xsl:param name="num" select="0"/>
    <xsl:choose>
      <xsl:when test="$num = 0">
        <xsl:choose>
          <xsl:when test="contains($indexes, ' ')">
            <xsl:value-of select="substring-before($indexes, ' ')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$indexes"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="IndexValue">
          <xsl:with-param name="indexes" select="substring-after($indexes, ' ')"/>
          <xsl:with-param name="num" select="$num - 1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="IndexIterator">
    <xsl:param name="indexes" select="''"/>
    <xsl:param name="template" select="''"/>
    <xsl:param name="num" select="0"/>
    <xsl:param name="backward" select="false()"/>
    <xsl:param name="arg1" select="0"/>
    <xsl:param name="arg2" select="0"/>
    <xsl:param name="arg3" select="0"/>
    <xsl:param name="arg4" select="0"/>
    <xsl:choose>
      <xsl:when test="contains($indexes, ' ')">
        <xsl:variable name="part1">
          <xsl:choose>
            <xsl:when test="$backward">
              <xsl:value-of select="substring-after($indexes, ' ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-before($indexes, ' ')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="part2">
          <xsl:choose>
            <xsl:when test="$backward">
              <xsl:value-of select="substring-before($indexes, ' ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-after($indexes, ' ')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="IndexIterator">
          <xsl:with-param name="indexes" select="$part1"/>
          <xsl:with-param name="template" select="$template"/>
          <xsl:with-param name="num" select="$num + number($backward)"/>
          <xsl:with-param name="backward" select="$backward"/>
          <xsl:with-param name="arg1" select="$arg1"/>
          <xsl:with-param name="arg2" select="$arg2"/>
          <xsl:with-param name="arg3" select="$arg3"/>
          <xsl:with-param name="arg4" select="$arg4"/>
        </xsl:call-template>
        <xsl:call-template name="IndexIterator">
          <xsl:with-param name="indexes" select="$part2"/>
          <xsl:with-param name="template" select="$template"/>
          <xsl:with-param name="num" select="$num + number(not($backward))"/>
          <xsl:with-param name="backward" select="$backward"/>
          <xsl:with-param name="arg1" select="$arg1"/>
          <xsl:with-param name="arg2" select="$arg2"/>
          <xsl:with-param name="arg3" select="$arg3"/>
          <xsl:with-param name="arg4" select="$arg4"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$template = 'StringLine'">
            <xsl:call-template name="StringLine">
              <xsl:with-param name="id" select="$indexes"/>
              <xsl:with-param name="num" select="$num"/>
              <xsl:with-param name="arg1" select="$arg1"/>
              <xsl:with-param name="arg2" select="$arg2"/>
              <xsl:with-param name="arg3" select="$arg3"/>
              <xsl:with-param name="arg4" select="$arg4"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$template = 'Voice'">
            <xsl:call-template name="Voice">
              <xsl:with-param name="id" select="$indexes"/>
              <xsl:with-param name="num" select="$num"/>
              <xsl:with-param name="arg1" select="$arg1"/>
              <xsl:with-param name="arg2" select="$arg2"/>
              <xsl:with-param name="arg3" select="$arg3"/>
              <xsl:with-param name="arg4" select="$arg4"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$template = 'Beat'">
            <xsl:call-template name="Beat">
              <xsl:with-param name="id" select="$indexes"/>
              <xsl:with-param name="num" select="$num"/>
              <xsl:with-param name="arg1" select="$arg1"/>
              <xsl:with-param name="arg2" select="$arg2"/>
              <xsl:with-param name="arg3" select="$arg3"/>
              <xsl:with-param name="arg4" select="$arg4"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$template = 'Note'">
            <xsl:call-template name="Note">
              <xsl:with-param name="id" select="$indexes"/>
              <xsl:with-param name="num" select="$num"/>
              <xsl:with-param name="arg1" select="$arg1"/>
              <xsl:with-param name="arg2" select="$arg2"/>
              <xsl:with-param name="arg3" select="$arg3"/>
              <xsl:with-param name="arg4" select="$arg4"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="GCD">
    <xsl:param name="a" select="1"/>
    <xsl:param name="b" select="1"/>
    <xsl:choose>
      <xsl:when test="$b = 0">
        <xsl:value-of select="$a"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="GCD">
          <xsl:with-param name="a" select="$b"/>
          <xsl:with-param name="b" select="$a mod $b"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="PitchStep">
    <xsl:param name="pitch" select="0"/>
    <xsl:variable name="note" select="$pitch mod 12"/>
    <xsl:choose>
      <xsl:when test="$note = 0">C </xsl:when>
      <xsl:when test="$note = 1">C#</xsl:when>
      <xsl:when test="$note = 2">D </xsl:when>
      <xsl:when test="$note = 3">D#</xsl:when>
      <xsl:when test="$note = 4">E </xsl:when>
      <xsl:when test="$note = 5">F </xsl:when>
      <xsl:when test="$note = 6">F#</xsl:when>
      <xsl:when test="$note = 7">G </xsl:when>
      <xsl:when test="$note = 8">G#</xsl:when>
      <xsl:when test="$note = 9">A </xsl:when>
      <xsl:when test="$note = 10">A#</xsl:when>
      <xsl:when test="$note = 11">B </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="RhythmDuration">
    <xsl:param name="rhythm" select="0"/>
    <xsl:param name="divisions" select="1024"/>
    <xsl:variable name="noteValue" select="$rhythm/NoteValue"/>
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
    <xsl:variable name="duration" select="$divisions * $noteDuration * $dottedNoteCoef"/>
    <xsl:choose>
      <xsl:when test="$rhythm/PrimaryTuplet">
        <xsl:value-of select="round($duration * $rhythm/PrimaryTuplet/@den div $rhythm/PrimaryTuplet/@num)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="round($duration)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="RhythmDurationsGCD">
    <xsl:param name="item" select="0"/>
    <xsl:param name="result" select="0"/>
    <xsl:param name="arg1" select="0"/>
    <xsl:variable name="divisions" select="$arg1"/>
    <xsl:variable name="beat" select="key('beats', $item)"/>
    <xsl:variable name="rhythm" select="key('rhythms', $beat/Rhythm/@ref)"/>
    <xsl:variable name="duration">
      <xsl:call-template name="RhythmDuration">
        <xsl:with-param name="rhythm" select="$rhythm"/>
        <xsl:with-param name="divisions" select="$divisions"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="GCD">
      <xsl:with-param name="a" select="$result"/>
      <xsl:with-param name="b" select="$duration"/>
    </xsl:call-template>
  </xsl:template>
    
  <xsl:template name="bit">
    <xsl:param name="num" select="0"/>
    <xsl:param name="bit" select="1"/>
    <xsl:choose>
      <xsl:when test="($num mod($bit * 2)) - ($num mod($bit))">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="Note">
    <xsl:param name="id" select="0"/>
    <xsl:param name="num" select="0"/>
    <xsl:param name="arg1" select="0"/>
    
    <xsl:variable name="string" select="$arg1"/>
    <xsl:variable name="note" select="key('notes', $id)"/>
    
    <xsl:if test="(not($note/Properties/Property[@name = 'String']) and $string = 0)
            or ($note/Properties/Property[@name = 'String']/String = $string)">
      <xsl:variable name="fret" select="$note/Properties/Property[@name = 'Fret']/Fret"/>
      <xsl:choose>
        <xsl:when test="$note/Properties/Property[@name = 'Muted']">x</xsl:when>
        <xsl:when test="$fret"><xsl:value-of select="$fret"/></xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="staccato">
        <xsl:call-template name="bit">
            <xsl:with-param name="num" select="$note/Accent" />
            <xsl:with-param name="bit" select="1" />
		</xsl:call-template>  
	  </xsl:variable>
      <xsl:variable name="accented">
        <xsl:call-template name="bit">
            <xsl:with-param name="num" select="$note/Accent" />
            <xsl:with-param name="bit" select="8" />
		</xsl:call-template>  
	  </xsl:variable>
      <!-- effects -->
      <xsl:choose>
        <xsl:when test="$note/Tie/@origin = 'true'">L</xsl:when>
        <xsl:when test="$note/Vibrato">~</xsl:when>
        <xsl:when test="$note/AntiAccent = 'Normal'">g</xsl:when>
        <xsl:when test="$staccato = 1">.</xsl:when>
        <xsl:when test="$accented = 1">&gt;</xsl:when>
        <xsl:when test="$note/Trill">t</xsl:when>
        <xsl:when test="$note/Properties/Property[@name = 'HopoOrigin']">h</xsl:when>
        <xsl:when test="$note/Properties/Property[@name = 'Bended']">b</xsl:when>
        <xsl:when test="$note/Properties/Property[@name = 'Slide']">s</xsl:when>        
        <!--xsl:when test="$note/Properties/Property[@name = 'Tapped']">+</xsl:when-->        
        <xsl:when test="$note/Properties/Property[@name = 'PalmMuted']">M</xsl:when>        
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="Beat">
    <xsl:param name="id" select="0"/>
    <xsl:param name="num" select="0"/>
    <xsl:param name="arg1" select="0"/>
    <xsl:param name="arg2" select="0"/>
    <xsl:param name="arg3" select="0"/>
    
    <xsl:variable name="beat" select="key('beats', $id)"/>
    <xsl:variable name="string" select="$arg1"/>
    <xsl:variable name="divisions" select="$arg2"/>
    <xsl:variable name="gcd" select="$arg3"/>
    <xsl:variable name="rhythm" select="key('rhythms', $beat/Rhythm/@ref)"/>
    <xsl:variable name="duration">
      <xsl:call-template name="RhythmDuration">
        <xsl:with-param name="rhythm" select="$rhythm"/>
        <xsl:with-param name="divisions" select="$divisions"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="width" select="$duration div $gcd"/>

    <xsl:choose>
      <!-- beat effects above the strings -->
      <xsl:when test="$string = -1">
        <xsl:variable name="effect">
          <xsl:choose>
            <xsl:when test="$beat/Fadding = 'FadeIn'">&lt;</xsl:when>
            <xsl:when test="$beat/Fadding = 'FadeOut'">&gt;</xsl:when>
            <xsl:when test="$beat/Tremolo">=</xsl:when>
            <xsl:when test="$beat/Properties/Property[@name = 'Slapped']">S</xsl:when>
            <xsl:when test="$beat/Properties/Property[@name = 'Popped']">P</xsl:when>
            <!--xsl:when test="$beat/Properties/Property[@name = 'Tapped']">+</xsl:when-->
            <xsl:when test="$beat/Properties/Property[@name = 'VibratoWTremBar']">W</xsl:when>
            <xsl:when test="$beat/Properties/Property[@name = 'WhammyBar']">w</xsl:when>
            <xsl:when test="$beat/Properties/Property[@name = 'Brush']/Direction = 'Up'">v</xsl:when>
            <xsl:when test="$beat/Properties/Property[@name = 'Brush']/Direction = 'Down'">^</xsl:when>
            <xsl:when test="$beat/Properties/Property[@name = 'PickStroke']/Direction = 'Up'">V</xsl:when>
            <xsl:when test="$beat/Properties/Property[@name = 'PickStroke']/Direction = 'Down'">n</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <!-- print effect -->
        <xsl:value-of select="$effect"/>
        <!-- pad -->
        <xsl:call-template name="RepeatString">
          <xsl:with-param name="str" select="' '"/>
          <xsl:with-param name="repeat" select="$width * 3 - string-length($effect)"/>
        </xsl:call-template>
      </xsl:when>
      <!-- beat notes on the string -->
      <xsl:otherwise>
        <xsl:variable name="note">
          <xsl:if test="string-length($beat/Notes) &gt; 0">
            <xsl:call-template name="IndexIterator">
              <xsl:with-param name="indexes" select="$beat/Notes"/>
              <xsl:with-param name="arg1" select="$string"/>
              <xsl:with-param name="template" select="'Note'"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:variable>
        <!-- print note -->
        <xsl:value-of select="$note"/>
        <!-- pad -->
        <xsl:call-template name="RepeatString">
          <xsl:with-param name="str" select="'-'"/>
          <xsl:with-param name="repeat" select="$width * 3 - string-length($note)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="Voice">
    <xsl:param name="id" select="0"/>
    <xsl:param name="arg1" select="0"/>
    <xsl:if test="$id != -1">
      <xsl:variable name="voice" select="key('voices', $id)"/>
      <xsl:variable name="divisions">
        <xsl:call-template name="ReduceIndexes">
          <xsl:with-param name="indexes" select="$voice/Beats"/>
          <xsl:with-param name="template" select="'RhythmTupletNumMultiply'"/>
          <xsl:with-param name="initial" select="1024"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:variable name="gcd">
        <xsl:call-template name="ReduceIndexes">
          <xsl:with-param name="indexes" select="$voice/Beats"/>
          <xsl:with-param name="template" select="'RhythmDurationsGCD'"/>
          <xsl:with-param name="arg1" select="$divisions"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="IndexIterator">
        <xsl:with-param name="indexes" select="$voice/Beats"/>
        <xsl:with-param name="template" select="'Beat'"/>
        <xsl:with-param name="arg1" select="$arg1"/>
        <xsl:with-param name="arg2" select="$divisions"/>
        <xsl:with-param name="arg3" select="$gcd"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="StringLine">
    <xsl:param name="id" select="0"/>
    <xsl:param name="num" select="0"/>
    <xsl:param name="arg1" select="0"/>
    
    <xsl:variable name="strings" select="$arg1"/>
    <xsl:variable name="middle" select="($num &lt;= round($strings div 2))
                  and ($num &gt;= round($strings div 2) - 1)"/>
    
    <!-- text line -->
    <xsl:if test="$num = $strings - 1">
      <xsl:text>  </xsl:text>
      <xsl:for-each select="MasterBars/MasterBar">
        <xsl:text>   </xsl:text>
        <xsl:variable name="barId">
          <xsl:call-template name="IndexValue">
            <xsl:with-param name="indexes" select="Bars"/>
            <xsl:with-param name="num" select="$trackId"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="bar" select="key('bars', $barId)"/>
        <xsl:variable name="voiceId">
          <xsl:call-template name="IndexValue">
            <xsl:with-param name="indexes" select="$bar/Voices"/>
            <xsl:with-param name="num" select="0"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="Voice">
          <xsl:with-param name="id" select="$voiceId"/>
          <xsl:with-param name="arg1" select="-1"/>
        </xsl:call-template>
        <xsl:text>  </xsl:text>
      </xsl:for-each>
      <xsl:value-of select="$endl"/>
    </xsl:if>

    <!-- string lines -->
    <xsl:call-template name="PitchStep">
      <xsl:with-param name="pitch" select="$id"/>
    </xsl:call-template>
    <xsl:for-each select="MasterBars/MasterBar">
      <xsl:choose>
        <xsl:when test="$middle and Repeat/@start = 'true'">||o</xsl:when>
        <xsl:when test="Repeat/@start = 'true'">||-</xsl:when>
        <xsl:otherwise>|--</xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="barId">
        <xsl:call-template name="IndexValue">
          <xsl:with-param name="indexes" select="Bars"/>
          <xsl:with-param name="num" select="$trackId"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="bar" select="key('bars', $barId)"/>
      <xsl:call-template name="IndexIterator">
        <xsl:with-param name="indexes" select="$bar/Voices"/>
        <xsl:with-param name="arg1" select="$num"/>
        <xsl:with-param name="template" select="'Voice'"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="$middle and Repeat/@end = 'true'">o|</xsl:when>
        <xsl:when test="Repeat/@end = 'true'">-|</xsl:when>
        <xsl:otherwise>--</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:value-of select="concat('||', $endl)"/>
  </xsl:template>

  <xsl:template name="Header">
    <xsl:param name="header" select="."/>
    <xsl:if test="string-length($header) != 0">
      <xsl:value-of select="name($header)"/>: <xsl:value-of select="$header"/><xsl:value-of select="$endl"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="QuarterTempo">
    <xsl:param name="value" select="120" />  
    <xsl:param name="unit" select="2" />    
    <xsl:choose>
        <xsl:when test="$unit = 1"><xsl:value-of select="$value * 2" /></xsl:when>
        <xsl:when test="$unit = 2"><xsl:value-of select="$value" /></xsl:when>
        <xsl:when test="$unit = 3"><xsl:value-of select="$value * 0.67" /></xsl:when>
        <xsl:when test="$unit = 4"><xsl:value-of select="$value * 0.50" /></xsl:when>
        <xsl:when test="$unit = 5"><xsl:value-of select="$value * 0.33" /></xsl:when>
	</xsl:choose>
  </xsl:template> 
      
  <xsl:template match="GPIF">
    <xsl:call-template name="Header">
      <xsl:with-param name="header" select="Score/Title"/>
    </xsl:call-template>
    <xsl:call-template name="Header">
      <xsl:with-param name="header" select="Score/SubTitle"/>
    </xsl:call-template>
    <xsl:call-template name="Header">
      <xsl:with-param name="header" select="Score/Artist"/>
    </xsl:call-template>
    <xsl:call-template name="Header">
      <xsl:with-param name="header" select="Score/Album"/>
    </xsl:call-template>
    <xsl:call-template name="Header">
      <xsl:with-param name="header" select="Score/Words"/>
    </xsl:call-template>
    <xsl:call-template name="Header">
      <xsl:with-param name="header" select="Score/Music"/>
    </xsl:call-template>
    <xsl:call-template name="Header">
      <xsl:with-param name="header" select="Score/Copyright"/>
    </xsl:call-template>
    <xsl:call-template name="Header">
      <xsl:with-param name="header" select="Score/Tabber"/>
    </xsl:call-template>
    <xsl:call-template name="Header">
      <xsl:with-param name="header" select="Score/Instructions"/>
    </xsl:call-template>
    <xsl:variable name="tempo">
      <xsl:call-template name="QuarterTempo">
        <xsl:with-param name="value" select="substring-before(MasterTrack/Automations/Automation[1]/Value,' ')" />
        <xsl:with-param name="unit" select="substring-after(MasterTrack/Automations/Automation[1]/Value,' ')" />
	  </xsl:call-template>
	</xsl:variable>
    <xsl:value-of select="concat('Tempo = ', $tempo, $endl)"/>
    <xsl:variable name="track" select="Tracks/Track[@id = $trackId]"/>
    <xsl:value-of select="concat($track/Name, $endl)"/>
    <xsl:value-of select="$endl"/>
    
    <xsl:text>Legend</xsl:text><xsl:value-of select="$endl"/>    
    <xsl:text>L - tied note</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>x - dead note</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>h - hammer on/pull off</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>b - bend</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>s - slide</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>~ - vibrato</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>g - ghost note</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>&gt; - accentuated note</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>t - trill</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>M - palm mute</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>. - staccato</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>P - popping (bass)</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>S - slapping (bass)</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>+ - tapping</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>W - wide vibrato</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>&lt; - fade in</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>w - whammy bar</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>= - tremolo picking</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>v - brush up</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>^ - brush down</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>V - pick stroke up</xsl:text><xsl:value-of select="$endl"/>
    <xsl:text>n - pick stroke down</xsl:text><xsl:value-of select="$endl"/>
    <xsl:value-of select="$endl"/>
    
    <xsl:variable name="tuning" select="$track/Properties/Property[@name = 'Tuning']/Pitches"/>
    <xsl:variable name="strings">
      <xsl:call-template name="CountIndexes">
        <xsl:with-param name="indexes" select="$tuning"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="IndexIterator">
      <xsl:with-param name="indexes" select="$tuning"/>
      <xsl:with-param name="template" select="'StringLine'"/>
      <xsl:with-param name="backward" select="true()"/>
      <xsl:with-param name="arg1" select="$strings"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
