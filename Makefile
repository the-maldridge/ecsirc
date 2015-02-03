.PHONY: site clean mkdir_secrets secrets account_admin_password account_salt inspircd_cert inspircd_inspircd_power_diepass inspircd_inspircd_power_restartpass inspircd_links_madhax_recvpass inspircd_links_madhax_sendpass inspircd_links_minecraft_recvpass inspircd_links_minecraft_sendpass inspircd_modules_cloak_key inspircd_opers monit_passwd nslcd_bind_passwd

SECRETS_DIR = secret

DESTDIR = ${CURDIR}/tmp
SUDO = sudo
INSTALL = install

clean:
	${SUDO} rm -rf ${DESTDIR}
	${SUDO} rm -f site*.tgz

secrets: mkdir_secrets inspircd_cert inspircd_inspircd_power_diepass inspircd_inspircd_power_restartpass inspircd_modules_cloak_key inspircd_opers
	@tput setaf 1 && echo "Don't forget to ensure your ircd configuration is sane." && tput sgr0

mkdir_secrets:
	mkdir -pm 0700 ${SECRETS_DIR}

inspircd_cert:
	openssl genrsa -out ${SECRETS_DIR}/inspircd_key.pem 2048
	openssl req -new -config inspircd_cert.conf -key ${SECRETS_DIR}/inspircd_key.pem -out ${SECRETS_DIR}/inspircd_csr.pem
	@tput setaf 1 && echo "Follow the steps at https://www.utdallas.edu/infosecurity/DigitalCertificates_SSL.html and put the resulting key at ${SECRETS_DIR}/inspircd_cert.pem" && tput sgr0

inspircd_inspircd_power_diepass:
	./inspircd_hmac "Password to shutdown the IRC server: " > ${SECRETS_DIR}/inspircd_inspircd_power_diepass

inspircd_inspircd_power_restartpass:
	./inspircd_hmac "Password to restart the IRC server: " > ${SECRETS_DIR}/inspircd_inspircd_power_restartpass

inspircd_opers:
	./inspircd_opers > ${SECRETS_DIR}/inspircd_opers.yml
