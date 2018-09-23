# One Page Checkout for Shopware

Combines all checkout steps on one page.  

## Installing

<pre>
cd Shopware/custom/plugins
git clone https://github.com/maxia/sw-onepagecheckout.git OnePageCheckout
cd ../../
./bin/console sw:plugin:refresh
./bin/console sw:plugin:install --activate OnePageCheckout
./bin/console sw:cache:clear
./bin/console sw:theme:cache:generate
</pre>

## License

[MIT](https://raw.github.com/maxia/sw-onepagecheckout/master/LICENSE)