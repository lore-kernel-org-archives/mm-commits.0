From: akpm@linux-foundation.org
Subject: [merged] sdhci-orphan-driver-and-list.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:36:40 -0700
Message-ID: <200909222036.n8MKaeRJ030266__33888.8100501665$1253651860$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbZIVUhO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre@ossman.eu, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     sdhci: orphan driver and list
has been removed from the -mm tree.  Its filename was
     sdhci-orphan-driver-and-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdhci: orphan driver and list
From: Pierre Ossman <pierre@ossman.eu>

Remove myself as maintainer from the sdhci driver and steer people
towards the new MMC list for discussing it.

Signed-off-by: Pierre Ossman <pierre@ossman.eu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN MAINTAINERS~sdhci-orphan-driver-and-list MAINTAINERS
--- a/MAINTAINERS~sdhci-orphan-driver-and-list
+++ a/MAINTAINERS
@@ -4533,20 +4533,20 @@ S:	Maintained
 F:	drivers/mmc/host/sdricoh_cs.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) DRIVER
-M:	Pierre Ossman <pierre@ossman.eu>
-L:	sdhci-devel@lists.ossman.eu
-S:	Maintained
+S:     Orphan
+L:     linux-mmc@vger.kernel.org
+F:     drivers/mmc/host/sdhci.*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE, OPEN FIRMWARE BINDINGS (SDHCI-OF)
 M:	Anton Vorontsov <avorontsov@ru.mvista.com>
 L:	linuxppc-dev@ozlabs.org
-L:	sdhci-devel@lists.ossman.eu
+L:     linux-mmc@vger.kernel.org
 S:	Maintained
-F:	drivers/mmc/host/sdhci.*
+F:     drivers/mmc/host/sdhci-of.*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) SAMSUNG DRIVER
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	sdhci-devel@lists.ossman.eu
+L:     linux-mmc@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c.c
 
_

Patches currently in -mm which might be from pierre@ossman.eu are

origin.patch
linux-next.patch
sdio-do-not-ignore-mmc_vdd_165_195.patch
tmio_mmc-optionally-support-using-platform-clock.patch
sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch
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
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired-fix-for-the-db-clock-failure-message.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag-update.patch
sdio-add-cd-disable-support.patch
sdio-add-cd-disable-support-cleanup.patch
sdhci-be-more-strict-with-get_min_clock-usage.patch
sdhci-of-fix-sd-clock-calculation.patch
sdhci-of-avoid-writing-reserved-bits-into-host-control-register.patch
sdhci-of-fix-high-speed-cards-recognition.patch
powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch
sdhci-of-dont-hard-code-inverted-write-protect-quirk.patch
sdhci-of-cleanup-esdhcs-set_clock-a-little-bit.patch
powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards.patch
sdhci-increase-timeout-for-internal-clock-stabilization.patch

