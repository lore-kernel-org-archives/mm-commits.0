From: akpm@linux-foundation.org
Subject: [merged] fs-kill-config_percpu_rwsem-some-more.patch
 removed from -mm tree
Date: Thu, 13 Jul 2017 13:40:51 -0700
Message-ID: <20170713204051.KPSfYwc0E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753095AbdGMUkw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org, oleg@redhat.com


The patch titled
     Subject: fs/Kconfig: kill CONFIG_PERCPU_RWSEM some more
has been removed from the -mm tree.  Its filename was
     fs-kill-config_percpu_rwsem-some-more.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: fs/Kconfig: kill CONFIG_PERCPU_RWSEM some more

As of bf3eac84c42 ("percpu-rwsem: kill CONFIG_PERCPU_RWSEM") we
unconditionally build pcpu-rwsems.  Remove a leftover in for FILE_LOCKING.

Link: http://lkml.kernel.org/r/20170518180115.2794-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/Kconfig~fs-kill-config_percpu_rwsem-some-more fs/Kconfig
--- a/fs/Kconfig~fs-kill-config_percpu_rwsem-some-more
+++ a/fs/Kconfig
@@ -80,7 +80,6 @@ config EXPORTFS_BLOCK_OPS
 config FILE_LOCKING
 	bool "Enable POSIX file locking API" if EXPERT
 	default y
-	select PERCPU_RWSEM
 	help
 	  This option enables standard file locking support, required
           for filesystems like NFS and for the flock() system
_

Patches currently in -mm which might be from dave@stgolabs.net are


