From: akpm@linux-foundation.org
Subject: - include-falloch-in-header-y.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:47 -0800
Message-ID: <200803050744.m257ilhG021538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765054AbYCEHp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     include falloc.h in header-y
has been removed from the -mm tree.  Its filename was
     include-falloch-in-header-y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


