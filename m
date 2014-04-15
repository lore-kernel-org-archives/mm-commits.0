From: akpm@linux-foundation.org
Subject: + init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
 added to -mm tree
Date: Tue, 15 Apr 2014 13:05:04 -0700
Message-ID: <534d90f0.A5kll/r8SurMdP3y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaDOUFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 16:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, rob@landley.net, richard.weinberger@gmail.com, prarit@redhat.com, peterz@infradead.org, mingo@kernel.org, jwboyer@fedoraproject.org, fweisbec@gmail.com, andi@firstfloor.org, akpm@linux-foundation.org

Subject: + init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch added to -mm tree
To: akpm@linux-foundation.org,andi@firstfloor.org,fweisbec@gmail.com,jwboyer@fedoraproject.org,mingo@kernel.org,peterz@infradead.org,prarit@redhat.com,richard.weinberger@gmail.com,rob@landley.net,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 13:05:04 -0700


The patch titled
     Subject: init-mainc-add-initcall_blacklist-kernel-parameter-fix
has been added to the -mm tree.  Its filename is
     init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch

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
Subject: init-mainc-add-initcall_blacklist-kernel-parameter-fix

tweak printk text

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~init-mainc-add-initcall_blacklist-kernel-parameter-fix init/main.c
--- a/init/main.c~init-mainc-add-initcall_blacklist-kernel-parameter-fix
+++ a/init/main.c
@@ -684,7 +684,7 @@ static int __init initcall_blacklist(cha
 	do {
 		str_entry = strsep(&str, ",");
 		if (str_entry) {
-			pr_debug("initcall blacklisted %s\n", str_entry);
+			pr_debug("blacklisting initcall %s\n", str_entry);
 			entry = alloc_bootmem(sizeof(*entry));
 			entry->buf = alloc_bootmem(strlen(str_entry) + 1);
 			strcpy(entry->buf, str_entry);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
wait-explain-the-shadowing-and-type-inconsistencies.patch
mips-export-flush_icache_range-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

