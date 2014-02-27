From: akpm@linux-foundation.org
Subject: +
 documentation-filesystems-ntfstxt-remove-changelog-reference.patch added to -mm tree
Date: Thu, 27 Feb 2014 14:49:39 -0800
Message-ID: <530fc103.+W38WuZapDHh94zW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaB0Wtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 17:49:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + documentation-filesystems-ntfstxt-remove-changelog-reference.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 14:49:39 -0800


The patch titled
     Subject: Documentation/filesystems/ntfs.txt: remove changelog reference
has been added to the -mm tree.  Its filename is
     documentation-filesystems-ntfstxt-remove-changelog-reference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-filesystems-ntfstxt-remove-changelog-reference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-filesystems-ntfstxt-remove-changelog-reference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: Documentation/filesystems/ntfs.txt: remove changelog reference

File was removed in 7c821a179f91c3 ("Remove fs/ntfs/ChangeLog").

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/ntfs.txt |    2 --
 1 file changed, 2 deletions(-)

diff -puN Documentation/filesystems/ntfs.txt~documentation-filesystems-ntfstxt-remove-changelog-reference Documentation/filesystems/ntfs.txt
--- a/Documentation/filesystems/ntfs.txt~documentation-filesystems-ntfstxt-remove-changelog-reference
+++ a/Documentation/filesystems/ntfs.txt
@@ -455,8 +455,6 @@ not have this problem with odd numbers o
 ChangeLog
 =========
 
-Note, a technical ChangeLog aimed at kernel hackers is in fs/ntfs/ChangeLog.
-
 2.1.30:
 	- Fix writev() (it kept writing the first segment over and over again
 	  instead of moving onto subsequent segments).
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-gfs2-quotac-replace-kmalloc-__vmalloc-memset-0.patch
fs-udf-superc-add-__init-to-init_inodecache.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
documentation-filesystems-ntfstxt-remove-changelog-reference.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch

