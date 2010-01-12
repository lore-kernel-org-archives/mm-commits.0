From: akpm@linux-foundation.org
Subject: + sort-introduce-generic-list_sort-function-v3-checkpatch-fixes.patch added to -mm tree
Date: Mon, 11 Jan 2010 23:51:42 -0800
Message-ID: <201001120751.o0C7pg4U023924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027Ab0ALHwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 02:52:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, david@fromorbit.com


The patch titled
     sort-introduce-generic-list_sort-function-v3-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     sort-introduce-generic-list_sort-function-v3-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sort-introduce-generic-list_sort-function-v3-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#20: FILE: lib/sort.c:221:
+EXPORT_SYMBOL(list_sort);

total: 0 errors, 1 warnings, 4 lines checked

./patches/sort-introduce-generic-list_sort-function-v3.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/sort.c~sort-introduce-generic-list_sort-function-v3-checkpatch-fixes lib/sort.c
--- a/lib/sort.c~sort-introduce-generic-list_sort-function-v3-checkpatch-fixes
+++ a/lib/sort.c
@@ -217,5 +217,4 @@ void list_sort(void *priv, struct list_h
 	list->prev->next = head;
 	list->prev = head;
 }
-
 EXPORT_SYMBOL(list_sort);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sort-introduce-generic-list_sort-function-v3-checkpatch-fixes.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

