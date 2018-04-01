# MikroTik Client
`docker.theczech.io/mikrotik-client`

Preconfigured [Docker](https://www.docker.com) container for querying the [MikroTik RouterOS](https://mikrotik.com/software) devices via SSH with password or SSH key authentication.

## Build

```
docker build -t mikrotik-client .
```

## Usage

Here are some usage examples with various authentication methods.

### Plain-text password authentication

> This method is not recommended for security reasons.

```
docker run -e MIKROTIK_HOST=192.168.1.1 -e MIKROTIK_USER=johndoe -e MIKROTIK_PASSWORD=12345 mikrotik-client query /system resource cpu print
```

### SSH key authentication

> Supplied SSH key should be a DSA private key encoded with `base64` encoding.

#### From environment variable

```
docker run -e MIKROTIK_HOST=192.168.1.1 -e MIKROTIK_USER=johndoe -e MIKROTIK_SSH_KEY="KEY" mikrotik-client query /system resource cpu print
```

#### From file

Directory `~/keys` contains a file `id_dsa.base64` with the SSH key.

```
docker run -e MIKROTIK_HOST=192.168.1.1 -e MIKROTIK_USER=johndoe -v ~/keys:/keys mikrotik-client query /system resource cpu print
```

If none of these authentication options are provided, container will exit.

## Installation walk-through

> MikroTik Documentation on [setting up SSH DSA access](https://wiki.mikrotik.com/wiki/Use_SSH_to_execute_commands_(DSA_key_login))

If you are setting up the SSH access to your MikroTik device for the first time, follow these steps.

This walk-through assumes that your MikroTik device is present at IP `192.168.1.1`.

1. Create a new DSA keypair

    ```
    ssh-keygen -t dsa
    ```

2. Upload the public key to your MikroTik device

    ```
    scp ~/.ssh/id_dsa.pub johndoe@192.168.1.1:/
    ```

3. Import the public key to your user account on your MikroTik device

    > The key file is removed from the device filesystem after successful import.

    Using the RouterOS console:

    ```
    user ssh-keys import file=id_dsa.pub 
    ```

    Using the [WinBox](https://mikrotik.com/download) GUI:

    1. Open `System` menu
    2. Select `Users`
    3. Switch to `SSH keys` tab
    4. Click `Import SSH key` button
    5. Set the corrent `User`
    6. Locate the uploaded file (should be visible immediately)
    7. Click `Import SSH key`

4. Encode the private key using `base64`

    ```
    mkdir -p ~/mykeys
    base64 ~/.ssh/id_dsa > ~/mykeys/id_dsa.base64
    ```

5. Test the connection with `mikrotik-client`

    ```
    docker run -e MIKROTIK_HOST=192.168.1.1 -e MIKROTIK_USER=johndoe -v ~/mykeys:/keys mikrotik-client query /system resource cpu print
    ```

    You should see output like this:

    ```
     # CPU                                             LOAD         IRQ        DISK
     0 cpu0                                             13%          0%          0%
    ```

---

Copyright 2018 (c) The Czech Company, s.r.o. All rights reserved. Visit us at [https://theczech.cz](https://theczech.cz).