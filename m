From: akpm@linux-foundation.org
Subject: +
 mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch added to -mm tree
Date: Tue, 19 Nov 2013 16:25:27 -0800
Message-ID: <528c0177.3xboBlnjuOJBqmdA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3KTAZ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 19:25:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, akpm@linux-foundation.org

Subject: + mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch added to -mm tree
To: akpm@linux-foundation.org,isimatu.yasuaki@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 16:25:27 -0800


The patch titled
     Subject: mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix
has been added to the -mm tree.  Its filename is
     mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch

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
Subject: mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix

tweak comment

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix
+++ a/mm/page_alloc.c
@@ -3969,7 +3969,7 @@ static void setup_zone_migrate_reserve(s
 			}
 		} else if (!old_reserve) {
 			/*
-			 * When boot time, we don't need scan whole zone
+			 * At boot time we don't need to scan the whole zone
 			 * for turning off MIGRATE_RESERVE.
 			 */
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

