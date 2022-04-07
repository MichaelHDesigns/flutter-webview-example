import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTH Coin Wallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final myController = TextEditingController();
  String url = 'https://wallet.hth.world';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  Widget buildWebView(BuildContext context, _title, _showBackButton) {
    return WebviewScaffold(
      url: this.url,
      appBar: new AppBar(
        title: Text(_title),
        automaticallyImplyLeading: _showBackButton,
        actions: <Widget>[
          RaisedButton.icon(
            label: Text("EDIT URL", style: TextStyle(color: Colors.yellow),),
            icon: Icon(Icons.edit, color: Colors.yellow,),
            onPressed: (){
              Navigator.of(context).pop();
            },
            color: Colors.blue[300],
          )
        ],
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('HTH Coin Wallet'),
      ),
      drawer: _createDrawer(),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Center(child: Text("WEBVIEW", style: TextStyle(fontSize: 50.0),)),
          TextField(
            autofocus: true,
            controller: myController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(width: 40.0)),
              hintText: this.url
            ),
          ),
          Center(
            child: RaisedButton.icon(
              icon: Icon(Icons.exit_to_app),
              label: Text('Go'),
              color: Colors.white54,
              onPressed: () => _goToWebView(),
            ),
          ),
          Center( 
            child: RaisedButton.icon(
              lable: Text('QR Scan'),
              color: Color.white54,
              onPressed: () => _goToQRScan(),
           ),
         )
        ],
      ),
    );
  }
  
void _goToQRScan() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HTH QR Scanner',
        theme: new ThemeData(primarySwatch: Colors.red),
    home: new ScanQRCode());
  }
}

class ScanQRCode extends StatefulWidget {
  @override
  _ScanQRCodState createState() => _ScanQRCodState();
}

class _ScanQRCodState extends State<ScanQRCode> {
  QRCaptureController _captureController = QRCaptureController();

  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();

    _captureController.onCapture((data) {
      print('onCapture----$data');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            QRCaptureView(controller: _captureController),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildToolBar(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToolBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            _captureController.pause();
          },
          child: Text('pause'),
        ),
        FlatButton(
          onPressed: () {
            if (_isTorchOn) {
              _captureController.torchMode = CaptureTorchMode.off;
            } else {
              _captureController.torchMode = CaptureTorchMode.on;
            }
            _isTorchOn = !_isTorchOn;
          },
          child: Text('torch'),
        ),
        FlatButton(
          onPressed: () {
            _captureController.resume();
          },
          child: Text('resume'),
        ),
      ],
    );
  }
}

  void _goToWebView(){
    String text = myController.text;
    if(text == "" || text == null){
      return _showAlert("Url Cannot Empty");
    }
    
    setState(() {
      url = text;
    });
    
    Navigator.of(context).push(MaterialPageRoute( 
      builder: (context) => buildWebView(context, "HTH Coin Wallet", false)
    ));
  }

  void _showAlert(text){
    SnackBar snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Drawer _createDrawer()
  {
    return Drawer(

      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Image.network("	https://hth.world/wp-content/themes/HTHworldwide/images/hthlogo_md.png", fit: BoxFit.cover,),
            padding: EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text("HTH Coin Wallet"),
            subtitle: Text("HTH Coin Wallet"),
            dense: true,
            leading: Icon(Icons.open_in_new),
            onTap: () {
              setState(() {
                url = 'https://wallet.hth.world';
              });
              Navigator.of(context).push(MaterialPageRoute( 
                builder: (context) => buildWebView(context, "HTH Coin Wallet", true)
              ));
            },
          )
        ],
      ),
    );
  }
}
