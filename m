From: akpm@linux-foundation.org
Subject: [folded] seq_file-add-seq_set_overflow-seq_overflow-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:33:23 -0700
Message-ID: <20120323213323.D1E95A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:57671 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab2CWVdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:33:24 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so566031ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:33:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eric.dumazet@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file-add-seq_set_overflow-seq_overflow-fix
has been removed from the -mm tree.  Its filename was
     seq_file-add-seq_set_overflow-seq_overflow-fix.patch

This patch was dropped because it was folded into seq_file-add-seq_set_overflow-seq_overflow.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: seq_file-add-seq_set_overflow-seq_overflow-fix

tweak code comment

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/seq_file.c~seq_file-add-seq_set_overflow-seq_overflow-fix fs/seq_file.c
--- a/fs/seq_file.c~seq_file-add-seq_set_overflow-seq_overflow-fix
+++ a/fs/seq_file.c
@@ -15,9 +15,9 @@
 
 
 /*
- * seq file has a buffer but it may overflow. At overflow, larger buffer
- * is re-allocated and all data will be printed, again.
- * Now, overflow check is done by m->count == m->size.
+ * seq_files have a buffer which can may overflow. When this happens a larger
+ * buffer is reallocated and all the data will be printed again.
+ * The overflow state is true when m->count == m->size.
  */
 static bool seq_overflow(struct seq_file *m)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
backlight-add-driver-for-bachmanns-ot200.patch
leds-lp5521-support-led-pattern-data.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch
rtc-rtc-driver-for-da9052-53-pmic-v1.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch
procfs-add-num_to_str-to-speed-up-proc-stat.patch
procfs-speed-up-proc-pid-stat-statm.patch
seq_file-add-seq_set_overflow-seq_overflow.patch

