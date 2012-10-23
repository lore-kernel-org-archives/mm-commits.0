From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-make-wait_queue_head_t-printk_log_wait-extern.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:04:31 -0700
Message-ID: <20121023200432.11DC720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:53932 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab2JWUEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:04:33 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so257461wey.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:04:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: make wait_queue_head_t printk_log_wait extern
has been removed from the -mm tree.  Its filename was
     printk-make-wait_queue_head_t-printk_log_wait-extern.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: make wait_queue_head_t printk_log_wait extern

Move the variable to the .h file too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk_log.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/printk/printk_log.h~printk-make-wait_queue_head_t-printk_log_wait-extern kernel/printk/printk_log.h
--- a/kernel/printk/printk_log.h~printk-make-wait_queue_head_t-printk_log_wait-extern
+++ a/kernel/printk/printk_log.h
@@ -93,6 +93,7 @@ struct printk_log {
 #define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 
 extern raw_spinlock_t printk_logbuf_lock;
+extern wait_queue_head_t printk_log_wait;
 extern u64 printk_log_first_seq;
 extern u32 printk_log_first_idx;
 extern u64 printk_log_next_seq;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-rename-and-move-2-defines-to-printk_logh.patch
printk-move-devkmsg-bits-to-separate-file.patch
printk-prefix-print_time-and-msg_print_text-with-printk_.patch
printk-move-functions-printk_print_time-and-printk_msg_print_text.patch
printk-add-printk_syslogc-and-h.patch
printk-add-printk_syslogc-and-h-fix.patch
printk-move-kmsg_dump-functions-to-separate-file.patch
maintainers-networking-drivers-matches-too-much.patch
checkpatch-improve-network-block-comment-style-checking.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

