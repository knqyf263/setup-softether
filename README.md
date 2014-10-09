setup-softether
=========

SoftEther VPNの設定を何度もする時に、コマンドを覚えていられないので簡単にsetupできるようなスクリプトを書きました。  
基本自分で忘れないように作ったメモです。  

configファイルにドメイン名やパスワードなどを書いておけば自動でAccountを作成してConnectしてくれます。


## 環境
基本SoftEtherが動くOSでは動くと思いますが、OSによってvpncmdのパスを変えて下さい。  
以下が私のテストした環境になります。    
* Ubuntu  （バージョン：12.04）
* SoftEther（バージョン：4.10）

## 使い方
### SoftEther VPNの設定
まずはSoftEther VPNの設定について書いておきます。  
まず、VPNのソフトをダウンロードする。  
http://www.softether-download.com/ja.aspx?product=softether
今回はLinuxの32bit版をダウンロードするとします。

    $ cd ~/
    $ wget http://jp.softether-download.com/files/softether/v4.10-9505-beta-2014.10.03-tree/Linux/SoftEther_VPN_Client/32bit_-_Intel_x86/softether-vpnclient-v4.10-9505-beta-2014.10.03-linux-x86-32bit.tar.gz
    
ダウンロードしてきたものを解凍し、makeしたあとに/usr/localに移動させます。

    $ tar zxvf softether-vpnclient-v4.10-9505-beta-2014.10.03-linux-x86-32bit.tar.gz
    $ cd vpnclient
    $ make
    $ cd /usr/local
    $ sudo mv ~/vpnclient /usr/local
    

そのあと、vpnclientを起動します。

    $ sudo ./vpnclient start
    The SoftEther VPN Client service has been started.
    
このあと、vpncmdを打って操作しますが、その部分をかわりにスクリプトにやらせます。

### スクリプトの使い方

まずスクリプトを落とす。

    $ cd /usr/local/vpnclient
    $ git clone https://github.com/knqyf263/setup-softether.git
    $ cd setup-softether

vpn.confの中身を自分の環境に応じて書き換えます。  

    $ vim vpn.conf
    
    # NIC NAME
    NIC="testnic"
    # Account name
    ACCOUNT="account"
    # Server name
    SERVER="example.com:443"
    # Hub name
    HUB="DEFAULT"
    # User name
    USERNAME="user"
    # Password
    PASSWORD="password"
    # type (standard or radius)
    TYPE="standard"
    
書き換え終わったら、softether.shを実行します。  
setupを渡せばsetupされます。  

    $ ./softether.sh setup
    Starting...
    The commands written in the file "./setup.txt" will be used instead of input from keyboard.
    vpncmd command - SoftEther VPN Command Line Management Utility
    SoftEther VPN Command Line Management Utility (vpncmd command)
    Version 4.10 Build 9505   (English)
    Compiled 2014/10/03 18:26:16 by yagi at pc25
    Copyright (c) SoftEther VPN Project. All Rights Reserved.
    
    Connected to VPN Client "localhost".
    
    VPN Client>NicCreate testnic
    NicCreate command - Create New Virtual Network Adapter
    
    VPN Client>NicList
    NicList command - Get List of Virtual Network Adapters
    Item                        |Value
    ----------------------------+-----------------------------------
    Virtual Network Adapter Name|testnic
    Status                      |Enabled
    MAC Address                 |00AC5B6D236F
    Version                     |Version 4.10 Build 9505   (English)
    The command completed successfully.
    
    
    （途中省略）

    VPN Client>AccountList
    AccountList command - Get List of VPN Connection Settings
    Item                        |Value
    ----------------------------+----------------------------------------------------
    VPN Connection Setting Name |test
    Status                      |Connecting
    VPN Server Hostname         |example.com:443 (Direct TCP/IP Connection)
    Virtual Hub                 |DEFAULT
    Virtual Network Adapter Name|testnic
    The command completed successfully.

こんな感じになっていたらOKです。  
StatusがConnectingだと思うので、再度Statusを確認してConnectedになっていればOKです。

    $ ./softether.sh status
    VPN Client>AccountList
    AccountList command - Get List of VPN Connection Settings
    Item                        |Value
    ----------------------------+----------------------------------------------------
    VPN Connection Setting Name |test
    Status                      |Connected
    VPN Server Hostname         |example.com:443 (Direct TCP/IP Connection)
    Virtual Hub                 |DEFAULT
    Virtual Network Adapter Name|testnic
    The command completed successfully.

切断したい場合はdisconnect、設定を消したい場合はdeleteを渡せば出来ます。

