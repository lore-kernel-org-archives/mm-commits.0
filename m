From: akpm@linux-foundation.org
Subject: + gru-remove-references-to-the-obsolete-global-status-handle.patch added to -mm tree
Date: Mon, 08 Jun 2009 16:11:34 -0700
Message-ID: <200906082311.n58NBYBM031212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756430AbZFHXLe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 19:11:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: remove references to the obsolete global status handle
has been added to the -mm tree.  Its filename is
     gru-remove-references-to-the-obsolete-global-status-handle.patch

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
Subject: gru: remove references to the obsolete global status handle
From: Jack Steiner <steiner@sgi.com>

Delete references to the SGI GRU GSH hardware resources.  These GRU
resources have been deleted from the hardware.  (These resources have
never benn used, anyway).

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gruhandles.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/misc/sgi-gru/gruhandles.h~gru-remove-references-to-the-obsolete-global-status-handle drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~gru-remove-references-to-the-obsolete-global-status-handle
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -39,7 +39,6 @@
 #define GRU_NUM_CBE		128
 #define GRU_NUM_TFH		128
 #define GRU_NUM_CCH		16
-#define GRU_NUM_GSH		1
 
 /* Maximum resource counts that can be reserved by user programs */
 #define GRU_NUM_USER_CBR	GRU_NUM_CBE
@@ -56,7 +55,6 @@
 #define GRU_CBE_BASE		(GRU_MCS_BASE + 0x10000)
 #define GRU_TFH_BASE		(GRU_MCS_BASE + 0x18000)
 #define GRU_CCH_BASE		(GRU_MCS_BASE + 0x20000)
-#define GRU_GSH_BASE		(GRU_MCS_BASE + 0x30000)
 
 /* User gseg constants */
 #define GRU_GSEG_STRIDE		(4 * 1024 * 1024)
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch
gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dump-chiplet-state-update.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-dynamic-allocation-of-kernel-contexts-update.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
gru-update-gru-kernel-self-tests.patch
gru-update-gru-kernel-self-tests-fix.patch
gru-update-to-rev-09-of-gru-spec.patch
gru-fix-cache-coherency-issues-with-instruction-retry.patch
gru-add-user-request-to-explicitly-unload-a-gru-context.patch
gru-fix-automatic-retry-of-gru-instruction-failures.patch
gru-collect-per-context-user-statistics.patch
gru-delete-user-request-for-fetching-chiplet-status.patch
gru-cleanup-gru-inline-functions.patch
gru-generic-infrastructure-for-context-options.patch
gru-add-user-request-to-specify-gru-slice.patch
gru-fix-potential-use-after-free-when-purging-gru-tlbs.patch
gru-fixes-to-grudump-utility.patch
gru-remove-references-to-the-obsolete-global-status-handle.patch
gru-copyright-fixes.patch

