From: akpm@linux-foundation.org
Subject: [folded-merged]
 oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 12:17:47 -0700
Message-ID: <55300adb.pIXexzFEr2AV0E2T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbDPTRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:17:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, rric@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix
has been removed from the -mm tree.  Its filename was
     oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch

This patch was dropped because it was folded into oprofile-reduce-mmap_sem-hold-for-mm-exe_file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix

export get_mm_exe_file for arch/x86/oprofile/oprofile.ko

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Robert Richter <rric@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/fork.c~oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix kernel/fork.c
--- a/kernel/fork.c~oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix
+++ a/kernel/fork.c
@@ -752,6 +752,7 @@ struct file *get_mm_exe_file(struct mm_s
 	rcu_read_unlock();
 	return exe_file;
 }
+EXPORT_SYMBOL(get_mm_exe_file);
 
 /**
  * get_task_mm - acquire a reference to the task's mm
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-find__bit-reimplementation.patch
checkpatch-match-more-world-writable-permissions.patch
binfmt_misc-simplify-entry_status.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc.patch
fs-fat-remove-unnecessary-includes.patch
kernel-forkc-avoid-division-by-zero.patch
doc-sysctl-kerneltxt-document-threads-max.patch
mm-rcu-protected-get_mm_exe_file.patch
affs-kstrdup-memory-handling.patch
kconfig-use-macros-which-are-already-defined.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch
documentation-spi-spidev_testc-fix-warning.patch

