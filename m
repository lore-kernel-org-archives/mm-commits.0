From: akpm@linux-foundation.org
Subject: + include-falloch-in-header-y.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:21:54 -0800
Message-ID: <200802272321.m1RNLsTZ003722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134AbYB0XWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:22:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com


The patch titled
     include falloc.h in header-y
has been added to the -mm tree.  Its filename is
     include-falloch-in-header-y.patch

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
Subject: include falloc.h in header-y
From: Eric Sandeen <sandeen@redhat.com>

Include falloc.h in header-y; it defines a flag for the fallocate sysctl.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/Kbuild~include-falloch-in-header-y include/linux/Kbuild
--- a/include/linux/Kbuild~include-falloch-in-header-y
+++ a/include/linux/Kbuild
@@ -61,6 +61,7 @@ header-y += efs_fs_sb.h
 header-y += elf-fdpic.h
 header-y += elf-em.h
 header-y += fadvise.h
+header-y += falloc.h
 header-y += fd.h
 header-y += fdreg.h
 header-y += fib_rules.h
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
include-falloch-in-header-y.patch
