From: akpm@linux-foundation.org
Subject: + coredump-add-support-for-%d=__get_dumpable-in-core-name-fix.patch added to -mm tree
Date: Fri, 14 Sep 2012 12:31:01 -0700
Message-ID: <20120914193101.8BD571E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36642 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab2INTbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Sep 2012 15:31:03 -0400
Received: by qcqs25 with SMTP id s25so477759qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Sep 2012 12:31:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com


The patch titled
     Subject:  coredump-add-support-for-%d=__get_dumpable-in-core-name-fix
has been added to the -mm tree.  Its filename is
     coredump-add-support-for-%d=__get_dumpable-in-core-name-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject:  coredump-add-support-for-%d=__get_dumpable-in-core-name-fix

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~coredump-add-support-for-%d=__get_dumpable-in-core-name-fix Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~coredump-add-support-for-%d=__get_dumpable-in-core-name-fix
+++ a/Documentation/sysctl/kernel.txt
@@ -181,6 +181,8 @@ core_pattern is used to specify a core d
 	%p	pid
 	%u	uid
 	%g	gid
+	%d	dump mode, matches PR_SET_DUMPABLE and
+		/proc/sys/fs/suid_dumpable
 	%s	signal number
 	%t	UNIX time of dump
 	%h	hostname
_

Patches currently in -mm which might be from oleg@redhat.com are

pid-namespace-limit-value-of-ns_last_pid-to-0-max_pid.patch
linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch
coredump-add-support-for-%d=__get_dumpable-in-core-name.patch
coredump-add-support-for-%d=__get_dumpable-in-core-name-fix.patch

