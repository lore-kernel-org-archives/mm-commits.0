From: akpm@linux-foundation.org
Subject: [folded-dropped] sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:53:34 -0700
Message-ID: <20121004235335.2AA185C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:61646 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2JDXxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:53:37 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so75838wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:53:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch

This patch was dropped because it was folded into sections-fix-section-conflicts-in-drivers-macintosh.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes

ERROR: space prohibited before open square bracket '['
#20: FILE: drivers/macintosh/macio_asic.c:751:
+static const struct pci_device_id __devinitconst pci_ids [] = { {

total: 1 errors, 0 warnings, 8 lines checked

./patches/sections-fix-section-conflicts-in-drivers-macintosh.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/macio_asic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/macintosh/macio_asic.c~sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes drivers/macintosh/macio_asic.c
--- a/drivers/macintosh/macio_asic.c~sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes
+++ a/drivers/macintosh/macio_asic.c
@@ -748,7 +748,7 @@ static void __devexit macio_pci_remove(s
  * MacIO is matched against any Apple ID, it's probe() function
  * will then decide wether it applies or not
  */
-static const struct pci_device_id __devinitconst pci_ids [] = { {
+static const struct pci_device_id __devinitconst pci_ids[] = { {
 	.vendor		= PCI_VENDOR_ID_APPLE,
 	.device		= PCI_ANY_ID,
 	.subvendor	= PCI_ANY_ID,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

