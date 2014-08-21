From: akpm@linux-foundation.org
Subject: + fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
 added to -mm tree
Date: Thu, 21 Aug 2014 14:58:58 -0700
Message-ID: <53f66ba2.6LBoS52WcILzWu52%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:44356 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbaHUV67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 17:58:59 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so1184783ykb.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 14:58:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, himangi774@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/stack_user.c: fix typo in ocfs2_control_release()
has been added to the -mm tree.  Its filename is
     fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/ocfs2/stack_user.c: fix typo in ocfs2_control_release()

It is supposed to zero pv_minor.

Reported-by: Himangi Saraogi <himangi774@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/stack_user.c~fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release
+++ a/fs/ocfs2/stack_user.c
@@ -591,7 +591,7 @@ static int ocfs2_control_release(struct
 		 */
 		ocfs2_control_this_node = -1;
 		running_proto.pv_major = 0;
-		running_proto.pv_major = 0;
+		running_proto.pv_minor = 0;
 	}
 
 out:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

