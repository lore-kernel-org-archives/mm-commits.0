From: akpm@linux-foundation.org
Subject: + mm-document-improved-handling-of-swappiness==0-fix.patch added
 to -mm tree
Date: Fri, 24 Jan 2014 12:31:43 -0800
Message-ID: <52e2cdaf.4qbP+7rQbA2vpea0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaAXUbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 15:31:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, atomlin@redhat.com, akpm@linux-foundation.org

Subject: + mm-document-improved-handling-of-swappiness==0-fix.patch added to -mm tree
To: akpm@linux-foundation.org,atomlin@redhat.com,rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 12:31:43 -0800


The patch titled
     Subject: mm-document-improved-handling-of-swappiness==0-fix
has been added to the -mm tree.  Its filename is
     mm-document-improved-handling-of-swappiness==0-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-document-improved-handling-of-swappiness==0-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-document-improved-handling-of-swappiness==0-fix.patch

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
Subject: mm-document-improved-handling-of-swappiness==0-fix

remove comma, per Randy

Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-document-improved-handling-of-swappiness==0-fix Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-document-improved-handling-of-swappiness==0-fix
+++ a/Documentation/sysctl/vm.txt
@@ -697,7 +697,7 @@ swappiness
 This control is used to define how aggressive the kernel will swap
 memory pages.  Higher values will increase agressiveness, lower values
 decrease the amount of swap.  A value of 0 instructs the kernel not to
-initiate swap until the amount of free and file-backed pages, is less
+initiate swap until the amount of free and file-backed pages is less
 than the high water mark in a zone.
 
 The default value is 60.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
mm-document-improved-handling-of-swappiness==0-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

