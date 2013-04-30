From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrolc-remove-unnecessary.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:02 -0700
Message-ID: <20130430184902.69E4731C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:59685 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3StD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:03 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so85009vbf.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: remove unnecessary ;
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-remove-unnecessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -5813,7 +5813,7 @@ static int memcg_init_kmem(struct mem_cg
 		return ret;
 
 	return mem_cgroup_sockets_init(memcg, ss);
-};
+}
 
 static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
 {
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
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
ipcsem-fine-grained-locking-for-semtimedop-fix-lockdep-false-positive.patch
rbtree_test-add-extra-rbtree-integrity-check.patch
rbtree_test-add-__init-__exit-annotations.patch
mutex-subsystem-synchro-test-module.patch

