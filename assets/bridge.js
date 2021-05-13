window.mochicloud = {
  toggleAutoRefresh: (enable) => {
    flutter_inappwebview.callHandler('toggleAutoRefresh', enable)
  }, onMochipaySettingSuccess: (title, message, button, source, token, transactionId) => {
    flutter_inappwebview.callHandler('onMochipaySettingSuccess', {title, message, button, source, token, transactionId})
  }, onMochipaySettingFail: (message, source) => {
    flutter_inappwebview.callHandler('onMochipaySettingFail', {message, source})
  }
}