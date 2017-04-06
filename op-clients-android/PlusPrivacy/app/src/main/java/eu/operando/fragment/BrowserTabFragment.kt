package eu.operando.fragment

import android.content.Context
import android.os.Bundle
import android.support.annotation.Nullable
import android.support.v4.app.Fragment
import android.util.Patterns
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputMethodManager
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.EditText
import android.widget.ImageView
import eu.operando.R
import org.adblockplus.libadblockplus.android.webview.AdblockWebView
import java.net.URLEncoder

/**
 * Created by Edy on 05-Apr-17.
 */

fun newInstance(@Nullable url: String): BrowserTabFragment {
    val fragment = BrowserTabFragment()
    val args = Bundle()
    args.putString("url", url)
    fragment.arguments = args
    return fragment
}

class BrowserTabFragment : Fragment() {
    private lateinit var goBtn: ImageView
    private lateinit var backBtn: ImageView
    private lateinit var webView: AdblockWebView
    private lateinit var urlEt: EditText

    fun loadUrl(url: String) {
        urlEt.setText(url)
        go()
    }

    override fun onCreateView(inflater: LayoutInflater?, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val rootView = LayoutInflater.from(activity).inflate(R.layout.fragment_browser_tab, container, false)
        initUI(rootView)
        return rootView
    }

    private fun initUI(rootView: View) {
        goBtn = rootView.findViewById(R.id.btn_go) as ImageView
        backBtn = rootView.findViewById(R.id.btn_back) as ImageView
        urlEt = rootView.findViewById(R.id.urlET) as EditText
        webView = (rootView.findViewById(R.id.webView) as AdblockWebView).apply {
            isAdblockEnabled = true
            settings.javaScriptEnabled = true
            setWebChromeClient(WebChromeClient())
            setWebViewClient(getWebViewClient())
            setInitialScale(1)
            loadUrl(arguments.getString("url", "www.google.ro"))
        }

        initAddressBar()
    }

    private fun initAddressBar() {
        urlEt.setOnEditorActionListener { _, actionId, _ ->
            if (actionId == EditorInfo.IME_ACTION_GO) {
                go()
                true
            } else {
                false
            }
        }

        goBtn.setColorFilter(resources.getColor(R.color.colorAccent))
        goBtn.setOnClickListener { go() }
        backBtn.setOnClickListener { goBack() }
    }

    private fun goBack() {
        if (webView.canGoBack()) {
            webView.goBack()
        } else {
            activity.finish()
        }
    }


    private fun getWebViewClient(): WebViewClient = object : WebViewClient() {
        override fun onPageFinished(view: WebView?, url: String?) {
            super.onPageFinished(view, url)
            urlEt.setText(url)
            urlEt.clearFocus()
            hideKeyboard()
        }
    }


    private fun hideKeyboard() {
        activity.currentFocus?.windowToken?.let {
            (activity.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager?)?.hideSoftInputFromWindow(it, 0)
        }
    }

    private fun go() {
        var url = urlEt.text.toString()
        if (!Patterns.WEB_URL.matcher(url).matches()) {
            url = "http://www.google.com/search?q=" + URLEncoder.encode(url, "UTF-8")
            url = when {
                url.startsWith("http://") || url.startsWith("https://") -> url
                else -> "http://" + url
            }

            webView.loadUrl(url)
        }
    }


}
