From: akpm@linux-foundation.org
Subject: [folded-merged] binfmt_misc-simplify-entry_status-fix.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 12:01:13 -0700
Message-ID: <553006f9.Sr7WIoP8ATNjBBVI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbbDPTBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:01:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_misc-simplify-entry_status-fix
has been removed from the -mm tree.  Its filename was
     binfmt_misc-simplify-entry_status-fix.patch

This patch was dropped because it was folded into binfmt_misc-simplify-entry_status.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: binfmt_misc-simplify-entry_status-fix

it's odd to include kernel.h after everything else

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-simplify-entry_status-fix fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-simplify-entry_status-fix
+++ a/fs/binfmt_misc.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
@@ -24,7 +25,6 @@
 #include <linux/syscalls.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
-#include <linux/kernel.h>
 
 #ifdef DEBUG
 # define USE_DEBUG 1
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-find__bit-reimplementation.patch
checkpatch-match-more-world-writable-permissions.patch
binfmt_misc-simplify-entry_status.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch

