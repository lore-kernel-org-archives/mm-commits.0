From: akpm@linux-foundation.org
Subject: + mm-memcontrolc-remove-unnecessary.patch added to -mm tree
Date: Mon, 08 Apr 2013 13:56:48 -0700
Message-ID: <20130408205648.76FB831C3DD@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:61592 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965110Ab3DHU4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 16:56:53 -0400
Received: by mail-ia0-f201.google.com with SMTP id k25so474787iah.2
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 13:56:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com


The patch titled
     Subject: mm/memcontrol.c: remove unnecessary ;
has been added to the -mm tree.  Its filename is
     mm-memcontrolc-remove-unnecessary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm/memcontrol.c: remove unnecessary ;

Just a trivial issue I stumbled on while doing something else...

Signed-off-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-remove-unnecessary mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-remove-unnecessary
+++ a/mm/memcontrol.c
@@ -5814,7 +5814,7 @@ static int memcg_init_kmem(struct mem_cg
 		return ret;
 
 	return mem_cgroup_sockets_init(memcg, ss);
-};
+}
 
 static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
 {
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
rmap-recompute-pgoff-for-unmapping-huge-page.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-memcontrolc-remove-unnecessary.patch
mm-remove-free_area_cache.patch
ipc-remove-bogus-lock-comment-for-ipc_checkid.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipc-introduce-lockless-pre_down-ipcctl.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch
ipcsem-fine-grained-locking-for-semtimedop-fix.patch
mutex-subsystem-synchro-test-module.patch

