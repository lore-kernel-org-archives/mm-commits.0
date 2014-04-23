From: akpm@linux-foundation.org
Subject: + fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch added to -mm
 tree
Date: Wed, 23 Apr 2014 15:09:20 -0700
Message-ID: <53583a10.peoj9pTLibm52Opn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaDWWJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Apr 2014 18:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rminnich@sandia.gov, ericvh@gmail.com, fabf@skynet.be

Subject: + fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch added to -mm tree
To: fabf@skynet.be,ericvh@gmail.com,rminnich@sandia.gov
From: akpm@linux-foundation.org
Date: Wed, 23 Apr 2014 15:09:20 -0700


The patch titled
     Subject: fs/9p/v9fs.c: add __init to v9fs_sysfs_init
has been added to the -mm tree.  Its filename is
     fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch

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
Subject: fs/9p/v9fs.c: add __init to v9fs_sysfs_init

v9fs_sysfs_init is only called by __init init_v9fs

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/v9fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/9p/v9fs.c~fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init fs/9p/v9fs.c
--- a/fs/9p/v9fs.c~fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init
+++ a/fs/9p/v9fs.c
@@ -537,7 +537,7 @@ static struct attribute_group v9fs_attr_
  *
  */
 
-static int v9fs_sysfs_init(void)
+static int __init v9fs_sysfs_init(void)
 {
 	v9fs_kobj = kobject_create_and_add("9p", fs_kobj);
 	if (!v9fs_kobj)
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-isofs-logging-clean-up.patch

