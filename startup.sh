#!/bin/bash
# Wrapper to start the upsource docker container. It checks if the persisted conf folder is present and creates a symlink to Upsource/conf. Then starts the upsource server.

PERSISTENT_DISK_MOUNTPOINT=/opt/upsource-disk

function run() {
        echo Running $*
        $*
        STATUS=$?
        if [ $STATUS -ne 0 ]; then
                echo $1 FAILED with status $STATUS
                exit $STATUS
        fi
        echo $1 SUCCESS
}

# copy conf folder if not yet exists
if [ -d "/opt/upsource-disk" ]; then
    if [ ! -d "${PERSISTENT_DISK_MOUNTPOINT}/conf" ]; then
      echo "* Copying the conf folder as it does not yet exist."
      run cp -r /opt/Upsource/conf ${PERSISTENT_DISK_MOUNTPOINT}
    fi

    # delete local conf folder and create symlink on persistent disk
    echo "* Removing local conf folder"
    run rm -rf /opt/Upsource/conf
    echo "* Creating symlink to ${PERSISTENT_DISK_MOUNTPOINT}/conf"
    run ln -s ${PERSISTENT_DISK_MOUNTPOINT}/conf /opt/Upsource/conf
fi

echo "* Starting the Upsource server"
run /opt/Upsource/bin/upsource.sh run
