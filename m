From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-me-as-the-get_maintainerpl-maintainer.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:41:53 -0700
Message-ID: <5390c801.yOEpMi9/BTB1MPfy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaFETly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] maintainers-add-me-as-the-get_maintainerpl-maintainer.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:41:53 -0700


The patch titled
     Subject: MAINTAINERS: add Joe as the get_maintainer.pl maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-me-as-the-get_maintainerpl-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: add Joe as the get_maintainer.pl maintainer

Might as well be the get_maintainer maintainer...

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~maintainers-add-me-as-the-get_maintainerpl-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-me-as-the-get_maintainerpl-maintainer
+++ a/MAINTAINERS
@@ -3882,6 +3882,11 @@ L:	kvm@vger.kernel.org
 S:	Supported
 F:	drivers/uio/uio_pci_generic.c
 
+GET_MAINTAINER SCRIPT
+M:	Joe Perches <joe@perches.com>
+S:	Maintained
+F:	scripts/get_maintainer.pl
+
 GFS2 FILE SYSTEM
 M:	Steven Whitehouse <swhiteho@redhat.com>
 L:	cluster-devel@redhat.com
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch
linux-next.patch
arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
scsi-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
inotify-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
maintainers-add-linux-api-for-review-of-api-abi-changes.patch

