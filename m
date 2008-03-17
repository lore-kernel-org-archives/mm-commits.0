From: akpm@linux-foundation.org
Subject: + remove-superfluous-include-of-stringh-from-percpuh.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:37:33 -0700
Message-ID: <200803172237.m2HMbXEZ001920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705AbYCQWiF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:38:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     Remove superfluous include of string.h from percpu.h
has been added to the -mm tree.  Its filename is
     remove-superfluous-include-of-stringh-from-percpuh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch

