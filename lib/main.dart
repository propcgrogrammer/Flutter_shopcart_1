import 'package:flutter/material.dart';

/**

刪除「前1個」 route，push到新 route
pushReplacementNamed、popAndPushNamed、pushReplacement
進入新screen並且移除目前的screen。

例如：購物APP
為了要進行購物功能(screen3)，使用者進入screen3確認了購買的商品。這時候，進入結帳畫面(screen4)。突然，使用者臨時想到還要買另一個商品(screen2)，回到screen2添加至購物車後，直接再回到screen4進行結帳，省下到screen3的時間。
使用前： screen1 -> screen 2 -> screen3 -> screen4
使用後：screen1 -> screen 2 -> screen4 // 刪除了screen3

*/

void main() {
  runApp(new MaterialApp(
    home: new Shop(),
    routes: <String, WidgetBuilder>{
      '/shop': (BuildContext context) => new Shop(),
      '/shopcart': (BuildContext context) => new ShopCart(),
      '/checkout': (BuildContext context) => new CheckOut(),
      '/payment': (BuildContext context) => new Payment(),
    },
  ));
}

class Shop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text('商品列表'),
        ),
        body: new ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    height: 50,
                    color: Colors.amber[600],
                    child: const Center(
                      child: Text('眼鏡'),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/shopcart', arguments: '眼鏡');
                    },
                    child: Text('加入購物車')),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                    height: 50,
                    color: Colors.amber[300],
                    child: const Center(
                      child: Text('項鍊'),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/shopcart', arguments: '項鍊');
                    },
                    child: Text('加入購物車')),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                    height: 50,
                    color: Colors.amber[100],
                    child: const Center(
                      child: Text('手錶'),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/shopcart', arguments: '手錶');
                    },
                    child: Text('加入購物車')),
              ],
            ),
          ],
        ));
  }
}

class ShopCart extends StatelessWidget {
  late String cartList = '';

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    cartList = cartList + args.toString();

    return Scaffold(
      appBar: new AppBar(
        title: Text('購物車'),
      ),
      body: new Column(
        children: <Widget>[
          Text(cartList.toString()),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/checkout');

                //功能一樣，但是使用離開動畫
                //Navigator.popAndPushNamed(context, '/shop');
              },
              child: Text('進行結帳'))
        ],
      ),
    );
  }
}

class CheckOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text('結帳頁面'),
        ),
        body: new Column(
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/payment', (Route<dynamic> route) => false);
// Route<dynamic> route) => false確保刪除先前的所有route

                  /**
                 * // 除此之外，我們還能刪除中間的screen，保留想要的screen
                   // 以下範例是保留screen4、screen1，刪除screen2、screen3
                      Navigator.of(context).pushNamedAndRemoveUntil('/screen4', 
                      ModalRoute.withName('/screen1'));
                   // 注意以下兩個功能相等(移除所有Screen只剩下screen1)
                      pushNamedAndRemoveUntil(route,ModalRoute.withName('/screen1'),)
                      pushAndRemoveUntil(MaterialPageRoute,ModalRoute.withName('/screen1'),)
                 */
                },
                child: Text('確定結帳')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('繼續購物'))
          ],
        ));
  }
}

/**

刪除「先前所有」 route，push到新 route後，設為第一層
pushNamedAndRemoveUntil
例如：透過Firebase驗證登入Google帳號，進入APP主頁後，如果按下返回鍵，會跳回登入前的畫面，這還蠻嚴重的。
// 在彈出新路由之前，刪除路由棧中的所有路由
// 這樣可以保證把之前所有的路由都進行刪除，然後才push新的路由。
Navigator.of(context).pushNamedAndRemoveUntil('/Screen2', (Route<dynamic> route) => false);
// Route<dynamic> route) => false確保刪除先前的所有route
// 除此之外，我們還能刪除中間的screen，保留想要的screen
// 以下範例是保留screen4、screen1，刪除screen2、screen3
Navigator.of(context).pushNamedAndRemoveUntil('/screen4',
ModalRoute.withName('/screen1'));
// 注意以下兩個功能相等(移除所有Screen只剩下screen1)
pushNamedAndRemoveUntil(route,ModalRoute.withName('/screen1'),)
pushAndRemoveUntil(MaterialPageRoute,ModalRoute.withName('/screen1'),)
*/

class Payment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('結帳完成'),
      ),
      body: new Column(
        children: <Widget>[
          Text('恭喜您，已成功完成此訂單'),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/shop', (Route<dynamic> route) => false);
// Route<dynamic> route) => false確保刪除先前的所有route
              },
              child: Text('重新購物'))
        ],
      ),
    );
  }
}
