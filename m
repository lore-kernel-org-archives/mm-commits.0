From: akpm@linux-foundation.org
Subject: - remove-superfluous-include-of-stringh-from-percpuh.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:44 -0700
Message-ID: <200804300540.m3U5eimZ028993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755759AbYD3FlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     Remove superfluous include of string.h from percpu.h
has been removed from the -mm tree.  Its filename was
     remove-superfluous-include-of-stringh-from-percpuh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove superfluous include of string.h from percpu.h
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

There's nothing in percpu.h that requires an explicit inclusion of
string.h.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/percpu.h~remove-superfluous-include-of-stringh-from-percpuh include/linux/percpu.h
--- a/include/linux/percpu.h~remove-superfluous-include-of-stringh-from-percpuh
+++ a/include/linux/percpu.h
@@ -4,7 +4,6 @@
 #include <linux/preempt.h>
 #include <linux/slab.h> /* For kmalloc() */
 #include <linux/smp.h>
-#include <linux/string.h> /* For memset() */
 #include <linux/cpumask.h>
 
 #include <asm/percpu.h>
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-dvb.patch
git-mtd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

