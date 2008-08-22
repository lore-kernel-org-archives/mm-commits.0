From: akpm@linux-foundation.org
Subject: + container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch added to -mm tree
Date: Fri, 22 Aug 2008 13:40:00 -0700
Message-ID: <200808222040.m7MKe0KV015434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbYHVUlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 16:41:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthltc@us.ibm.com, clg@fr.ibm.com, pavel@suse.cz, rjw@sisk.pl, serue@us.ibm.com


The patch titled
     container freezer: cleanup comment.
has been added to the -mm tree.  Its filename is
     container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch

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
Subject: container freezer: cleanup comment.
From: Matt Helsley <matthltc@us.ibm.com>

Make this comment clearer.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup_freezer.c~container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment
+++ a/kernel/cgroup_freezer.c
@@ -61,8 +61,8 @@ int cgroup_frozen(struct task_struct *ta
 }
 
 /*
- * Buffer size for freezer state is limited by cgroups write_string()
- * interface. See cgroups code for the current size.
+ * cgroups_write_string() limits the size of freezer state strings to
+ * CGROUP_LOCAL_BUFFER_SIZE
  */
 static const char *freezer_state_strs[] = {
 	"RUNNING",
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-implement-freezer-cgroup-subsystem.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
container-freezer-prevent-frozen-tasks-or-cgroups-from-changing.patch
container-freezer-make-freezer-state-names-less-generic.patch
container-freezer-rename-check_if_frozen.patch
container-freezer-document-the-cgroup-freezer-subsystem.patch

