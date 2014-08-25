From: akpm@linux-foundation.org
Subject: [merged] watchdog-remove-unnecessary-head-files.patch removed
 from -mm tree
Date: Mon, 25 Aug 2014 12:27:20 -0700
Message-ID: <53fb8e18.l1j+A2MsuiMAVWbS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:44200 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaHYT1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Aug 2014 15:27:21 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so3680812pdj.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2014 12:27:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaiw.fnst@cn.fujitsu.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: remove unnecessary header files
has been removed from the -mm tree.  Its filename was
     watchdog-remove-unnecessary-head-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: kernel/watchdog.c: remove unnecessary header files

Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN kernel/watchdog.c~watchdog-remove-unnecessary-head-files kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-remove-unnecessary-head-files
+++ a/kernel/watchdog.c
@@ -15,11 +15,6 @@
 #include <linux/cpu.h>
 #include <linux/nmi.h>
 #include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/freezer.h>
-#include <linux/kthread.h>
-#include <linux/lockdep.h>
-#include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
 #include <linux/smpboot.h>
_

Patches currently in -mm which might be from chaiw.fnst@cn.fujitsu.com are

linux-next.patch
softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu.patch

