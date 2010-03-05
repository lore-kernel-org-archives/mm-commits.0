From: akpm@linux-foundation.org
Subject: [folded] gpio-pca953xc-add-interrupt-handling-capability-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:26:23 -0800
Message-ID: <201003052126.o25LQNuN028607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754740Ab0CEV1l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:27:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, eric.y.miao@gmail.com, haojian.zhuang@gmail.com, maz@misterjones.org, ncase@xes-inc.com, mm-commits@vger.kernel.org


The patch titled
     gpio-pca953xc-add-interrupt-handling-capability-fix
has been removed from the -mm tree.  Its filename was
     gpio-pca953xc-add-interrupt-handling-capability-fix.patch

This patch was dropped because it was folded into gpio-pca953xc-add-interrupt-handling-capability.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-pca953xc-add-interrupt-handling-capability-fix
From: Andrew Morton <akpm@linux-foundation.org>

The compiler does inlining for us nowadays.

Cc: David Brownell <david-b@pacbell.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Marc Zyngier <maz@misterjones.org>
Cc: Nate Case <ncase@xes-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/pca953x.c~gpio-pca953xc-add-interrupt-handling-capability-fix drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953xc-add-interrupt-handling-capability-fix
+++ a/drivers/gpio/pca953x.c
@@ -289,7 +289,7 @@ static struct irq_chip pca953x_irq_chip 
 	.set_type		= pca953x_irq_set_type,
 };
 
-static inline uint16_t pca953x_irq_pending(struct pca953x_chip *chip)
+static uint16_t pca953x_irq_pending(struct pca953x_chip *chip)
 {
 	uint16_t cur_stat;
 	uint16_t old_stat;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
vmscan-check-high-watermark-after-shrink-zone.patch
mm-remove-function-free_hot_page.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
uml-linec-avoid-null-pointer-dereference.patch
lib-more-scalable-list_sort.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch

