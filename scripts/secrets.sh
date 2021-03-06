#!/usr/bin/env bash

#app crypto secret
secret="app_secretttttt192818923782364781263486712384761528764512asldkfjak"

#dendro linux user -- who will own the installation folders and the dendro processes
dendro_user_name='dendro'
dendro_user_group='dendro'
dendro_user_password='dendr0'
dendro_user_home_folder="/home/$dendro_user_name"

#mysql
mysql_username='root'
mysql_root_password='r00t_p4ssw0rd'

eudat_token="veryLongAndComplicatedString"
eudat_community_id="e9b9792e-79fb-4b07-b6b4-b9c2bd06d095"

#email account for messages and password recovery messaging
emailing_account_gmail_reply_to_address="noreply@dendro.fe.up.pt"
emailing_account_gmail_user="gmail_user_to_send_emails"
emailing_account_gmail_password="password_for_gmail_user_to_send_emails"

#google analytics token (if you want Google Analytics on the Dendro instance)
google_analytics_tracking_code="GOOGLE_ANALYTICS_DEVELOPMENT_ANALYTICS_TRACKING_CODE"

#gmaps API key
gmaps_api_key="VERY_LONG_AND_COMPLICATED_STRING"

#virtuoso

#admin user
virtuoso_dba_user="dba"
virtuoso_dba_password="dba"

#virtuoso linux user (owner of the virtuoso installation and process)
virtuoso_user='virtuoso'
virtuoso_group='virtuoso'
virtuoso_user_password='virtu0s0'

#jenkins linux user (owner of the jenkins installation and process)
jenkins_user="jenkins"
jenkins_user_group="jenkins"
jenkins_user_password="jenkins______PASSSSWORD_COMPLICA4ted"

#mongodb
mongodb_dba_user="admin"
mongodb_dba_password="34857q98efhlajwehrlaeroiu2yq3948q2uweoiqwherluqywioerqhw0p92874983724rhqwelrhqweiuryoiqwerhlqwhjeflkawejrp9023475823y4rjhelkjrheiouryi"

#svn users and passwords
svn_user="user_for_dendro_svn_repo"
svn_user_password="password_for_dendro_svn_repo"

#orcid authentication settings
orcid_client_id="ORCID_CLIENT_ID"
orcid_client_secret="ORCID_CLIENT_SECRET"
orcid_auth_callback_url="/auth/orcid/callback"

#saml authentication settings
saml_authentication_callback_path="/auth/saml/callback"
saml_authentication_entry_point="https://openidp.feide.no/simplesaml/saml2/idp/SSOService.php"
saml_authentication_issuer="passport-saml"
saml_authentication_button_text="Sign-in with institutional login"

#shibboleth authentication settings
shibboleth_business_logic_handler="bootup/models/shibboleth/shibboleth_UP.js"
shibboleth_authentication_callback_url="shibboleth_authentication_callback_url"
shibboleth_authentication_entry_point="shibboleth_authentication_entry_point"
shibboleth_authentication_issuer="shibboleth_authentication_issuer"
shibboleth_authentication_session_secret="shibboleth_authentication_session_secret"
shibboleth_authentication_button_text="Sign-in with shibboleth UP"
shibboleth_authentication_idp_cert_path="shibboleth_authentication_idp_cert_path"
shibboleth_authentication_key_path="shibboleth_authentication_key_path"
shibboleth_authentication_cert_path="shibboleth_authentication_cert_path"
shibboleth_authentication_button_url="shibboleth_authentication_button_url"

#openssl parameters to generate certificates and keys
openssl_country="PT"
openssl_state="Porto"
openssl_location="Porto"
openssl_organization="Dendro Infolab"
openssl_organizational_unit="Dendro Infolab"
openssl_common_name="dendro.fe.up.pt"

#teamcity credentials

teamcity_admin_username="jrocha"
teamcity_admin_password="bolachinhas_do_melhor_que_ha"

#orcid authentication
	orcid_client_id="ORCID_CLIENT_ID"
	orcid_client_secret="ORCID_CLIENT_SECRET"
