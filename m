From: akpm@linux-foundation.org
Subject: [folded] arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag-update.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:40:11 -0700
Message-ID: <200909222140.n8MLeB5r026641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbZIVVk2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:40:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com, matt@console-pimps.org, philipl@overt.


The patch titled
     arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag-update
has been removed from the -mm tree.  Its filename was
     arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag-update.patch

This patch was dropped because it was folded into arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag-update
From: Adrian Hunter <adrian.hunter@nokia.com>

Specify MMC capabilities and set the power-saving flag for RX51.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Cc: "Madhusudhan" <madhu.cr@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/board-rx51-peripherals.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/arm/mach-omap2/board-rx51-peripherals.c~arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag-update arch/arm/mach-omap2/board-rx51-peripherals.c
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c~arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag-update
+++ a/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -104,7 +104,6 @@ static struct twl4030_hsmmc_info mmc[] =
 		.gpio_cd	= 160,
 		.gpio_wp	= -EINVAL,
 		.power_saving	= true,
-		.caps		= MMC_CAP_SD,
 	},
 	{
 		.name		= "internal",
@@ -112,8 +111,8 @@ static struct twl4030_hsmmc_info mmc[] =
 		.wires		= 8,
 		.gpio_cd	= -EINVAL,
 		.gpio_wp	= -EINVAL,
+		.nonremovable	= true,
 		.power_saving	= true,
-		.caps		= MMC_CAP_MMC | MMC_CAP_NONREMOVABLE,
 	},
 	{}	/* Terminator */
 };
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
mmc-add-enable-and-disable-methods-to-mmc-host.patch
mmc-allow-host-claim-release-nesting.patch
mmc-add-mmc_cap_nonremovable-host-capability.patch
mmc-add-ability-to-save-power-by-powering-off-cards.patch
mmc-add-mmc-card-sleep-and-awake-support.patch
mmc-power-off-once-at-removal.patch
mmc-check-status-after-mmc-switch-command.patch
omap_hsmmc-add-debugfs-entry-host-registers.patch
omap_hsmmc-make-use-of-new-enable-disable-interface.patch
arm-omap-mmc-twl4030-add-context-loss-counter-support.patch
omap_hsmmc-keep-track-of-power-mode.patch
omap_hsmmc-context-save-restore-support.patch
omap_hsmmc-set-open-drain-bit-correctly.patch
omap_hsmmc-ensure-workqueues-are-empty-before-suspend.patch
omap_hsmmc-fix-scatter-gather-list-sanity-checking.patch
omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability.patch
omap_hsmmc-support-for-deeper-power-saving-states.patch
arm-omap-mmc-twl4030-add-regulator-sleep-wake-function.patch
omap_hsmmc-put-mmc-regulator-to-sleep.patch
omap_hsmmc-add-mmc-card-sleep-and-awake-support.patch
omap_hsmmc-fix-null-pointer-dereference.patch
omap_hsmmc-cleanup-macro-usage.patch
omap_hsmmc-clear-interrupt-status-after-init-sequence.patch
omap_hsmmc-cater-for-weird-cmd6-behaviour.patch
omap_hsmmc-prevent-races-with-irq-handler.patch
omap_hsmmc-code-refactoring.patch
omap_hsmmc-protect-the-card-when-the-cover-is-open.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag-update.patch

