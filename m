From: akpm@linux-foundation.org
Subject: +
 initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix.patch added to -mm tree
Date: Mon, 29 Jul 2013 13:03:51 -0700
Message-ID: <51f6caa7.s/7lfAl9L1deuoRJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3G2UDv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 16:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net

Subject: + initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix.patch added to -mm tree
To: rob@landley.net
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 13:03:51 -0700


The patch titled
     Subject: initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix
has been added to the -mm tree.  Its filename is
     initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
initmpfs-replace-ms_nouser-in-initramfs.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-move-rootfs-code-from-fs-ramfs-to-init.patch
initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch

