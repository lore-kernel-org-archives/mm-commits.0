From: akpm@linux-foundation.org
Subject: [merged] add-fiemaph-to-header-y.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:39 -0700
Message-ID: <200904061932.n36JWdAa010800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081AbZDFTex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     add fiemap.h to header-y
has been removed from the -mm tree.  Its filename was
     add-fiemaph-to-header-y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

