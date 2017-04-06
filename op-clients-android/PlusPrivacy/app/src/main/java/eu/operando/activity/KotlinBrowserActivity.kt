package eu.operando.activity

import android.content.Context
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v4.app.FragmentPagerAdapter
import android.support.v4.view.ViewPager
import eu.operando.R
import eu.operando.fragment.TabFragment
import it.neokree.materialtabs.MaterialTab
import it.neokree.materialtabs.MaterialTabHost

fun start(context: Context) {
    val starterIntent = Intent(context, KotlinBrowserActivity::class.java)
    context.startActivity(starterIntent)
}

class KotlinBrowserActivity : AppCompatActivity() {
    private lateinit var tabHost: MaterialTabHost
    private lateinit var viewPager: ViewPager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_browser)
        initUI()

    }

    private fun initUI() {
        findViewById(R.id.back).setOnClickListener {
            finish()
        }

        tabHost = findViewById(R.id.tabhost) as MaterialTabHost
        viewPager = findViewById(R.id.tab_view_pager) as ViewPager

        viewPager.adapter = object : FragmentPagerAdapter(supportFragmentManager) {
            val fragment = TabFragment.newInstance("www.google.ro")
            override fun getItem(position: Int): Fragment {
                return fragment
            }

            override fun getCount(): Int {
                return 1
            }
        }

        val tab = MaterialTab(this,false)
        tab.setText("Tab 1")
        tabHost.addTab(tab)
    }

}

