From: akpm@linux-foundation.org
Subject: + vfs-o_-bit-numbers-uniqueness-check-update.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:06:40 -0700
Message-ID: <201003192306.o2JN6eLq017516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab0CSXHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com


The patch titled
     vfs: O_* bit numbers uniqueness check
has been added to the -mm tree.  Its filename is
     vfs-o_-bit-numbers-uniqueness-check-update.patch

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
Subject: vfs: O_* bit numbers uniqueness check
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/fcntl.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/fcntl.h~vfs-o_-bit-numbers-uniqueness-check-update include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~vfs-o_-bit-numbers-uniqueness-check-update
+++ a/include/asm-generic/fcntl.h
@@ -4,8 +4,6 @@
 #include <linux/types.h>
 
 /*
- * When introducing new O_* bits, please check its uniqueness in fcntl_init().
- *
  * FMODE_EXEC is 0x20
  * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open
@@ -13,6 +11,10 @@
  * -Eric Paris
  */
 
+/*
+ * When introducing new O_* bits, please check its uniqueness in fcntl_init().
+ */
+
 #define O_ACCMODE	00000003
 #define O_RDONLY	00000000
 #define O_WRONLY	00000001
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-o_-bit-numbers-uniqueness-check-update.patch
vfs-o_-bit-numbers-uniqueness-check-fix.patch
vfs-o_-bit-numbers-uniqueness-check-fix-2.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vfs-add-super-operation-writeback_inodes.patch

