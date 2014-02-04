From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 04 Feb 2014 12:03:44 -0800
Message-ID: <52f147a0.QQxwHcQzECXk1VXA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166AbaBDUDp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 15:03:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 12:03:44 -0800


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/elf.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/parisc/include/asm/elf.h~linux-next-git-rejects arch/parisc/include/asm/elf.h
--- a/arch/parisc/include/asm/elf.h~linux-next-git-rejects
+++ a/arch/parisc/include/asm/elf.h
@@ -348,12 +348,9 @@ struct pt_regs;	/* forward declaration..
 
 #define ELF_HWCAP	0
 
-<<<<<<< HEAD
-=======
 /* Stack randomization: 1GB for 64bit, 8MB for 32bit */
 #define STACK_RND_MASK (is_32bit_task() ? 0x7ff : 0x3fffff)
 
->>>>>>> linux-next/akpm-base
 struct mm_struct;
 extern unsigned long arch_randomize_brk(struct mm_struct *);
 #define arch_randomize_brk arch_randomize_brk
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

