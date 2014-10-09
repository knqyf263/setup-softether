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
    
  
