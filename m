From: akpm@linux-foundation.org
Subject: - maintainers-add-linux-fsdevel-to-vfs-entry.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:11 -0500
Message-ID: <200802150719.m1F7JXo7025714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762648AbYBOHUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:20:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add linux-fsdevel to VFS entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-linux-fsdevel-to-vfs-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add linux-fsdevel to VFS entry
From: Paul Menage <menage@google.com>

Add linux-fsdevel to the VFS entry in MAINTAINERS

Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-linux-fsdevel-to-vfs-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-add-linux-fsdevel-to-vfs-entry
+++ a/MAINTAINERS
@@ -1616,6 +1616,7 @@ S:	Maintained
 FILESYSTEMS (VFS and infrastructure)
 P:	Alexander Viro
 M:	viro@zeniv.linux.org.uk
+L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 
 FIREWIRE SUBSYSTEM (drivers/firewire, <linux/firewire*.h>)
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
add-a-refcount-check-in-dput.patch
