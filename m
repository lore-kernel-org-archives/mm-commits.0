From: akpm@linux-foundation.org
Subject: [folded] prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:20:00 -0700
Message-ID: <20120323212001.15C83A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:36677 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab2CWVUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:20:03 -0400
Received: by wgbdt11 with SMTP id dt11so119762wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:20:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, kay.sievers@vrfy.org, lennart@poettering.net, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix
has been removed from the -mm tree.  Its filename was
     prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch

This patch was dropped because it was folded into prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix

fix comment layout and spelling

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix kernel/exit.c
--- a/kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix
+++ a/kernel/exit.c
@@ -688,10 +688,9 @@ static void exit_mm(struct task_struct *
 
 /*
  * When we die, we re-parent all our children, and try to:
- * 1. give them to another thread in our thread group, if such a
- *    member exists
- * 2. give it to the first anchestor process which prctl'd itself
- *    as a child_subreaper for its children (like a service manager)
+ * 1. give them to another thread in our thread group, if such a member exists
+ * 2. give it to the first ancestor process which prctl'd itself as a
+ *    child_subreaper for its children (like a service manager)
  * 3. give it to the init process (PID 1) in our pid namespace
  */
 static struct task_struct *find_new_reaper(struct task_struct *father)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch

