From: akpm@linux-foundation.org
Subject: + nilfs2-fix-white-space-issue-in-nilfs_mount.patch added to -mm
 tree
Date: Fri, 29 Apr 2016 13:40:15 -0700
Message-ID: <5723c6af.6lNT4JfoD8ihmKZd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbcD2UkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 16:40:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix white space issue in nilfs_mount()
has been added to the -mm tree.  Its filename is
     nilfs2-fix-white-space-issue-in-nilfs_mount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-white-space-issue-in-nilfs_mount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-white-space-issue-in-nilfs_mount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix white space issue in nilfs_mount()

Fix the following checkpatch.pl error and warnings:

ERROR: code indent should use tabs where possible
#1317: FILE: super.c:1317:
+ ^I^Is_new = true;$

WARNING: please, no space before tabs
#1317: FILE: super.c:1317:
+ ^I^Is_new = true;$

WARNING: please, no spaces at the start of a line
#1317: FILE: super.c:1317:
+ ^I^Is_new = true;$

Link: http://lkml.kernel.org/r/1461935747-10380-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/super.c~nilfs2-fix-white-space-issue-in-nilfs_mount fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-fix-white-space-issue-in-nilfs_mount
+++ a/fs/nilfs2/super.c
@@ -1316,7 +1316,7 @@ nilfs_mount(struct file_system_type *fs_
 	}
 
 	if (!s->s_root) {
- 		s_new = true;
+		s_new = true;
 
 		/* New superblock instance created */
 		s->s_mode = mode;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-fix-white-space-issue-in-nilfs_mount.patch
nilfs2-remove-space-before-comma.patch
nilfs2-remove-fsf-mailing-address-from-gpl-notices.patch
nilfs2-clean-up-old-e-mail-addresses.patch
maintainers-add-web-link-for-nilfs-project.patch
nilfs2-clarify-permission-to-replicate-the-design.patch
nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty.patch
nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines.patch
nilfs2-replace-__attribute__packed-with-__packed.patch
nilfs2-add-missing-line-spacing.patch
nilfs2-clean-trailing-semicolons-in-macros.patch

