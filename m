From: akpm@linux-foundation.org
Subject: [obsolete] cgroups-add-a-task-counter-subsystem-fix.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:06:48 -0800
Message-ID: <20111214200648.BE84A1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:55233 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1LNUGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:06:49 -0500
Received: by mail-yw0-f74.google.com with SMTP id j51so241097yhj.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:06:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: ERR_PTR needs err.h
has been removed from the -mm tree.  Its filename was
     cgroups-add-a-task-counter-subsystem-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: cgroups: ERR_PTR needs err.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_task_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup_task_counter.c~cgroups-add-a-task-counter-subsystem-fix kernel/cgroup_task_counter.c
--- a/kernel/cgroup_task_counter.c~cgroups-add-a-task-counter-subsystem-fix
+++ a/kernel/cgroup_task_counter.c
@@ -8,11 +8,11 @@
  *
  */
 
+#include <linux/err.h>
 #include <linux/cgroup.h>
 #include <linux/slab.h>
 #include <linux/res_counter.h>
 
