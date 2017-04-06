package eu.operando.adapter

import android.content.Context
import android.support.v4.app.Fragment
import android.support.v4.app.FragmentManager
import android.support.v4.app.FragmentStatePagerAdapter
import android.support.v4.view.PagerAdapter
import eu.operando.fragment.TabFragment
import it.neokree.materialtabs.MaterialTabHost

/**
 * Created by Edy on 04-Apr-17.
 */
class TabPagerAdapter(fm: FragmentManager, val context: Context, val tabHost: MaterialTabHost) : FragmentStatePagerAdapter(fm) {
    private var fragments: ArrayList<TabFragment> = ArrayList()

    override fun getItem(position: Int): Fragment {
        return fragments[position]
    }

    override fun getCount(): Int {
        return fragments.size
    }

    override fun getItemPosition(`object`: Any?): Int {
        return PagerAdapter.POSITION_NONE
    }
    init {
        fragments.add(TabFragment.newInstance("www.google.ro"))
    }
}