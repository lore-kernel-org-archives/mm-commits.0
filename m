From: akpm@linux-foundation.org
Subject: [merged] autofs-remove-wrong-comment.patch removed from -mm tree
Date: Tue, 28 Feb 2017 12:49:42 -0800
Message-ID: <58b5e266.N0DEH735eXUumqR5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54468 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751713AbdB1VQp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 16:16:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkusumi@tuxera.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove wrong comment
has been removed from the -mm tree.  Its filename was
     autofs-remove-wrong-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: remove wrong comment

This format seems to have been taken from device mapper header, but autofs
has no such file:function in both kernel and userspace.

Link: http://lkml.kernel.org/r/148577164094.9801.4775075118014742496.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/auto_dev-ioctl.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/uapi/linux/auto_dev-ioctl.h~autofs-remove-wrong-comment include/uapi/linux/auto_dev-ioctl.h
--- a/include/uapi/linux/auto_dev-ioctl.h~autofs-remove-wrong-comment
+++ a/include/uapi/linux/auto_dev-ioctl.h
@@ -120,10 +120,6 @@ static inline void init_autofs_dev_ioctl
 	in->ioctlfd = -1;
 }
 
-/*
- * If you change this make sure you make the corresponding change
- * to autofs-dev-ioctl.c:lookup_ioctl()
- */
 enum {
 	/* Get various version info */
 	AUTOFS_DEV_IOCTL_VERSION_CMD = 0x71,
_

Patches currently in -mm which might be from tkusumi@tuxera.com are


