package eu.operando.activity;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import java.net.URLEncoder;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import eu.operando.R;

public class BrowserActivity extends AppCompatActivity {
    private ImageView goBtn;
    private ImageView backBtn;
    private WebView webView;
    private EditText urlEt;

    public static void start(Context context) {
        Intent starter = new Intent(context, BrowserActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_browser);
        initUI();
    }

    private void initUI() {
        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        goBtn = ((ImageView) findViewById(R.id.btn_go));
        backBtn = ((ImageView) findViewById(R.id.btn_back));
        urlEt = ((EditText) findViewById(R.id.urlET));

        initWebView();
        initAddressBar();

    }

    private void initAddressBar() {
        urlEt.setSelectAllOnFocus(true);
        urlEt.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_GO) {
                    go();
                    return true;
                }
                return false;
            }
        });

        goBtn.setColorFilter(getResources().getColor(R.color.colorAccent));
        goBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                go();
            }
        });

        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                goBack();
            }
        });
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void initWebView() {
        webView = ((WebView) findViewById(R.id.webView));
        webView.getSettings().setJavaScriptEnabled(true);
        webView.setWebChromeClient(new WebChromeClient());
        webView.setWebViewClient(getWebViewClient());
//        webView.setInitialScale(1);
        webView.getSettings().setBuiltInZoomControls(true);
        webView.getSettings().setUseWideViewPort(true);
        webView.getSettings().setDomStorageEnabled(true);
        webView.getSettings().setLoadWithOverviewMode(true);
        webView.loadUrl("http://www.google.ro");

    }

    private WebViewClient getWebViewClient() {
        return new WebViewClient() {
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                urlEt.setText(url);
                urlEt.clearFocus();
                hideKeyboard();
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return false;
            }

        };
    }

    private void goBack() {
        onBackPressed();
    }

    private void go() {
        String url = urlEt.getText().toString();
        Pattern p = Pattern.compile("^(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]");
        Matcher m = p.matcher(url);
        if(!m.matches()){
            url = "http://www.google.com/search?q="+ URLEncoder.encode(url);
        }
        url = url.toLowerCase().startsWith("http://") || url.toLowerCase().startsWith("https://") ? url : ("http://" + url);
        webView.loadUrl(url);
        Log.e("url", url);
    }

    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            finish();
        }
    }

    private void hideKeyboard() {
        View view = this.getCurrentFocus();
        if (view != null) {
            InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }
}
