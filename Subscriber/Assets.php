<?php

namespace OnePageCheckout\Subscriber;

use Enlight\Event\SubscriberInterface;
use Shopware\Bundle\StoreFrontBundle\Service;
use Shopware\Components\Theme\LessDefinition;
use Doctrine\Common\Collections\ArrayCollection;

class Assets implements SubscriberInterface
{
    private $resourcesDir;
    private $addJsFiles = [
        'js/jquery.onepagecheckout.js',
    ];

    public static function getSubscribedEvents()
    {
        return [
            'Theme_Compiler_Collect_Javascript_Files_FilterResult' => ['addJsFiles', 1000],
            'Enlight_Controller_Action_PreDispatch' => ['preDispatch', 202],
            'Theme_Compiler_Collect_Plugin_Less' => 'addLessFiles',
        ];
    }

    public function __construct($resourcesDir)
    {
        $this->resourcesDir = $resourcesDir;
    }

    /**
     * Registers view directory
     * @param \Enlight_Controller_ActionEventArgs $args
     */
    public function preDispatch(\Enlight_Controller_ActionEventArgs $args)
    {
        $module = $args['request']->getModuleName();

        if ( ! in_array($module, ['frontend', 'widgets'])) {
            return;
        }

        $view = $args->getSubject()->View();
        $view->addTemplateDir($this->resourcesDir.'views/');
    }

    public function addJsFiles(\Enlight_Event_EventArgs $args)
    {
        $jsFiles = $this->addJsFiles;

        foreach ($jsFiles as &$file)
            $file = $this->resourcesDir.$file;

        return array_merge($args->getReturn(), $jsFiles);
    }

    public function addLessFiles()
    {
        $less = new LessDefinition(
            [],
            [
                $this->resourcesDir . 'less/all.less',
            ],
            $this->resourcesDir . 'less/'
        );
        return new ArrayCollection([$less]);
    }
}