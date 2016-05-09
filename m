From: akpm@linux-foundation.org
Subject: + nilfs2-clean-trailing-semicolons-in-macros-fix.patch added to
 -mm tree
Date: Mon, 09 May 2016 12:03:07 -0700
Message-ID: <5730deeb.OLVImwMM2/ChFoaG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbcEITDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 15:03:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2-clean-trailing-semicolons-in-macros-fix
has been added to the -mm tree.  Its filename is
     nilfs2-clean-trailing-semicolons-in-macros-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-clean-trailing-semicolons-in-macros-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-clean-trailing-semicolons-in-macros-fix.patch

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
Subject: nilfs2-clean-trailing-semicolons-in-macros-fix

The above patch didn't modify the same style issue in nilfs2/sysfs.c.
This addition covers the remaining places.

Link: http://lkml.kernel.org/r/20160509.231703.1481729973362188932.konishi.ryusuke@lab.ntt.co.jp

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/sysfs.c~nilfs2-clean-trailing-semicolons-in-macros-fix fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-clean-trailing-semicolons-in-macros-fix
+++ a/fs/nilfs2/sysfs.c
@@ -68,7 +68,7 @@ static ssize_t nilfs_##name##_attr_store
 static const struct sysfs_ops nilfs_##name##_attr_ops = { \
 	.show	= nilfs_##name##_attr_show, \
 	.store	= nilfs_##name##_attr_store, \
-};
+}
 
 #define NILFS_DEV_INT_GROUP_TYPE(name, parent_name) \
 static void nilfs_##name##_attr_release(struct kobject *kobj) \
@@ -84,7 +84,7 @@ static struct kobj_type nilfs_##name##_k
 	.default_attrs	= nilfs_##name##_attrs, \
 	.sysfs_ops	= &nilfs_##name##_attr_ops, \
 	.release	= nilfs_##name##_attr_release, \
-};
+}
 
 #define NILFS_DEV_INT_GROUP_FNS(name, parent_name) \
 static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
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
nilfs2-clean-trailing-semicolons-in-macros-fix.patch

