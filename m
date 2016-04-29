From: akpm@linux-foundation.org
Subject: + nilfs2-clean-trailing-semicolons-in-macros.patch added to -mm
 tree
Date: Fri, 29 Apr 2016 13:40:35 -0700
Message-ID: <5723c6c3.SyZ2fA5ROe0sLwC1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbcD2Ukg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 16:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: clean trailing semicolons in macros
has been added to the -mm tree.  Its filename is
     nilfs2-clean-trailing-semicolons-in-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-clean-trailing-semicolons-in-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-clean-trailing-semicolons-in-macros.patch

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
Subject: nilfs2: clean trailing semicolons in macros

Remove trailing semicolons from macros, as suggested by checkpatch.pl.

Link: http://lkml.kernel.org/r/1461935747-10380-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/nilfs2/sysfs.h~nilfs2-clean-trailing-semicolons-in-macros fs/nilfs2/sysfs.h
--- a/fs/nilfs2/sysfs.h~nilfs2-clean-trailing-semicolons-in-macros
+++ a/fs/nilfs2/sysfs.h
@@ -66,7 +66,7 @@ struct nilfs_##name##_attr { \
 			char *); \
 	ssize_t (*store)(struct kobject *, struct attribute *, \
 			 const char *, size_t); \
-};
+}
 
 NILFS_COMMON_ATTR_STRUCT(feature);
 
@@ -77,7 +77,7 @@ struct nilfs_##name##_attr { \
 			char *); \
 	ssize_t (*store)(struct nilfs_##name##_attr *, struct the_nilfs *, \
 			 const char *, size_t); \
-};
+}
 
 NILFS_DEV_ATTR_STRUCT(dev);
 NILFS_DEV_ATTR_STRUCT(segments);
@@ -93,7 +93,7 @@ struct nilfs_##name##_attr { \
 			char *); \
 	ssize_t (*store)(struct nilfs_##name##_attr *, struct nilfs_root *, \
 			 const char *, size_t); \
-};
+}
 
 NILFS_CP_ATTR_STRUCT(snapshot);
 
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

