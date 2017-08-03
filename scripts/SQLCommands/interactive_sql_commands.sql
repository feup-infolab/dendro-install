SPARQL LOAD <http://www.w3.org/ns/auth/cert#> INTO graph <http://www.w3.org/ns/auth/cert#>;

SPARQL CLEAR GRAPH <http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#>;
SPARQL LOAD <http://lov.okfn.org/dataset/lov/vocabs/nfo/versions/2012-06-10.n3> INTO graph <http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('nfo', 2);
DB.DBA.XML_SET_NS_DECL ('nfo', 'http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#', 2);

SPARQL CLEAR GRAPH <http://www.semanticdesktop.org/ontologies/2007/01/19/nie#>;
SPARQL LOAD <http://lov.okfn.org/dataset/lov/vocabs/nie/versions/2012-10-03.n3> INTO graph <http://www.semanticdesktop.org/ontologies/2007/01/19/nie#>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('nie', 2);
DB.DBA.XML_SET_NS_DECL ('nie', 'http://www.semanticdesktop.org/ontologies/2007/01/19/nie#', 2);

SPARQL CLEAR GRAPH <http://purl.org/dc/elements/1.1/>;
SPARQL LOAD <http://dublincore.org/2012/06/14/dcelements.rdf>  INTO graph <http://purl.org/dc/elements/1.1/>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('dc', 2);
DB.DBA.XML_SET_NS_DECL ('dc', 'http://purl.org/dc/elements/1.1/', 2);

SPARQL CLEAR GRAPH <http://purl.org/dc/terms/>;
SPARQL LOAD <http://dublincore.org/2012/06/14/dcterms.rdf> INTO GRAPH <http://purl.org/dc/terms/>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('dcterms', 2);
DB.DBA.XML_SET_NS_DECL ('dcterms', 'http://purl.org/dc/terms/', 2);

SPARQL CLEAR GRAPH <http://xmlns.com/foaf/0.1/>;
SPARQL LOAD <http://xmlns.com/foaf/spec/INDEX.rdf> INTO GRAPH <http://xmlns.com/foaf/0.1/>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('foaf', 2);
DB.DBA.XML_SET_NS_DECL ('foaf', 'http://xmlns.com/foaf/0.1/', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/achem/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/ACHEM/achem.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/achem/>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('achem', 2);
DB.DBA.XML_SET_NS_DECL ('achem', 'http://dendro.fe.up.pt/ontology/achem/', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/BIODIV/0.1#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/BIODIV/BIODIV_17Jun_1557.owl> INTO <http://dendro.fe.up.pt/ontology/BIODIV/0.1#>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('bdv', 2);
DB.DBA.XML_SET_NS_DECL ('bdv', 'http://dendro.fe.up.pt/ontology/BIODIV/0.1#', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/BioOc#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/BIOOC/BioOc.owl> INTO <http://dendro.fe.up.pt/ontology/BioOc#>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('biooc', 2);
DB.DBA.XML_SET_NS_DECL ('biooc', 'http://dendro.fe.up.pt/ontology/BioOc#', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/cfd#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/COMPUTATIONAL_FLUID_DYNAMICS/cfd.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/cfd#>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('cfd', 2);
DB.DBA.XML_SET_NS_DECL ('cfd', 'http://dendro.fe.up.pt/ontology/cfd#', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/cep/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/CUTTING_PACKING/cep.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/cep/>;
DB.DBA.XML_SET_NS_DECL ('cep', 'http://dendro.fe.up.pt/ontology/cep/', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/dcb/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/DCB/dcb.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/dcb/>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('dcb', 2);
DB.DBA.XML_SET_NS_DECL ('dcb', 'http://dendro.fe.up.pt/ontology/dcb/', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/0.1/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/DENDRO/dendro.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/0.1/>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('ddr', 2);
DB.DBA.XML_SET_NS_DECL ('ddr', 'http://dendro.fe.up.pt/ontology/0.1/', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/EcoGeorref/0.1#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/ECOGEORREF/EcoGeorref.owl> INTO <http://dendro.fe.up.pt/ontology/EcoGeorref/0.1#>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('ecogeorref', 2);
DB.DBA.XML_SET_NS_DECL ('ecogeorref', 'http://dendro.fe.up.pt/ontology/achem/', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/gravimetry#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/GRAVIMETRY/gravimetry.owl> INTO <http://dendro.fe.up.pt/ontology/gravimetry#>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('gravimetry', 2);
DB.DBA.XML_SET_NS_DECL ('gravimetry', 'http://dendro.fe.up.pt/ontology/gravimetry#', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/hydrogen#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/HYDROGEN/hydrogen.owl> INTO <http://dendro.fe.up.pt/ontology/hydrogen#>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('hdg', 2);
DB.DBA.XML_SET_NS_DECL ('hdg', 'http://dendro.fe.up.pt/ontology/hydrogen#', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/research/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/RESEARCH/research.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/research/>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('research', 2);
DB.DBA.XML_SET_NS_DECL ('research', 'http://dendro.fe.up.pt/ontology/research/', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/socialStudies#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/SOCIAL_STUDIES/SocialStudies.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/socialStudies#>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('socialStudies', 2);
DB.DBA.XML_SET_NS_DECL ('socialStudies', 'http://dendro.fe.up.pt/ontology/socialStudies#', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/trafficSim#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/TRAFFIC_SIM/trafficSimDendro.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/trafficSim#>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('trafSim', 2);
DB.DBA.XML_SET_NS_DECL ('trafSim', 'http://dendro.fe.up.pt/ontology/trafficSim#', 2);

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/game/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/GAME/game.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/game/>;
DB.DBA.XML_REMOVE_NS_BY_PREFIX('gm', 2);
DB.DBA.XML_SET_NS_DECL ('gm', 'http://dendro.fe.up.pt/ontology/game/', 2);

GRANT SPARQL_UPDATE to "SPARQL";

GRANT execute ON SPARQL_INSERT_DICT_CONTENT TO "SPARQL";
GRANT execute ON SPARQL_INSERT_DICT_CONTENT TO SPARQL_UPDATE;
GRANT execute ON DB.DBA.SPARQL_MODIFY_BY_DICT_CONTENTS TO "SPARQL";
GRANT execute ON DB.DBA.SPARQL_MODIFY_BY_DICT_CONTENTS TO SPARQL_UPDATE;
GRANT execute ON DB.DBA.SPARQL_DELETE_DICT_CONTENT TO "SPARQL";
GRANT execute ON DB.DBA.SPARQL_DELETE_DICT_CONTENT TO SPARQL_UPDATE;
GRANT execute ON DB.DBA.SPARUL_RUN TO "SPARQL";
GRANT execute ON DB.DBA.SPARUL_RUN TO SPARQL_UPDATE;
GRANT execute ON SPARUL_CLEAR TO "SPARQL";
GRANT execute ON SPARUL_CLEAR TO SPARQL_UPDATE;
GRANT DELETE ON RDF_QUAD TO "SPARQL";
GRANT DELETE ON RDF_QUAD TO SPARQL_UPDATE;
GRANT execute ON DB.DBA.RDF_OBJ_ADD_KEYWORD_FOR_GRAPH TO "SPARQL";
GRANT execute ON DB.DBA.RDF_OBJ_ADD_KEYWORD_FOR_GRAPH TO SPARQL_UPDATE;
GRANT execute ON DB.DBA.L_O_LOOK TO "SPARQL";
GRANT execute ON DDB.DBA.L_O_LOOK TO "SPARQL_UPDATE";
