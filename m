From: akpm@linux-foundation.org
Subject: [folded-merged]
 initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix.patch removed
 from -mm tree
Date: Wed, 11 Sep 2013 14:06:45 -0700
Message-ID: <5230db65.MHVCHQWjOeCVqOp/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab3IKVGp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:06:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net

Subject: [folded-merged] initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix.patch removed from -mm tree
To: rob@landley.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:06:45 -0700


The patch titled
     Subject: initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix
has been removed from the -mm tree.  Its filename was
     initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix.patch

This patch was dropped because it was folded into initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch

------------------------------------------------------
From: Rob Landley <rob@landley.net>
Subject: initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix

Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/ramfs-rootfs-initramfs.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/filesystems/ramfs-rootfs-initramfs.txt~initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix Documentation/filesystems/ramfs-rootfs-initramfs.txt
--- a/Documentation/filesystems/ramfs-rootfs-initramfs.txt~initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix
+++ a/Documentation/filesystems/ramfs-rootfs-initramfs.txt
@@ -79,6 +79,10 @@ to just make sure certain lists can't be
 Most systems just mount another filesystem over rootfs and ignore it.  The
 amount of space an empty instance of ramfs takes up is tiny.
 
+If CONFIG_TMPFS is enabled, rootfs will use tmpfs instead of ramfs by
+default.  To force ramfs, add "rootfstype=ramfs" to the kernel command
+line.
+
 What is initramfs?
 ------------------
 
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
mm-track-vma-changes-with-vm_softdirty-bit.patch
drivers-rtc-rtc-omapc-add-rtc-wakeup-support-to-alarm-events.patch
initmpfs-replace-ms_nouser-in-initramfs.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch
initmpfs-move-rootfs-code-from-fs-ramfs-to-init.patch
initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch

