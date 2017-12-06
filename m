From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Wed, 06 Dec 2017 13:50:01 -0800
Message-ID: <20171206215001.Z_SthBK1i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51152 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752598AbdLFVuD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 16:50:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iio/adc/meson_saradc.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN drivers/iio/adc/meson_saradc.c~linux-next-git-rejects drivers/iio/adc/meson_saradc.c
--- a/drivers/iio/adc/meson_saradc.c~linux-next-git-rejects
+++ a/drivers/iio/adc/meson_saradc.c
@@ -756,11 +756,6 @@ err_adc_clk:
 	regmap_update_bits(priv->regmap, MESON_SAR_ADC_REG3,
 			   MESON_SAR_ADC_REG3_ADC_EN, 0);
 	meson_sar_adc_set_bandgap(indio_dev, false);
-<<<<<<< HEAD
-	clk_disable_unprepare(priv->sana_clk);
-err_sana_clk:
-=======
->>>>>>> linux-next/akpm-base
 	clk_disable_unprepare(priv->core_clk);
 err_core_clk:
 	regulator_disable(priv->vref);
@@ -783,11 +778,6 @@ static int meson_sar_adc_hw_disable(stru
 
 	regmap_update_bits(priv->regmap, MESON_SAR_ADC_REG3,
 			   MESON_SAR_ADC_REG3_ADC_EN, 0);
-<<<<<<< HEAD
-
-	meson_sar_adc_set_bandgap(indio_dev, false);
-=======
->>>>>>> linux-next/akpm-base
 
 	meson_sar_adc_set_bandgap(indio_dev, false);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
stringh-work-around-for-increased-stack-usage-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

