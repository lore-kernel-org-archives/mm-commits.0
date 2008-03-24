From: akpm@linux-foundation.org
Subject: + kbuild-remove-duplicate-conflicting-entry-for-oomh.patch added to -mm tree
Date: Mon, 24 Mar 2008 14:53:07 -0700
Message-ID: <200803242153.m2OLr7br027237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbYCXVxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 17:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, dwmw2@infradead.org, sam@ravnborg.org


The patch titled
     kbuild: remove duplicate, conflicting entry for oom.h
has been added to the -mm tree.  Its filename is
     kbuild-remove-duplicate-conflicting-entry-for-oomh.patch

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
@@ -116,7 +116,6 @@ header-y += nfs2.h
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
git-ieee1394.patch
bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
git-nfsd.patch
git-sparc64.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch

