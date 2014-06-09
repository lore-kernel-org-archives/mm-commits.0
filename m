From: akpm@linux-foundation.org
Subject: [merged] fs-proc-vmcorec-remove-null-assignment-on-static.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:34:37 -0700
Message-ID: <53960c4d.u7REjRsnAgOqkQSz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaFITej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:34:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, fabf@skynet.be

Subject: [merged] fs-proc-vmcorec-remove-null-assignment-on-static.patch removed from -mm tree
To: fabf@skynet.be,vgoyal@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:34:37 -0700


The patch titled
     Subject: fs/proc/vmcore.c: remove NULL assignment to static
has been removed from the -mm tree.  Its filename was
     fs-proc-vmcorec-remove-null-assignment-on-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/proc/vmcore.c: remove NULL assignment to static

Static values are automatically initialized to NULL.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/vmcore.c~fs-proc-vmcorec-remove-null-assignment-on-static fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~fs-proc-vmcorec-remove-null-assignment-on-static
+++ a/fs/proc/vmcore.c
@@ -42,7 +42,7 @@ static size_t elfnotes_sz;
 /* Total size of vmcore file. */
 static u64 vmcore_size;
 
-static struct proc_dir_entry *proc_vmcore = NULL;
+static struct proc_dir_entry *proc_vmcore;
 
 /*
  * Returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

