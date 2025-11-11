create sequence adresse_adresse_id_seq
    as integer;

create type art as enum ('unb', 'prv', 'ges');

create type adress_typ as enum ('lieferung', 'rechnung');

create type bezahlart as enum ('lastschrift', 'rechnung', 'bar', 'kredit');

create type rechnungsstatus as enum ('offen', 'gestellt', 'mahnung1', 'inkasso', 'storno', 'beglichen');

create type bestellstatus as enum ('offen', 'versendet', 'angekommen', 'retour', 'bezahlt');

create table bank
(
    blz      varchar(12) not null,
    bankname varchar(255),
    lkz      varchar(2),
    primary key (blz)
);

create table artikel
(
    artikel_id  serial,
    bezeichnung varchar(255),
    einzelpreis numeric,
    waerung     varchar(3),
    primary key (artikel_id)
);

create table warengruppe
(
    warengruppe_id serial,
    bezeichnung    varchar(255),
    primary key (warengruppe_id)
);

create table kunde
(
    kunde_id  serial,
    nachname  varchar(255),
    vorname   varchar(255),
    kategorie art,
    primary key (kunde_id)
);

create table adresse
(
    adresse_id serial,
    strasse    varchar(255),
    hnr        varchar(4),
    lkz        varchar(2),
    plz        varchar(5),
    ort        varchar(255),
    primary key (adresse_id)
);

create table kunden_adresse
(
    kunde_id   integer    not null,
    adresse_id integer    not null,
    adress_typ adress_typ not null,
    primary key (kunde_id, adresse_id, adress_typ),
    foreign key (kunde_id) references kunde,
    foreign key (adresse_id) references adresse
);

create table bankverbindung
(
    kunde_id    integer,
    blz         varchar(12) not null,
    kontonummer varchar(12) not null,
    iban        varchar(35),
    primary key (blz, kontonummer),
    foreign key (blz) references bank,
    foreign key (kunde_id) references kunde
);

create table lieferant
(
    lieferant_id serial,
    firmenname   varchar(255),
    adresse_id   integer,
    primary key (lieferant_id),
    foreign key (adresse_id) references adresse
);

create table bestellung
(
    bestellung_id serial,
    kunde_id      integer,
    adresse_id    integer,
    adress_typ    adress_typ,
    datum         timestamp,
    status        bestellstatus,
    primary key (bestellung_id),
    foreign key (kunde_id, adresse_id, adress_typ) references kunden_adresse
);

create table rechnung
(
    rechnung_id serial,
    kunde_id    integer,
    adresse_id  integer,
    adress_typ  adress_typ,
    bezahlart   bezahlart,
    datum       timestamp,
    status      rechnungsstatus,
    rabatt      numeric,
    skonto      numeric,
    primary key (rechnung_id),
    foreign key (kunde_id, adresse_id, adress_typ) references kunden_adresse
);

create table bestellung_position
(
    bestellung_id integer not null,
    position_id   integer not null,
    artikel_id    integer,
    menge         numeric,
    primary key (bestellung_id, position_id),
    foreign key (bestellung_id) references bestellung,
    foreign key (artikel_id) references artikel
);

create table rechnung_position
(
    rechnung_id integer not null,
    position_id integer not null,
    artikel_id  integer,
    menge       numeric,
    steuer      numeric,
    primary key (rechnung_id, position_id),
    foreign key (rechnung_id) references rechnung,
    foreign key (artikel_id) references artikel
);

create table artikel_warengruppe
(
    artikel_id     integer not null,
    warengruppe_id integer not null,
    primary key (artikel_id, warengruppe_id),
    foreign key (artikel_id) references artikel,
    foreign key (warengruppe_id) references warengruppe
);

create table artikel_lieferant
(
    artikel_id   integer not null,
    lieferant_id integer not null,
    primary key (artikel_id, lieferant_id),
    foreign key (artikel_id) references artikel,
    foreign key (lieferant_id) references lieferant
);


