From: akpm@linux-foundation.org
Subject: [folded-merged]
 taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch removed from -mm
 tree
Date: Mon, 08 May 2017 15:39:21 -0700
Message-ID: <5910f399.K1E7WuV1wgRBw0oH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdEHWj0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:39:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bsingharora@gmail.com, oleg@redhat.com, xiao.zhang@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats-add-e-u-stime-for-tgid-command-fix-fix
has been removed from the -mm tree.  Its filename was
     taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch

This patch was dropped because it was folded into taskstats-add-e-u-stime-for-tgid-command.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: taskstats-add-e-u-stime-for-tgid-command-fix-fix

include linux/sched/cputime.h for task_cputime()

Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Zhang Xiao <xiao.zhang@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/taskstats.c~taskstats-add-e-u-stime-for-tgid-command-fix-fix kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-add-e-u-stime-for-tgid-command-fix-fix
+++ a/kernel/taskstats.c
@@ -30,6 +30,7 @@
 #include <linux/pid_namespace.h>
 #include <net/genetlink.h>
 #include <linux/atomic.h>
+#include <linux/sched/cputime.h>
 
 /*
  * Maximum length of a cpumask that can be specified in
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

taskstats-add-e-u-stime-for-tgid-command.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
dax-add-tracepoint-to-dax_writeback_one-fix.patch
drivers-staging-ccree-ssi_hashc-fix-build-with-gcc-444.patch

