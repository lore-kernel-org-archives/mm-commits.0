From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-ptrace-entry.patch removed from -mm tree
Date: Mon, 04 May 2009 13:12:33 -0700
Message-ID: <200905042012.n44KCX4n021968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbZEDUQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, joe@perches.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add ptrace entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-ptrace-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add ptrace entry
From: Christoph Hellwig <hch@lst.de>

Add Roland and Oleg as formal ptrace maintainers, they've been doing the
job for a while.

Includes the file patterns requested by Joe.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN MAINTAINERS~maintainers-add-ptrace-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-add-ptrace-entry
+++ a/MAINTAINERS
@@ -4521,6 +4521,19 @@ M:	jim@jtan.com
 L:	cbe-oss-dev@ozlabs.org
 S:	Maintained
 
+PTRACE SUPPORT
+P:	Roland McGrath
+M:	roland@redhat.com
+P:	Oleg Nesterov
+M:	oleg@redhat.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	include/asm-generic/syscall.h
+F:	include/linux/ptrace.h
+F:	include/linux/regset.h
+F:	include/linux/tracehook.h
+F:	kernel/ptrace.c
+
 PVRUSB2 VIDEO4LINUX DRIVER
 P:	Mike Isely
 M:	isely@pobox.com
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
fsnotify-unified-filesystem-notification-backend.patch
fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes.patch
fsnotify-parent-event-notification.patch
dnotify-reimplement-dnotify-using-fsnotify.patch
fsnotify-generic-notification-queue-and-waitq.patch
fsnotify-include-pathnames-with-entries-when-possible.patch
fsnotify-add-correlations-between-events.patch
fsnotify-allow-groups-to-add-private-data-to-events.patch
fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch
fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch
inotify-reimplement-inotify-using-fsnotify.patch

