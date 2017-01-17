From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 17 Jan 2017 11:28:05 -0800
Message-ID: <587e7045.RW545ra1q11Yxo06%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdAQTib (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 14:38:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/rx.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN net/mac80211/rx.c~linux-next-git-rejects net/mac80211/rx.c
--- a/net/mac80211/rx.c~linux-next-git-rejects
+++ a/net/mac80211/rx.c
@@ -3934,7 +3934,6 @@ static bool ieee80211_invoke_fast_rx(str
 	if (fast_rx->internal_forward) {
 		struct sk_buff *xmit_skb = NULL;
 		bool multicast = is_multicast_ether_addr(skb->data);
-<<<<<<< HEAD
 
 		if (multicast) {
 			xmit_skb = skb_copy(skb, GFP_ATOMIC);
@@ -3943,16 +3942,6 @@ static bool ieee80211_invoke_fast_rx(str
 			skb = NULL;
 		}
 
-=======
-
-		if (multicast) {
-			xmit_skb = skb_copy(skb, GFP_ATOMIC);
-		} else if (sta_info_get(rx->sdata, skb->data)) {
-			xmit_skb = skb;
-			skb = NULL;
-		}
-
->>>>>>> linux-next/akpm-base
 		if (xmit_skb) {
 			/*
 			 * Send to wireless media and increase priority by 256
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

