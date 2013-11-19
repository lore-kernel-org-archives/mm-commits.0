From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 19 Nov 2013 13:28:11 -0800
Message-ID: <528bd7eb.tQvoRBYTSKCZDNoO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3KSV2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 16:28:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 13:28:11 -0800


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

 drivers/i2c/busses/i2c-exynos5.c |    4 ----
 drivers/i2c/busses/i2c-st.c      |    4 ----
 2 files changed, 8 deletions(-)

diff -puN drivers/i2c/busses/i2c-exynos5.c~linux-next-git-rejects drivers/i2c/busses/i2c-exynos5.c
--- a/drivers/i2c/busses/i2c-exynos5.c~linux-next-git-rejects
+++ a/drivers/i2c/busses/i2c-exynos5.c
@@ -535,11 +535,7 @@ static int exynos5_i2c_xfer_msg(struct e
 	i2c->msg_ptr = 0;
 	i2c->trans_done = 0;
 
-<<<<<<< HEAD
 	reinit_completion(&i2c->msg_complete);
-=======
-	INIT_COMPLETION(i2c->msg_complete);
->>>>>>> linux-next/akpm-base
 
 	exynos5_i2c_message_start(i2c, stop);
 
diff -puN drivers/i2c/busses/i2c-st.c~linux-next-git-rejects drivers/i2c/busses/i2c-st.c
--- a/drivers/i2c/busses/i2c-st.c~linux-next-git-rejects
+++ a/drivers/i2c/busses/i2c-st.c
@@ -615,11 +615,7 @@ static int st_i2c_xfer_msg(struct st_i2c
 	c->result	= 0;
 	c->stop		= is_last;
 
-<<<<<<< HEAD
 	reinit_completion(&i2c_dev->complete);
-=======
-	INIT_COMPLETION(i2c_dev->complete);
->>>>>>> linux-next/akpm-base
 
 	ctl = SSC_CTL_EN | SSC_CTL_MS |	SSC_CTL_EN_RX_FIFO | SSC_CTL_EN_TX_FIFO;
 	st_i2c_set_bits(i2c_dev->base + SSC_CTL, ctl);
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

