From: akpm@linux-foundation.org
Subject: - sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:48:42 -0700
Message-ID: <200710180848.l9I8mg6v002853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932333AbXJRIs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     kernel/sysctl_check.c must #include <linux/string.h>
has been removed from the -mm tree.  Its filename was
     sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch

This patch was dropped because it was folded into sysctl-error-on-bad-sysctl-tables.patch

------------------------------------------------------
Subject: kernel/sysctl_check.c must #include <linux/string.h>
From: Adrian Bunk <bunk@kernel.org>

  CC      kernel/sysctl_check.o
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/kernel/sysctl_check.c: In function 'sysctl_binary_lookup':
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/kernel/sysctl_check.c:1303: error: implicit declaration of function 'strcmp'
make[2]: *** [kernel/sysctl_check.o] Error 1

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN kernel/sysctl_check.c~sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh
+++ a/kernel/sysctl_check.c
@@ -3,6 +3,7 @@
 #include "../arch/s390/appldata/appldata.h"
 #include "../fs/xfs/linux-2.6/xfs_sysctl.h"
 #include <linux/sunrpc/debug.h>
+#include <linux/string.h>
 #include <net/ip_vs.h>
 
 struct trans_ctl_table {
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
alpha-lock-bitops-fix.patch
