From: akpm@linux-foundation.org
Subject: + doc-document-the-relax_domain_level-kernel-boot-argument-correct-default.patch added to -mm tree
Date: Wed, 02 Jul 2008 12:59:38 -0700
Message-ID: <200807021959.m62Jxcox001009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbYGBT7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 15:59:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, lizf@cn.fujitsu.com, mtk.manpages@googlemail.com


The patch titled
     doc: document the relax_domain_level kernel boot argument: correct default
has been added to the -mm tree.  Its filename is
     doc-document-the-relax_domain_level-kernel-boot-argument-correct-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: document the relax_domain_level kernel boot argument: correct default
From: Paul Jackson <pj@sgi.com>

Correct the stated system default for the kernel boot
option relax_domain_level=.

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/cpusets.txt~doc-document-the-relax_domain_level-kernel-boot-argument-correct-default Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~doc-document-the-relax_domain_level-kernel-boot-argument-correct-default
+++ a/Documentation/cpusets.txt
@@ -546,8 +546,8 @@ otherwise initial value -1 that indicate
  ( 4  : search nodes in a chunk of node [on NUMA system] )
  ( 5  : search system wide [on NUMA system] )
 
-The system default is 0 (no search).  The system default can be
-changed using the relax_domain_level= boot parameter.
+The system default is architecture dependent.  The system default
+can be changed using the relax_domain_level= boot parameter.
 
 This file is per-cpuset and affect the sched domain where the cpuset
 belongs to.  Therefore if the flag 'sched_load_balance' of a cpuset
_

Patches currently in -mm which might be from pj@sgi.com are

cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup.patch
cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup-fix.patch
cpusets-document-proc-status-cpus-and-mems-allowed-lists.patch
doc-document-the-relax_domain_level-kernel-boot-argument.patch
doc-document-the-relax_domain_level-kernel-boot-argument-fix.patch
doc-document-the-relax_domain_level-kernel-boot-argument-correct-default.patch
linux-next.patch
cgroup-files-clean-up-whitespace-in-struct-cftype.patch
cgroup-files-add-write_string-cgroup-control-file-method.patch
cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch
cgroups-misc-cleanups-to-write_string-patchset.patch
cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch
cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch
cgroup-files-remove-cpuset_common_file_write.patch
cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch

