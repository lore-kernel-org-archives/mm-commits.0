From: akpm@linux-foundation.org
Subject: +
 maintainers-update-arm-oxnas-platform-support-patterns-fix.patch added to
 -mm tree
Date: Mon, 29 Jan 2018 15:40:38 -0800
Message-ID: <5a6fb0f6.FdJj+GEy7zfxbS9I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50948 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbeA2Xkk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 18:40:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, daniel@makrotopia.org, joe@perches.com, narmstrong@baylibre.com, mm-commits@vger.kernel.org


The patch titled
     Subject: maintainers-update-arm-oxnas-platform-support-patterns-fix
has been added to the -mm tree.  Its filename is
     maintainers-update-arm-oxnas-platform-support-patterns-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-arm-oxnas-platform-support-patterns-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-arm-oxnas-platform-support-patterns-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maintainers-update-arm-oxnas-platform-support-patterns-fix

Crunch into a single globbed term, per Arnd

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Golle <daniel@makrotopia.org>
Cc: Joe Perches <joe@perches.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-arm-oxnas-platform-support-patterns-fix MAINTAINERS
--- a/MAINTAINERS~maintainers-update-arm-oxnas-platform-support-patterns-fix
+++ a/MAINTAINERS
@@ -1735,9 +1735,7 @@ L:	linux-arm-kernel@lists.infradead.org
 L:	linux-oxnas@lists.tuxfamily.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-oxnas/
-F:	arch/arm/boot/dts/ox8*.dtsi
-F:	arch/arm/boot/dts/ox810se-wd-mbwe.dts
-F:	arch/arm/boot/dts/ox820-cloudengines-pogoplug-series-3.dts
+F:	arch/arm/boot/dts/ox8*.dts*
 N:	oxnas
 
 ARM/PALM TREO SUPPORT
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
fs-crypto-hooksc-fix-build-with-gcc-444.patch
maintainers-update-arm-oxnas-platform-support-patterns-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

