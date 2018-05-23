SPARQL LOAD <http://www.w3.org/ns/auth/cert#> INTO graph <http://www.w3.org/ns/auth/cert#>;

SPARQL CLEAR GRAPH <http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/SCHEMA_ORG/schema.rdf> INTO graph <http://schema.org/>;

SPARQL CLEAR GRAPH <http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#>;
SPARQL LOAD <http://lov.okfn.org/dataset/lov/vocabs/nfo/versions/2012-06-10.n3> INTO graph <http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#>;

SPARQL CLEAR GRAPH <http://www.semanticdesktop.org/ontologies/2007/01/19/nie#>;
SPARQL LOAD <http://lov.okfn.org/dataset/lov/vocabs/nie/versions/2012-10-03.n3> INTO graph <http://www.semanticdesktop.org/ontologies/2007/01/19/nie#>;

SPARQL CLEAR GRAPH <http://purl.org/dc/elements/1.1/>;
SPARQL LOAD <http://dublincore.org/2012/06/14/dcelements.rdf>  INTO graph <http://purl.org/dc/elements/1.1/>;

SPARQL CLEAR GRAPH <http://purl.org/dc/terms/>;
SPARQL LOAD <http://dublincore.org/2012/06/14/dcterms.rdf> INTO GRAPH <http://purl.org/dc/terms/>;

SPARQL CLEAR GRAPH <http://xmlns.com/foaf/0.1/>;
SPARQL LOAD <http://xmlns.com/foaf/spec/INDEX.rdf> INTO GRAPH <http://xmlns.com/foaf/0.1/>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/achem/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/ACHEM/achem.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/achem/>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/BIODIV/0.1#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/BIODIV/BIODIV_17Jun_1557.owl> INTO <http://dendro.fe.up.pt/ontology/BIODIV/0.1#>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/BioOc#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/BIOOC/BioOc.owl> INTO <http://dendro.fe.up.pt/ontology/BioOc#>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/cfd#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/COMPUTATIONAL_FLUID_DYNAMICS/cfd.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/cfd#>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/cep/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/CUTTING_PACKING/cep.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/cep/>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/dcb/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/DCB/dcb.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/dcb/>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/0.1/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/DENDRO/dendro.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/0.1/>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/EcoGeorref/0.1#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/ECOGEORREF/EcoGeorref.owl> INTO <http://dendro.fe.up.pt/ontology/EcoGeorref/0.1#>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/gravimetry#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/GRAVIMETRY/gravimetry.owl> INTO <http://dendro.fe.up.pt/ontology/gravimetry#>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/hydrogen#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/HYDROGEN/hydrogen.owl> INTO <http://dendro.fe.up.pt/ontology/hydrogen#>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/research/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/RESEARCH/research.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/research/>;


SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/socialStudies#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/SOCIAL_STUDIES/SocialStudies.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/socialStudies#>;


SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/trafficSim#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/TRAFFIC_SIM/trafficSimDendro.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/trafficSim#>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/game/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab-rdm/dendro-ontologies/master/GAME/game.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/game/>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/tvu#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/TVU/TVU_XML.owl> INTO GRAPH <http://dendro.fe.up.pt/ontology/tvu#>;

SPARQL CLEAR GRAPH <http://purl.org/ontology/po/>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/PO/1.1.ttl> INTO GRAPH <http://purl.org/ontology/po/>;

SPARQL CLEAR GRAPH <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/M3-LITE/M3-lite.owl#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/M3-LITE/M3-lite.owl> INTO GRAPH <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/M3-LITE/M3-lite.owl#>;

SPARQL CLEAR GRAPH <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/SSN/SSN.owl#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/SSN/SSN.owl> INTO GRAPH <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/SSN/SSN.owl#>;

SPARQL CLEAR GRAPH <http://dendro.fe.up.pt/ontology/ddiup#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/DDI_UP/ddi_up_ontology_2.0.rdf> INTO GRAPH <http://dendro.fe.up.pt/ontology/ddiup#>;


SPARQL CLEAR GRAPH <http://rdf-vocabulary.ddialliance.org/discovery#>;
SPARQL LOAD <https://raw.githubusercontent.com/feup-infolab/dendro-ontologies/master/DIS

SPARQL CLEAR GRAPH <http://www.w3.org/1999/02/22-rdf-syntax-ns#>;
SPARQL LOAD <https://www.w3.org/1999/02/22-rdf-syntax-ns.rdf> INTO GRAPH <http://www.w3.org/1999/02/22-rdf-syntax-ns#>;

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
