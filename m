From: akpm@linux-foundation.org
Subject: [folded-merged]
 =?US-ASCII?Q?doc-cgroup-update-note-about-conditions-when-oom-killer-is-i?=
 =?US-ASCII?Q?nvoked-fix.patch?= removed from -mm tree
Date: Sun, 07 Jun 2020 21:21:06 -0700
Message-ID: <20200608042106.ELvN3AUhk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgFHEVI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, khlebnikov@yandex-team.ru, mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix
has been removed from the -mm tree.  Its filename was
     doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch

This patch was dropped because it was folded into doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix

fixes per Randy

Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1170,8 +1170,8 @@ PAGE_SIZE multiple when read back.
 	Under certain circumstances, the usage may go over the limit
 	temporarily.
 
-	In default configuration regular 0-order allocation always
-	succeed unless OOM killer choose current task as a victim.
+	In default configuration regular 0-order allocations always
+	succeed unless OOM killer chooses current task as a victim.
 
 	Some kinds of allocations don't invoke the OOM killer.
 	Caller could retry them differently, return into userspace
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
