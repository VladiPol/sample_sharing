--------------------------------------------------------------------------------
-- $Beschreibung:
-- Erstellen der ODS.KRDB_SCPS_CPD_KONTO Tabelle mit der Intervall-Partitionierung
--------------------------------------------------------------------------------

execute error_handling('DROP TABLE ODS.KRDB_SCPS_CPD_KONTO CASCADE CONSTRAINTS PURGE');

CREATE TABLE KRDB_SCPS_CPD_KONTO
(
  SCPS_IF                   NUMBER(15)          NOT NULL,
  SCPS_MAND_SL              VARCHAR2(3 BYTE),
  SCPS_UMSATZ_PART_IDENT    CHAR(1 BYTE)        NOT NULL,
  SCPS_UMSATZ_KEY_DATUM     DATE                NOT NULL,
  SCPS_UMSATZ_SEQUENCE_NR   NUMBER(15)          NOT NULL,
  SCPS_ZIEL_BUCH_DATUM      NUMBER(8)           NOT NULL,
  SCPS_KONTO_ID             VARCHAR2(20 BYTE),
  SCPS_MODIFIKATION_NR      NUMBER(7)           NOT NULL,
  SCPS_UMS_REFERENZ_EXT     VARCHAR2(24 BYTE),
  SCPS_PRIMANOTA_NUMMER     NUMBER(6)           NOT NULL,
  SCPS_SEGMENT_KZ           NUMBER(2)           NOT NULL,
  SCPS_ORDNUNGSBEGRIFF      NUMBER(4)           NOT NULL,
  SCPS_EINREICHER_ID        VARCHAR2(8 BYTE),
  SCPS_DATEI_NACHRICHT_ID   VARCHAR2(6 BYTE),
  SCPS_EINGABE_NAME         VARCHAR2(8 BYTE),
  SCPS_UMS_EINGABE_DATUM    NUMBER(8),
  SCPS_UMS_EINGABE_UHR      NUMBER(6),
  SCPS_UMS_EINGABE_OBG      NUMBER(4)           NOT NULL,
  SCPS_VALUTA_UMS_DATUM     NUMBER(8)           NOT NULL,
  SCPS_BUCH_TEXT_SCHLUE     NUMBER(2)           NOT NULL,
  SCPS_ZUSATZ_TEXT_SCHLUE   NUMBER(4)           NOT NULL,
  SCPS_UMSATZ_ART           NUMBER(1)           NOT NULL,
  SCPS_UMSATZ_STATUS        NUMBER(1)           NOT NULL,
  SCPS_BETRAG_STATUS        NUMBER(1)           NOT NULL,
  SCPS_POSTEN_TYP           NUMBER(1)           NOT NULL,
  SCPS_REO_STATUS           NUMBER(1)           NOT NULL,
  SCPS_VERARB_ART_S         NUMBER(1)           NOT NULL,
  SCPS_KONTO_ID_GEGEN       VARCHAR2(20 BYTE),
  SCPS_ZINS_SATZ            NUMBER(10,7),
  SCPS_ZINSEN               NUMBER(18,3),
  SCPS_VORSCHUSS_ZINSEN     NUMBER(18,3),
  SCPS_BONUS_VERAENDERUNG   NUMBER(18,3),
  SCPS_RUECK_VORAUS         NUMBER(18,3),
  SCPS_GEBUEHR              NUMBER(18,3),
  SCPS_ANZAHL_ARBEITSPOST   NUMBER(7),
  SCPS_MAPPENNUMMER         NUMBER(6),
  SCPS_KOSTENSTELLE_UMS     VARCHAR2(5 BYTE),
  SCPS_KOSTENST_ZUSATZ      VARCHAR2(4 BYTE),
  SCPS_MEHRWERTSTEUER_S     NUMBER(1)           NOT NULL,
  SCPS_LAENDER_KZ           VARCHAR2(2 BYTE),
  SCPS_SCHLUSS_DATUM        NUMBER(8),
  SCPS_SUMME_SPES_GEB       NUMBER(18,3),
  SCPS_SUMME_STEUERN        NUMBER(18,3),
  SCPS_STUECKZINS           NUMBER(18,3),
  SCPS_BRUTTO_BETR          NUMBER(18,3),
  SCPS_UR_SCHLUSS_DATUM     NUMBER(8),
  SCPS_UR_UMSATZ_REFERENZ   VARCHAR2(24 BYTE),
  SCPS_WECHS_FAEL_DATUM     NUMBER(8),
  SCPS_WECHSELNUMMER        VARCHAR2(16 BYTE),
  SCPS_SCHECK_NR_UMSATZ     VARCHAR2(16 BYTE),
  SCPS_REFERENZNUMMER       VARCHAR2(16 BYTE),
  SCPS_FILMBILD_SUCH_NR     VARCHAR2(20 BYTE),
  SCPS_DTA_LFD_NR           NUMBER(11),
  SCPS_KONTO_ID_ORIG        VARCHAR2(20 BYTE),
  SCPS_MELDUNGS_KZ          NUMBER(1)           NOT NULL,
  SCPS_URPN                 NUMBER(6)           NOT NULL,
  SCPS_URTEXT               NUMBER(2)           NOT NULL,
  SCPS_URZTXT               NUMBER(4)           NOT NULL,
  SCPS_CPD_ERFASSER         VARCHAR2(8 BYTE),
  SCPS_CPD_UMSATZSTATUS     VARCHAR2(2 BYTE),
  SCPS_FREIGABE_SCHLUE      NUMBER(1)           NOT NULL,
  SCPS_BEDIENER_BESTAET     NUMBER(1)           NOT NULL,
  SCPS_KONTROLL_SCHLUE      NUMBER(1)           NOT NULL,
  SCPS_BUCHEN_OHNE_DISPO    NUMBER(1)           NOT NULL,
  SCPS_UMSATZ_KZ_PRFREL     NUMBER(1)           NOT NULL,
  SCPS_SPARBUCH_NACHTRAG    NUMBER(1)           NOT NULL,
  SCPS_UMSATZ_BUCH_VORL     NUMBER(1)           NOT NULL,
  SCPS_UMSATZ_VZ_S          NUMBER(1)           NOT NULL,
  SCPS_UMSATZ_KAP_S         NUMBER(1)           NOT NULL,
  SCPS_BILANZ_UEBER_UNTER   NUMBER(1)           NOT NULL,
  SCPS_ANZEIGEPFLICHT_AWG   NUMBER(1)           NOT NULL,
  SCPS_KZ_ANLAGE_MAN        NUMBER(1)           NOT NULL,
  SCPS_UMS_ANLAGE_FORMAT    VARCHAR2(4 BYTE),
  SCPS_KAD_AUSZ_NR          NUMBER(5),
  SCPS_KTO_WAEHRUNG         NUMBER(3)           NOT NULL,
  SCPS_KTO_WAEHR_ART_S      CHAR(1 BYTE)        NOT NULL,
  SCPS_BETR_KTO_WAEHR       NUMBER(18,3)        NOT NULL,
  SCPS_KURS_AKT_KONTO       NUMBER(15,8),
  SCPS_KZ_NOTIERUNG_KURS    CHAR(1 BYTE)        NOT NULL,
  SCPS_GRUNDEINHEIT_KURS    NUMBER(5)           NOT NULL,
  SCPS_DENOM_ABW            NUMBER(1)           NOT NULL,
  SCPS_BIL_WAEHRUNG         NUMBER(3)           NOT NULL,
  SCPS_BETR_BIL_WAEHR       NUMBER(18,3)        NOT NULL,
  SCPS_DELTA_EINSTANDSKOST  NUMBER(18,3),
  SCPS_ERWEITERUNG_KUNDE    VARCHAR2(100 BYTE),
  SCPS_EMPF_ZPFL_KONTO      VARCHAR2(35 BYTE),
  SCPS_EMPF_ZPFL_NAME       VARCHAR2(70 BYTE),
  SCPS_ENDBEG_BANK          VARCHAR2(35 BYTE),
  SCPS_AUFTR_ZEMPF_KONTO    VARCHAR2(35 BYTE),
  SCPS_AUFTR_ZEMPF_NAME     VARCHAR2(70 BYTE),
  SCPS_ERSTB_BANK           VARCHAR2(35 BYTE),
  SCPS_AG_GESCHAEFTS_ART    NUMBER(3),
  SCPS_AG_SWIFT_MT_EIN      VARCHAR2(3 BYTE),
  SCPS_AG_SWIFT_MT_AUS      VARCHAR2(3 BYTE),
  SCPS_AG_HEADER_BANK       VARCHAR2(16 BYTE),
  SCPS_AG_REF_NR_F20        VARCHAR2(16 BYTE),
  SCPS_AG_REF_NR_F20Z       VARCHAR2(16 BYTE),
  SCPS_AG_REF_ERI_DATEN     VARCHAR2(70 BYTE),
  SCPS_VERW_ZWECK_ANZAHL    NUMBER(2)           NOT NULL,
  SCPS_VERW_ZWECK_TEXT_1    VARCHAR2(243 BYTE),
  SCPS_VERW_ZWECK_TEXT_2    VARCHAR2(135 BYTE),
  SCPS_KOK5_IF              NUMBER(15)
) 
TABLESPACE ODS_DATA
COMPRESS FOR QUERY HIGH 
PARTITION BY RANGE (SCPS_UMSATZ_KEY_DATUM) 
INTERVAL(NUMTOYMINTERVAL(1, 'YEAR'))
(
PARTITION P_1 VALUES LESS THAN (TO_DATE('2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
TABLESPACE ODS_DATA
)
NOPARALLEL
PCTFREE 0
ENABLE ROW MOVEMENT;

/*==============================================================*/
/* Table:    KRDB_SCPS_CPD_KONTO                                  */
/* Attribut: SCPS_KOK5_IF                                       */
/*           INDEX AUF PARTITIONEN                              */
/*==============================================================*/

CREATE INDEX ODS.SCPS_KOK5_FK_I ON ODS.KRDB_SCPS_CPD_KONTO
(SCPS_KOK5_IF)
LOCAL (  
  PARTITION P_1
  TABLESPACE ODS_INDX
)NOLOGGING;

CREATE INDEX ODS.SCPS_TUN1_I ON ODS.KRDB_SCPS_CPD_KONTO
(SCPS_UMSATZ_KEY_DATUM)
LOCAL (  
  PARTITION P_1
  TABLESPACE ODS_INDX
)NOLOGGING;

CREATE UNIQUE INDEX ODS.SCPS_OK_I ON ODS.KRDB_SCPS_CPD_KONTO
(SCPS_MAND_SL, SCPS_UMSATZ_PART_IDENT, SCPS_UMSATZ_KEY_DATUM, SCPS_UMSATZ_SEQUENCE_NR)
TABLESPACE ODS_INDX
NOLOGGING;

CREATE UNIQUE INDEX ODS.SCPS_PK ON ODS.KRDB_SCPS_CPD_KONTO
(SCPS_IF)
TABLESPACE ODS_INDX
NOLOGGING;

ALTER TABLE ODS.KRDB_SCPS_CPD_KONTO ADD (
  CONSTRAINT SCPS_PK
  PRIMARY KEY
  (SCPS_IF)
  USING INDEX ODS.SCPS_PK
  ENABLE NOVALIDATE);

ALTER TABLE ODS.KRDB_SCPS_CPD_KONTO ADD (
  CONSTRAINT SCPS_KOK5_FK
  FOREIGN KEY (SCPS_KOK5_IF) 
  REFERENCES ODS.KRDB_KORDOBA_KONTEN (KOK5_IF)
  ENABLE NOVALIDATE);

/*==============================================================*/
/* Table:    KRDB_SCPS_CPD_KONTO                                  */
/* DML: 		 Befuellen der Tabelle                              */
/*                                                              */
/*==============================================================*/

ALTER SESSION FORCE PARALLEL DML;

INSERT /*+ PARALLEL (X,16) */ INTO ODS.KRDB_SCPS_CPD_KONTO X
SELECT /*+ FULL (Y) PARALLEL (Y,16) */ * FROM "ODS"."KRDB_UK_TABLE_UMS" WHERE "UTU5_KONTO_ID" = '9020260800';
COMMIT;

/*==============================================================*/
/* Table:    KRDB_SCPS_CPD_KONTO                                  */
/* DDL: 		 comments der Tabelle                               */
/*                                                              */
/*==============================================================*/

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_IF IS 'Interne Nummer (künstlicher Primary Key) eines Eintrags';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMSATZ_PART_IDENT IS 'Partitionnummer Der PartitionsIndikator ist ein technisches Hilfsmittel zur physikalischen Strukturierung von Datenbank-Tabellen.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMSATZ_KEY_DATUM IS 'Umsatz: Datum, an dem der Umsatz bilanzwirksam gebucht wird.Vorweg-Umsatz: Datum, an dem der Umsatz vorgemerkt wird.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMSATZ_SEQUENCE_NR IS 'Die Sequence-Nummer ist ein technisches Hilfsmittel zur Primär-Key-Bildung. Sie ist die laufende Nummer des Umsatzes seit Beginn der Zählung (Oracle, DB2) bzw. die laufende Nummer bzgl. des aktuellen Buchungstages (Sesam).';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KONTO_ID IS 'Interne (semantik-freie) Konto-ID. Identifiziert eindeutig ein Datenobjekt Konto.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_MODIFIKATION_NR IS 'Mit Hilfe der KontoModifikationsNummer wird die chronologische Reihenfolge von konto-bezogenen Geschäftsvorfällen fest gehalten und in den Nachweis-Daten wie Umsatz, Vorweg-Umsatz, Änderungs-Satz, dokumentiert. Die ModifikationsNummer dient zudem als Update-Check-Field für das Daten-Objekt Konto.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMS_REFERENZ_EXT IS 'Die UmsatzReferenzExtern ist ein Identifikations-Merkmal, das vom Umsatz-anliefernden System optional vor gegeben werden kann. Dieses Feld entspricht weitgehend dem alten Primär-Key der LEASY-Vorweg-Umsatz-Datei (ohne BuchungsDatum).';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_PRIMANOTA_NUMMER IS 'Maschinell vergebene Primanoten-Nummern: Abstimm-Einheit, zu der der Umsatz für die buchungstägliche Salden-Abstimmung nach Soll und Haben zugeordnet ist.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_SEGMENT_KZ IS 'Zuordnung des Konto zu einer Produkt-Sparte (KK, FG, SP, etc.).';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_ORDNUNGSBEGRIFF IS 'Filial-Zuordnung des Kontos';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_EINREICHER_ID IS 'Das Feld EinreicherIdentifikation identifiziert das Umsatz-erzeugende bzw. Umsatz-anliefernde System, z.B. DTAEIN.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_DATEI_NACHRICHT_ID IS 'Das Feld DateiNachrichtID identifiziert eine Einheit von Bewegungs-Daten, z.B. eine Datei mit Umsätzen aus einem DTA-Eingangs-Band.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_EINGABE_NAME IS 'Dialog: Name des Anwenders, der den Umsatz erfasst hat.Batch: Erfassungs-/Berechtigungs-User (ext. Dialog), Umsatz-erzeugendes Programm';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMS_EINGABE_UHR IS 'Reale Uhrzeit, zu der der Umsatz erfasst oder erzeugt wurde.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMS_EINGABE_OBG IS 'Filial-Zuordnung des Umsatz-Erzeugers bzw. des Einreichers.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_BUCH_TEXT_SCHLUE IS 'Schlüssel für die Verarbeitungs-Steuerung der Umsatz-Buchung.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_ZUSATZ_TEXT_SCHLUE IS 'Ergänzungs-Schlüssel für die Verarbeitungs-Steuerung der Umsatz-Buchung';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMSATZ_ART IS 'Die UmsatzArt kennzeichnet Umsätze und Vorweg-Umsätze bzgl. ihrer (zukünftigen) Bilanz-Wirksamkeit.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMSATZ_STATUS IS 'Der UmsatzStatus kennzeichnet den aktuellen Zustand des Umsatzes.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_BETRAG_STATUS IS 'Der Betrag eines Vorweg-Umsatzes kann vorläufig (NichtFinal) sein. Es wird dann eine Wieder-Vorlage mit einem finalen Betrag erwartet.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_POSTEN_TYP IS 'Unterscheidung beim Zahlungsverkehr zwischen Auftraggeber und Empfänger. Bei Zahlungs-Aufträgen werden Auftraggeber- und Empfänger-Zahlungs-Posten typisiert.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_REO_STATUS IS 'Das Kennzeichen dient dazu, die Zulässigkeit der physikalischen Reorganisation für den Umsatz (nach der Standard-Verweilzeit) anzuzeigen.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_VERARB_ART_S IS 'Die VerarbeitungsArt kennzeichnet Umgebungs-Bedingung und Medium, die massgeblich die Umsatz-Verarbeitung beeinflussen. Neben dem herkömmlichen Dialog, Batch und Kasse werden die Medien Nachricht und OnlineInternet unterstützt.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KONTO_ID_GEGEN IS 'Interne Konto-ID eines Abrechnungs-Kontos (Fremdwährungs, Kredit)';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_ZINS_SATZ IS 'Zinssatz in Prozent';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_ZINSEN IS 'Betrag der auf den Umsatz entfallenden Zinsen (Spar, Kredit)';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_VORSCHUSS_ZINSEN IS 'Betrag der auf den Umsatz entfallenden Vorfälligkeits-Zinsen (Spar)';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_BONUS_VERAENDERUNG IS 'Betrag der auf den Umsatz entfallenden Bonus-Veränderung (Spar)';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_RUECK_VORAUS IS 'Betrag des Rückstandes / der Vorausleistung nach Buchung des aktuellen Umsatzes (Kredit)';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_GEBUEHR IS 'Nachrichtliche Information: Abgerechnete Gebühr zum Umsatz (z.B. bei Konto-Auflösung).';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_ANZAHL_ARBEITSPOST IS 'Anzahl der Einzel-Buchungen (Posten) zu einer Sammel-Buchung.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_MAPPENNUMMER IS 'Oberste Einheit des Numerierungssystems aus KORDOBA EZV  EZV-Erfassungs-Nummer für einen Belege-Stapel';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KOSTENSTELLE_UMS IS 'Kostenstelle für den Umsatz, wird im Standard nicht verarbeitet. Zuordnung des Umsatzes zu einer Kostenstelle.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KOSTENST_ZUSATZ IS 'Kategorisierung des Umsatzes nach Geschäfts-Art oder Geschäfts-Sparte';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_MEHRWERTSTEUER_S IS 'Das Feld kennzeichnet die Mehrwert-Steuer-Pflichtigkeit des Umsatzes.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_LAENDER_KZ IS 'ISO-Laender-Kennzeichen';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_SCHLUSS_DATUM IS 'Schlussdatum';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_SUMME_SPES_GEB IS 'Summe Spesen Gebühren';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_SUMME_STEUERN IS 'Summe der Steuern';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_STUECKZINS IS 'Stückzins';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_BRUTTO_BETR IS 'Bruttobetrag';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UR_SCHLUSS_DATUM IS 'Ursprüngliches Schluss-Datum';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UR_UMSATZ_REFERENZ IS 'Ursprüngliche Umsatz-Referenz';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_WECHSELNUMMER IS 'Nummer des aktuellen Wechsels';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_SCHECK_NR_UMSATZ IS '(Auslands-) Scheck-Nummer zu Umsatz';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_REFERENZNUMMER IS 'Optionale zusätzliche Referenz des Umsatzes. Dieses Feld steht in Konkurrenz zu der neuen UmsatzReferenzExtern. Es sollte möglichst nicht mehr benutzt werden. Wegen verschiedener interner Verwendungen kann das Feld noch nicht aus der neuen Struktur entfernt werden.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_FILMBILD_SUCH_NR IS 'Index einer Archivierungs-Stelle (Mikrofiche, Optisches Archiv) zu archiviertem Beleg-Gut';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_DTA_LFD_NR IS 'Referenz-Nummer aus dem DTA-Eingang bzw. für den DTA-Ausgang. Das Feld gehört zu den Bank-Internen Daten im DTA-C-Satz.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KONTO_ID_ORIG IS 'Interne Konto-ID des Original-Kontos bei CPD-Buchungen';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_MELDUNGS_KZ IS 'Das MeldungsKennzeichen wird gesetzt, wenn zu einem Umsatz Hinweis- und Fehler-Meldungen in die Meldungs-Tabelle BUKMEL geschrieben werden. Dieses Feature wird nur bei CPD-Buchungen genutzt.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_URPN IS 'Sicherung der ursprünglichen Primanota bei CPD-Buchungen und Umbuchungen';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_URTEXT IS 'Sicherung des ursprünglichen Buchungstextes bei CPD-Buchungen und Umbuchungen';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_URZTXT IS 'Sicherung des ursprünglichen Zusatztextes bei CPD-Buchungen und Umbuchungen';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_CPD_ERFASSER IS 'Aktueller Bearbeiter des vorliegenden CPD-Umsatzes';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_CPD_UMSATZSTATUS IS 'Aktueller Bearbeitungs-Status des CPD-Umsatzes';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_FREIGABE_SCHLUE IS 'Das Kennzeichen Freigabe-Schluessel unterstützt das Vier-Augen-Prinzip.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_BEDIENER_BESTAET IS 'Verarbeitungs-Kennzeichen Bediener-Bestätigung. Mit der Bediener-Bestätigung kann in bestimmten Fällen eine Umsatz-Freigabe erfolgen.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KONTROLL_SCHLUE IS 'Verarbeitungs-Kennzeichen Kontroll-Schlüssel. Der Kontroll-Schlüssel ermöglicht das Übergehen bestimmter Buchungs-Hindernisse.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_BUCHEN_OHNE_DISPO IS 'Verarbeitungs-Kennzeichen BuchenOhneDisposition. Die Buchung ist zwangsweise durch geführt worden. Dies kann dann notwendig sein, wenn der Zahlungs-Vorgang selbst bereits positiv abgeschlossen ist.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMSATZ_KZ_PRFREL IS 'Verarbeitungs-Kennzeichen Prüfungs-Relevanter-Geschäftsvorfall. Der Umsatz ist auf entsprechenden Listen gesondert auszuweisen.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_SPARBUCH_NACHTRAG IS 'Verarbeitungs-Kennzeichen Sparbuch-Nachtrag. Nachgetragene Umsätze (bei Sparformen mit Buch) werden gekennzeichnet.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMSATZ_BUCH_VORL IS 'Verarbeitungs-Kennzeichen Verfügung-Ohne-Buchvorlage. Bei Sparformen mit Buch wird damit angezeigt, dass der Zahlungs-Vorgang (an der Kasse) ohne die Vorlage des Sparbuchs erfolgte.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMSATZ_VZ_S IS 'Verarbeitungs-Kennzeichen Vorfälligkeits-Zinsfrei. Bei Verfügung von nicht gekündigten Spar-Einlagen kann die VZ-Berechnung ausgeschaltet worden sein.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMSATZ_KAP_S IS 'Verarbeitungs-Kennzeichen Kapitalisierungs-Umsatz (Ertrag). Umsätze aus Ertrags-Gutschriften/Aufwands-Belastungen zu Kunden-Konten werden gesondert gekennzeichnet.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_BILANZ_UEBER_UNTER IS 'Verarbeitungs-Kennzeichen Bilanz-Zuordnung. Die Bilanz-Wirksamkeit eines Umsatzes (Über-/Unter-Strich) wird fest gehalten.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_ANZEIGEPFLICHT_AWG IS 'Verarbeitungs-Kennzeichen zur Anzeigepflicht nach AWG. Die Anzeigepflicht eines Umsatzes nach AWG wird fest gehalten.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KZ_ANLAGE_MAN IS 'Verarbeitungs-Kennzeichen Manuelle-Anlage';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_UMS_ANLAGE_FORMAT IS 'C-Satz oder AG-Satz: Das MaschinelleAnlagenFormat gibt vor, wie die Anlagen-Felder zu interpretieren sind.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KAD_AUSZ_NR IS 'Auszug-Nr.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KTO_WAEHRUNG IS 'Kordoba-Interner Währungs-Schlüssel der Konto-Währung. Es wird die sogenannte Kurs-Nummer verwendet. Die Auftrags-Währung (Ausführungs-Währung) ist immer die Konto-Währung !';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KTO_WAEHR_ART_S IS 'Die WährungsArt ist ein Unterscheidungs-Merkmal für den Euro-Währungs-Raum.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_BETR_KTO_WAEHR IS 'Betrag des Umsatzes in der Währung des Kontos';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KURS_AKT_KONTO IS 'Liefer- und Abrechnungskurs des Umsatz-Betrages in Konto-Währung zum Umsatz-Betrag in der Währung der Rechnungslegung des Instituts (Bilanz-Währung).';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_KZ_NOTIERUNG_KURS IS 'Verarbeitungs-Kennzeichen zur Kurs-Definition';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_GRUNDEINHEIT_KURS IS 'Die Grundeinheit ist ein Basis-Betrag in der Konto-Währung (n WährungsEinheiten), auf den sich die Kurs-Angabe bezieht. Die Standard-Grundeinheit ist 1 WaehrungsEinheit. Daneben kommen üblicherweise noch 100 WE und 1000 WE vor.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_DENOM_ABW IS 'DenominationsAbweichnung';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_BIL_WAEHRUNG IS 'Abweichungs-Betrag, der sich bei Rück-Rechnung in die Denominations-Währung ergibt (Doppel-Bilanz-Währungs-Korrektur).';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_BETR_BIL_WAEHR IS 'Betrag des Umsatzes in der Rechnungslegungs-Währung des Instituts';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_DELTA_EINSTANDSKOST IS 'Errechneter Betrag aus Disposaldo und Disposaldo FW';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_ERWEITERUNG_KUNDE IS 'Platzhalter-Feld für Kunden-spezifische Erweiterungen. Die Inhalte dieses Feldes können bereits bei der Umsatz-Einreichung oder über den User-Exit MUKPAL belegt werden. Es dürfen nur abdruckbare Zeichen enthalten sein.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_EMPF_ZPFL_KONTO IS 'Zahlungs-Verkehr: Externe Konto-Darstellung .DTAC: Bankleitzahl + Konto (IBAN), AGRF: Swift-Feld F59K. Bei Empfänger-Posten müssen diese Information aus den Eingangs-Daten (DTA-C, DTAZV, Swift) in den Umsatz übernommen werden, bei Auftraggeber-Posten müssen die Informationen format-gerecht in die Ausgangs-Daten übertragen werden.';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_EMPF_ZPFL_NAME IS 'Zahlungs-Verkehr: Name des ziel-seitigen Konto-Inhabers. DTAC: Empfänger-Zahlungspflichtiger, AGRF: Swift-Feld F59N';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_ENDBEG_BANK IS 'Zahlungs-Verkehr: Name des ziel-seitigen Instituts. DTAC: Spaces, AGRF: Swift-Feld F58N';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_AG_GESCHAEFTS_ART IS 'Swift-Geschäfts-Vorfall-Code';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_AG_SWIFT_MT_EIN IS 'Swift-Message-Typ Nachrichten-Eingang';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_AG_SWIFT_MT_AUS IS 'Swift-Message-Typ Nachrichten-Ausgang';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_AG_HEADER_BANK IS 'BIC-Code des beauftragten Instituts';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_AG_REF_NR_F20 IS 'Swift-Referenz Feld F20';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_AG_REF_NR_F20Z IS 'Referenz des konto-führenden Instituts, Swift-Feld F20Z';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_AG_REF_ERI_DATEN IS 'EuroRelatedInformation. Besondere Hinweise bei Euro-Swift-Transaktionen';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_VERW_ZWECK_ANZAHL IS 'Anzahl der aktuell belegten Verwendungszwecke';

COMMENT ON COLUMN ODS.KRDB_SCPS_CPD_KONTO.SCPS_VERW_ZWECK_TEXT_1 IS 'Verwendungszweck-Angaben Teil-1. DTAC: Feld VERWENDUNGSZWECK + fünf Erweiterungen ausser Namens-Teilen. AGRF: Swift-Felder F70';


/*==============================================================*/
/* Table:    KRDB_SCPS_CPD_KONTO                                  */
/* DDL: 		 grants der Tabelle                                 */
/*                                                              */
/*==============================================================*/

GRANT SELECT ON ODS.KRDB_SCPS_CPD_KONTO TO BO_READ;