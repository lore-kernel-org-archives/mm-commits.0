From: akpm@linux-foundation.org
Subject: [merged] blackfin-bf533-stamp-add-linux-delayh.patch removed from -mm tree
Date: Mon, 12 Jan 2015 11:33:22 -0800
Message-ID: <54b42182.oNhHrMjCSlIZ3tom%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbbALTdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 14:33:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, fengguang.wu@intel.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/blackfin/mach-bf533/boards/stamp.c: add linux/delay.h
has been removed from the -mm tree.  Its filename was
     blackfin-bf533-stamp-add-linux-delayh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
linux-next.patch

