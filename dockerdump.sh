#
# Script to pull/export/scan a list of docker images from a registry (found via 'az acr repository list', via Artifactory REST API, etc)
#

# Pull down all images in list
for image in $(cat ~/registry_container_list.txt); do

	echo [+] Pulling container $image
	docker pull $image
	
done

# Loop through all images pulled down locally
for container in $(docker image list | cut -d " " -f 1 | grep -v -i "REPOSITORY"); do

	# Save docker image to tar file
	echo [+] Saving container $container to ~/${container##*/}.tar
	docker save $container -o ~/${container##*/}.tar
	
	# Run dockerscan against exported container tar file
	python3 -m dockerscan image analyze ~/${container##*/}.tar
	
done

# Done
echo [+] Done
