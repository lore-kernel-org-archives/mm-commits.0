From: akpm@linux-foundation.org
Subject: + blackfin-bf533-stamp-add-linux-delayh.patch added to -mm tree
Date: Tue, 06 Jan 2015 16:23:10 -0800
Message-ID: <54ac7c6e.6IbQrFxK80Yka/e3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbbAGAXL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 19:23:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, fengguang.wu@intel.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/blackfin/mach-bf533/boards/stamp.c: add linux/delay.h
has been added to the -mm tree.  Its filename is
     blackfin-bf533-stamp-add-linux-delayh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/blackfin-bf533-stamp-add-linux-delayh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/blackfin-bf533-stamp-add-linux-delayh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: arch/blackfin/mach-bf533/boards/stamp.c: add linux/delay.h

build error
arch/blackfin/mach-bf533/boards/stamp.c:834:2: error: implicit declaration of function 'mdelay'

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mach-bf533/boards/stamp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/blackfin/mach-bf533/boards/stamp.c~blackfin-bf533-stamp-add-linux-delayh arch/blackfin/mach-bf533/boards/stamp.c
--- a/arch/blackfin/mach-bf533/boards/stamp.c~blackfin-bf533-stamp-add-linux-delayh
+++ a/arch/blackfin/mach-bf533/boards/stamp.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
_

Patches currently in -mm which might be from oleg@redhat.com are

exit-fix-race-between-wait_consider_task-and-wait_task_zombie.patch
blackfin-bf533-stamp-add-linux-delayh.patch
oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
linux-next.patch

