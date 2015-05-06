From: akpm@linux-foundation.org
Subject: [merged]
 zram-add-designated-reviewer-for-zram-in-maintainers.patch removed from -mm tree
Date: Wed, 06 May 2015 11:58:07 -0700
Message-ID: <554a643f.laPqsPgpoP8TnrW5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbEFS6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 14:58:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add Designated Reviewer for zram in MAINTAINERS
has been removed from the -mm tree.  Its filename was
     zram-add-designated-reviewer-for-zram-in-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: add Designated Reviewer for zram in MAINTAINERS

Sergey Senozhatsky has contributed/reviewed to zram for a long time.  He
is really helpful for maintaining zram so I want for him to continue
helping me as Designated Reviewer unless he hates it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~zram-add-designated-reviewer-for-zram-in-maintainers MAINTAINERS
--- a/MAINTAINERS~zram-add-designated-reviewer-for-zram-in-maintainers
+++ a/MAINTAINERS
@@ -11037,6 +11037,7 @@ F:	drivers/media/pci/zoran/
 ZRAM COMPRESSED RAM BLOCK DEVICE DRVIER
 M:	Minchan Kim <minchan@kernel.org>
 M:	Nitin Gupta <ngupta@vflare.org>
+R:	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/block/zram/
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-remove-obsolete-zram_debug-option.patch
zsmalloc-remove-obsolete-zsmalloc_debug.patch
zram-add-compact-sysfs-entry-to-documentation.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-reorganize-code-layout.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-from-zram_add.patch
zram-close-race-by-open-overriding.patch
zram-add-dynamic-device-add-remove-functionality.patch

