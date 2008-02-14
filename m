From: akpm@linux-foundation.org
Subject: + maintainers-add-linux-fsdevel-to-vfs-entry.patch added to -mm tree
Date: Thu, 14 Feb 2008 12:16:25 -0800
Message-ID: <200802142016.m1EKGPvJ000783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60226 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754781AbYBNUQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 15:16:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com


The patch titled
     MAINTAINERS: add linux-fsdevel to VFS entry
has been added to the -mm tree.  Its filename is
     maintainers-add-linux-fsdevel-to-vfs-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

maintainers-add-linux-fsdevel-to-vfs-entry.patch
add-a-refcount-check-in-dput.patch
