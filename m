From: akpm@linux-foundation.org
Subject: + add-fiemaph-to-header-y.patch added to -mm tree
Date: Wed, 01 Apr 2009 16:25:52 -0700
Message-ID: <200904012325.n31NPqkr026304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935858AbZDAX1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 19:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com


The patch titled
     add fiemap.h to header-y
has been added to the -mm tree.  Its filename is
     add-fiemaph-to-header-y.patch

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
Subject: add fiemap.h to header-y
From: Eric Sandeen <sandeen@redhat.com>

Include fiemap.h in header-y; it defines the interface for the
FS_IOC_FIEMAP file mapping ioctl.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/Kbuild~add-fiemaph-to-header-y include/linux/Kbuild
--- a/include/linux/Kbuild~add-fiemaph-to-header-y
+++ a/include/linux/Kbuild
@@ -67,6 +67,7 @@ header-y += falloc.h
 header-y += fd.h
 header-y += fdreg.h
 header-y += fib_rules.h
+header-y += fiemap.h
 header-y += firewire-cdev.h
 header-y += firewire-constants.h
 header-y += fuse.h
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
add-fiemaph-to-header-y.patch

