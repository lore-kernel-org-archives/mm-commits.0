From: akpm@linux-foundation.org
Subject: [merged]
 move-exit_task_namespaces-outside-of-exit_notify-fix.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:48:29 -0700
Message-ID: <52321a8d.UmVvgdwpcQ+Hxkak%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3ILTsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:48:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, ebiederm@xmission.com, avagin@openvz.org, akpm@linux-foundation.org

Subject: [merged] move-exit_task_namespaces-outside-of-exit_notify-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,avagin@openvz.org,ebiederm@xmission.com,oleg@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:48:29 -0700


The patch titled
     Subject: fs/file_table.c:fput(): make comment more truthful
has been removed from the -mm tree.  Its filename was
     move-exit_task_namespaces-outside-of-exit_notify-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/file_table.c:fput(): make comment more truthful

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/file_table.c~move-exit_task_namespaces-outside-of-exit_notify-fix fs/file_table.c
--- a/fs/file_table.c~move-exit_task_namespaces-outside-of-exit_notify-fix
+++ a/fs/file_table.c
@@ -311,8 +311,7 @@ void fput(struct file *file)
 				return;
 			/*
 			 * After this task has run exit_task_work(),
-			 * task_work_add() will fail.  free_ipc_ns()->
-			 * shm_destroy() can do this.  Fall through to delayed
+			 * task_work_add() will fail.  Fall through to delayed
 			 * fput to avoid leaking *file.
 			 */
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
mm.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

