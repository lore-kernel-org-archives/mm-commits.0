From: akpm@linux-foundation.org
Subject: [folded-merged]
 makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch removed from -mm tree
Date: Fri, 13 Sep 2013 13:30:43 -0700
Message-ID: <523375f3.1nEF0XVn3hS03spA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab3IMUao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slyfox@gentoo.org, mmarek@suse.cz, geert@linux-m68k.org, akpm@linux-foundation.org

Subject: [folded-merged] makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,geert@linux-m68k.org,mmarek@suse.cz,slyfox@gentoo.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:30:43 -0700


The patch titled
     Subject: makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix
has been removed from the -mm tree.  Its filename was
     makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch

This patch was dropped because it was folded into makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix

fix typos in comments

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Makefile~makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix Makefile
--- a/Makefile~makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix
+++ a/Makefile
@@ -659,10 +659,10 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-s
 # conserve stack if available
 KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
 
-# disallog errors like 'EXPORT_GPL(foo);' with missing header
+# disallow errors like 'EXPORT_GPL(foo);' with missing header
 KBUILD_CFLAGS   += $(call cc-option,-Werror=implicit-int)
 
-# require functions to have argumens in prototypes, not empty 'int foo()'
+# require functions to have arguments in prototypes, not empty 'int foo()'
 KBUILD_CFLAGS   += $(call cc-option,-Werror=strict-prototypes)
 
 # use the deterministic mode of AR if available
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

