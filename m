Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04B5C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 02:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245580AbiDOCPx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 22:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbiDOCPx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 22:15:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704DF1A393
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 19:13:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C0BD621EB
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 02:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6202FC385A1;
        Fri, 15 Apr 2022 02:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649988805;
        bh=cCJT7GRyn1N+l/cEvym3eVl2X3LmfC4pc3YND5oM+14=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=jwLbhiIQ1LCwesVQc9EXO8Kkw1lNn45iYViU74UM+iDQBxRmABmjktA1vKQsLr66k
         zJiqt0bKiIFBSIZR2zoiYIaKCCDq5ybSNmk3UouNrmyPaiYObePsp2vxO0bz2yFLd8
         NjjyozvC+9aWGhuMh/w/KNdK1MXVK0XRgx59vP4k=
Date:   Thu, 14 Apr 2022 19:13:24 -0700
To:     joe@perches.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
Subject: [patch 01/14] MAINTAINERS: Broadcom internal lists aren't maintainers
Message-Id: <20220415021325.6202FC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: Broadcom internal lists aren't maintainers

Convert the broadcom internal list M: and L: entries to R: as
exploder email addresses are neither maintainers nor mailing lists.

Reorder the entries as necessary.

Link: https://lkml.kernel.org/r/04eb301f5b3adbefdd78e76657eff0acb3e3d87f.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   64 +++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

--- a/MAINTAINERS~maintainers-broadcom-internal-lists-arent-maintainers
+++ a/MAINTAINERS
@@ -3743,7 +3743,7 @@ F:	include/linux/platform_data/b53.h
 
 BROADCOM BCM2711/BCM2835 ARM ARCHITECTURE
 M:	Nicolas Saenz Julienne <nsaenz@kernel.org>
-L:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-rpi-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
@@ -3758,7 +3758,7 @@ BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM
 M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Ray Jui <rjui@broadcom.com>
 M:	Scott Branden <sbranden@broadcom.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 S:	Maintained
 T:	git git://github.com/broadcom/mach-bcm
 F:	arch/arm/mach-bcm/
@@ -3778,7 +3778,7 @@ F:	arch/mips/include/asm/mach-bcm47xx/*
 
 BROADCOM BCM4908 ETHERNET DRIVER
 M:	Rafał Miłecki <rafal@milecki.pl>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
@@ -3787,7 +3787,7 @@ F:	drivers/net/ethernet/broadcom/unimac.
 
 BROADCOM BCM4908 PINMUX DRIVER
 M:	Rafał Miłecki <rafal@milecki.pl>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-gpio@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/pinctrl/brcm,bcm4908-pinctrl.yaml
@@ -3797,7 +3797,7 @@ BROADCOM BCM5301X ARM ARCHITECTURE
 M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Hauke Mehrtens <hauke@hauke-m.de>
 M:	Rafał Miłecki <zajec5@gmail.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/boot/dts/bcm470*
@@ -3808,7 +3808,7 @@ F:	arch/arm/mach-bcm/bcm_5301x.c
 BROADCOM BCM53573 ARM ARCHITECTURE
 M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Rafał Miłecki <rafal@milecki.pl>
-L:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/boot/dts/bcm47189*
@@ -3816,7 +3816,7 @@ F:	arch/arm/boot/dts/bcm53573*
 
 BROADCOM BCM63XX ARM ARCHITECTURE
 M:	Florian Fainelli <f.fainelli@gmail.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 T:	git git://github.com/broadcom/stblinux.git
@@ -3830,7 +3830,7 @@ F:	drivers/usb/gadget/udc/bcm63xx_udc.*
 
 BROADCOM BCM7XXX ARM ARCHITECTURE
 M:	Florian Fainelli <f.fainelli@gmail.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 T:	git git://github.com/broadcom/stblinux.git
@@ -3848,21 +3848,21 @@ N:	bcm7120
 BROADCOM BDC DRIVER
 M:	Al Cooper <alcooperx@gmail.com>
 L:	linux-usb@vger.kernel.org
-L:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/usb/brcm,bdc.yaml
 F:	drivers/usb/gadget/udc/bdc/
 
 BROADCOM BMIPS CPUFREQ DRIVER
 M:	Markus Mayer <mmayer@broadcom.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
 F:	drivers/cpufreq/bmips-cpufreq.c
 
 BROADCOM BMIPS MIPS ARCHITECTURE
 M:	Florian Fainelli <f.fainelli@gmail.com>
-L:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-mips@vger.kernel.org
 S:	Maintained
 T:	git git://github.com/broadcom/stblinux.git
@@ -3928,53 +3928,53 @@ F:	drivers/net/wireless/broadcom/brcm802
 BROADCOM BRCMSTB GPIO DRIVER
 M:	Doug Berger <opendmb@gmail.com>
 M:	Florian Fainelli <f.fainelli@gmail.com>
-L:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/gpio/brcm,brcmstb-gpio.yaml
 F:	drivers/gpio/gpio-brcmstb.c
 
 BROADCOM BRCMSTB I2C DRIVER
 M:	Kamal Dasu <kdasu.kdev@gmail.com>
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-i2c@vger.kernel.org
-L:	bcm-kernel-feedback-list@broadcom.com
 S:	Supported
 F:	Documentation/devicetree/bindings/i2c/brcm,brcmstb-i2c.yaml
 F:	drivers/i2c/busses/i2c-brcmstb.c
 
 BROADCOM BRCMSTB UART DRIVER
 M:	Al Cooper <alcooperx@gmail.com>
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-serial@vger.kernel.org
-L:	bcm-kernel-feedback-list@broadcom.com
 S:	Maintained
 F:	Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
 F:	drivers/tty/serial/8250/8250_bcm7271.c
 
 BROADCOM BRCMSTB USB EHCI DRIVER
 M:	Al Cooper <alcooperx@gmail.com>
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-usb@vger.kernel.org
-L:	bcm-kernel-feedback-list@broadcom.com
 S:	Maintained
 F:	Documentation/devicetree/bindings/usb/brcm,bcm7445-ehci.yaml
 F:	drivers/usb/host/ehci-brcm.*
 
 BROADCOM BRCMSTB USB PIN MAP DRIVER
 M:	Al Cooper <alcooperx@gmail.com>
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-usb@vger.kernel.org
-L:	bcm-kernel-feedback-list@broadcom.com
 S:	Maintained
 F:	Documentation/devicetree/bindings/usb/brcm,usb-pinmap.yaml
 F:	drivers/usb/misc/brcmstb-usb-pinmap.c
 
 BROADCOM BRCMSTB USB2 and USB3 PHY DRIVER
 M:	Al Cooper <alcooperx@gmail.com>
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-kernel@vger.kernel.org
-L:	bcm-kernel-feedback-list@broadcom.com
 S:	Maintained
 F:	drivers/phy/broadcom/phy-brcm-usb*
 
 BROADCOM ETHERNET PHY DRIVERS
 M:	Florian Fainelli <f.fainelli@gmail.com>
-L:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/net/broadcom-bcm87xx.txt
@@ -3985,7 +3985,7 @@ F:	include/linux/brcmphy.h
 BROADCOM GENET ETHERNET DRIVER
 M:	Doug Berger <opendmb@gmail.com>
 M:	Florian Fainelli <f.fainelli@gmail.com>
-L:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
@@ -3999,7 +3999,7 @@ F:	include/linux/platform_data/mdio-bcm-
 BROADCOM IPROC ARM ARCHITECTURE
 M:	Ray Jui <rjui@broadcom.com>
 M:	Scott Branden <sbranden@broadcom.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 T:	git git://github.com/broadcom/stblinux.git
@@ -4027,7 +4027,7 @@ N:	stingray
 
 BROADCOM IPROC GBIT ETHERNET DRIVER
 M:	Rafał Miłecki <rafal@milecki.pl>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/brcm,amac.yaml
@@ -4036,7 +4036,7 @@ F:	drivers/net/ethernet/broadcom/unimac.
 
 BROADCOM KONA GPIO DRIVER
 M:	Ray Jui <rjui@broadcom.com>
-L:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/gpio/brcm,kona-gpio.txt
 F:	drivers/gpio/gpio-bcm-kona.c
@@ -4069,7 +4069,7 @@ F:	drivers/firmware/broadcom/*
 BROADCOM PMB (POWER MANAGEMENT BUS) DRIVER
 M:	Rafał Miłecki <rafal@milecki.pl>
 M:	Florian Fainelli <f.fainelli@gmail.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
 T:	git git://github.com/broadcom/stblinux.git
@@ -4085,7 +4085,7 @@ F:	include/linux/bcma/
 
 BROADCOM SPI DRIVER
 M:	Kamal Dasu <kdasu.kdev@gmail.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml
 F:	drivers/spi/spi-bcm-qspi.*
@@ -4094,7 +4094,7 @@ F:	drivers/spi/spi-iproc-qspi.c
 
 BROADCOM STB AVS CPUFREQ DRIVER
 M:	Markus Mayer <mmayer@broadcom.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/cpufreq/brcm,stb-avs-cpu-freq.txt
@@ -4102,7 +4102,7 @@ F:	drivers/cpufreq/brcmstb*
 
 BROADCOM STB AVS TMON DRIVER
 M:	Markus Mayer <mmayer@broadcom.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/thermal/brcm,avs-tmon.yaml
@@ -4110,7 +4110,7 @@ F:	drivers/thermal/broadcom/brcmstb*
 
 BROADCOM STB DPFE DRIVER
 M:	Markus Mayer <mmayer@broadcom.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/devicetree/bindings/memory-controllers/brcm,dpfe-cpu.yaml
@@ -4119,8 +4119,8 @@ F:	drivers/memory/brcmstb_dpfe.c
 BROADCOM STB NAND FLASH DRIVER
 M:	Brian Norris <computersforpeace@gmail.com>
 M:	Kamal Dasu <kdasu.kdev@gmail.com>
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-mtd@lists.infradead.org
-L:	bcm-kernel-feedback-list@broadcom.com
 S:	Maintained
 F:	drivers/mtd/nand/raw/brcmnand/
 F:	include/linux/platform_data/brcmnand.h
@@ -4129,7 +4129,7 @@ BROADCOM STB PCIE DRIVER
 M:	Jim Quinlan <jim2101024@gmail.com>
 M:	Nicolas Saenz Julienne <nsaenz@kernel.org>
 M:	Florian Fainelli <f.fainelli@gmail.com>
-M:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-pci@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/pci/brcm,stb-pcie.yaml
@@ -4137,7 +4137,7 @@ F:	drivers/pci/controller/pcie-brcmstb.c
 
 BROADCOM SYSTEMPORT ETHERNET DRIVER
 M:	Florian Fainelli <f.fainelli@gmail.com>
-L:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/broadcom/bcmsysport.*
@@ -4154,7 +4154,7 @@ F:	drivers/net/ethernet/broadcom/tg3.*
 
 BROADCOM VK DRIVER
 M:	Scott Branden <scott.branden@broadcom.com>
-L:	bcm-kernel-feedback-list@broadcom.com
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 S:	Supported
 F:	drivers/misc/bcm-vk/
 F:	include/uapi/linux/misc/bcm_vk.h
@@ -17648,8 +17648,8 @@ K:	\bTIF_SECCOMP\b
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) Broadcom BRCMSTB DRIVER
 M:	Al Cooper <alcooperx@gmail.com>
+R:	Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-mmc@vger.kernel.org
-L:	bcm-kernel-feedback-list@broadcom.com
 S:	Maintained
 F:	drivers/mmc/host/sdhci-brcmstb*
 
_
