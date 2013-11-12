From: akpm@linux-foundation.org
Subject: [folded-merged]
 init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch removed from -mm tree
Date: Tue, 12 Nov 2013 14:42:40 -0800
Message-ID: <5282aee0.mUeiI74LWjbIfjh8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab3KLWml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:42:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, prasad@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,prasad@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:42:40 -0800


The patch titled
     Subject: init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix
has been removed from the -mm tree.  Its filename was
     init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch

This patch was dropped because it was folded into init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix

mention that the problem is with the ramdisk, don't print known-to-be-NULL value

Cc: P J P <prasad@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_rd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/do_mounts_rd.c~init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix
+++ a/init/do_mounts_rd.c
@@ -344,8 +344,8 @@ static int __init crd_load(int in_fd, in
 	crd_outfd = out_fd;
 
 	if (!deco) {
-		pr_emerg("Invalid decompression routine: %p; "
-				 "Select appropriate config option.\n", deco);
+		pr_emerg("Invalid ramdisk decompression routine.  "
+			 "Select appropriate config option.\n");
 		panic("Could not decompress initial ramdisk image.");
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-factor-commit-limit-calculation.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch

