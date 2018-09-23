<?php

namespace OnePageCheckout;

use Shopware\Components\Plugin\Context\InstallContext;
use Shopware\Components\Plugin\Context\UninstallContext;
use Shopware\Components\Plugin\Context\UpdateContext;
use Shopware\Components\Plugin\Context\ActivateContext;
use Shopware\Components\Plugin\Context\DeactivateContext;
use Symfony\Component\DependencyInjection\ContainerBuilder;

class OnePageCheckout extends \Shopware\Components\Plugin
{
    public static function getSubscribedEvents()
    {
        return [];
    }

	public function install(InstallContext $context)
    {
        return true;
	}

	public function update(UpdateContext $context)
    {
		return true;
	}

	public function activate(ActivateContext $context)
    {
		return true;
	}

	public function deactivate(DeactivateContext $context)
    {
		return true;
	}

	public function uninstall(UninstallContext $context)
    {
		return true;
	}

    public function build(ContainerBuilder $container)
    {
        $container->setParameter('maxia.onepage_checkout.plugin_dir', $this->getPath().'/');
        $container->setParameter('maxia.onepage_checkout.resources_dir', $this->getPath().'/Resources/');
        parent::build($container);
    }
}
