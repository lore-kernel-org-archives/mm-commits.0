From: akpm@linux-foundation.org
Subject: [folded] checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:49:28 -0800
Message-ID: <20120110224929.7B080200079@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:38898 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2AJWtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:49:31 -0500
Received: by eaak10 with SMTP id k10so3438eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:49:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch

This patch was dropped because it was folded into checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes

Someone doesn't feed checkpatch patches through checkpatch!!

Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes
+++ a/scripts/checkpatch.pl
@@ -2226,7 +2226,7 @@ sub process {
 				ERROR("POINTER_LOCATION",
 				      "\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
 			}
-		} 
+		}
 		while ($line =~ m{(\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident))}g) {
 			#print "BB<$1>\n";
 			my ($from, $to, $ident) = ($2, $2, $3);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mempool-fix-first-round-failure-behavior.patch
backlight-convert-pwm_bl-to-dev_pm_ops.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

