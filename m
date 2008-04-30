From: akpm@linux-foundation.org
Subject: - kbuild-remove-duplicate-conflicting-entry-for-oomh.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:48 -0700
Message-ID: <200804300540.m3U5emua028999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760354AbYD3GMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, dwmw2@infradead.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: remove duplicate, conflicting entry for oom.h
has been removed from the -mm tree.  Its filename was
     kbuild-remove-duplicate-conflicting-entry-for-oomh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: remove duplicate, conflicting entry for oom.h
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

oom.h is already tagged for unifdef'ing, so its entry as a simple exportable
header should be deleted.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/Kbuild~kbuild-remove-duplicate-conflicting-entry-for-oomh include/linux/Kbuild
--- a/include/linux/Kbuild~kbuild-remove-duplicate-conflicting-entry-for-oomh
+++ a/include/linux/Kbuild
@@ -117,7 +117,6 @@ header-y += nfs2.h
 header-y += nfs4_mount.h
 header-y += nfs_mount.h
 header-y += nl80211.h
-header-y += oom.h
 header-y += param.h
 header-y += pci_regs.h
 header-y += pfkeyv2.h
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

