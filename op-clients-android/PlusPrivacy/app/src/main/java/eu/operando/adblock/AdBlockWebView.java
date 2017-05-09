package eu.operando.adblock;

import android.content.Context;
import android.util.AttributeSet;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;

/**
 * Created by Edy on 08-May-17.
 */

public class AdBlockWebView extends WebView {
    private OnPageFinishedListener listener;

    public void setOnPageFinishedListener(OnPageFinishedListener listener){
        this.listener = listener;
    }

    public AdBlockWebView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    private void init() {
        getSettings().setJavaScriptEnabled(true);
        setWebChromeClient(new WebChromeClient());
        setWebViewClient(getWebViewClient());
        getSettings().setBuiltInZoomControls(true);
        getSettings().setUseWideViewPort(true);
        getSettings().setDomStorageEnabled(true);
        getSettings().setLoadWithOverviewMode(true);
    }

    private WebViewClient getWebViewClient() {
        return new AdBlockClient(getContext()) {
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                if (listener != null)
                    listener.onPageFinished(url);
            }
        };
    }

    public interface OnPageFinishedListener {
        void onPageFinished(String url);
    }
}
